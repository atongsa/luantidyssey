-- Suitors walk the approach and hurt the hall if they arrive.
-- One of them is the lead suitor: more life, meant to be killed with a skill.
-- Wave 1 is the first band. Wave 3 is the last band, started by the carrying ship.

local WAY = {
	{x = 0, y = 10, z = 24},
	{x = 0, y = 10, z = 14},
	{x = 0, y = 10, z = 4},
}

function ml.clear_suitors()
	for _, obj in ipairs(minetest.get_objects_inside_radius({x = 0, y = 10, z = 16}, 80)) do
		local ent = obj:get_luaentity()
		if ent and ent.name == "ml_creeps:suitor" then
			obj:remove()
		end
	end
end

function ml.stun_looked(player, seconds)
	local pos = player:get_pos()
	local look = player:get_look_dir()
	local best, best_d
	for _, obj in ipairs(minetest.get_objects_inside_radius(pos, 14)) do
		local ent = obj:get_luaentity()
		if ent and ent.name == "ml_creeps:suitor" and not ent.dead then
			local to = vector.subtract(obj:get_pos(), pos)
			local dist = vector.length(to)
			if dist > 0.2 then
				local dot = vector.dot(vector.normalize(to), look)
				if dot > 0.35 and (not best_d or dist < best_d) then
					best, best_d = ent, dist
				end
			end
		end
	end
	if not best then
		return false
	end
	best.stun_until = minetest.get_us_time() + seconds * 1000000
	local tag = best.boss and "lead suitor" or "suitor"
	best.object:set_nametag_attributes({text = tag .. " (stopped)", color = {a = 255, r = 180, g = 180, b = 255}})
	return true
end

local function kill_credit(self, puncher)
	if self.dead then
		return
	end
	self.dead = true
	if puncher and puncher:is_player() then
		ml.add_xp(puncher, self.boss and 15 or 8)
		ml.add_gold(puncher, self.boss and 8 or 3)
	end
	ml.creep_down()
	if self.object then
		self.object:remove()
	end
end

minetest.register_entity("ml_creeps:suitor", {
	initial_properties = {
		visual = "cube",
		textures = {
			"ml_pixel.png^[colorize:#3a2428:255",
			"ml_pixel.png^[colorize:#3a2428:255",
			"ml_pixel.png^[colorize:#3a2428:255",
			"ml_pixel.png^[colorize:#3a2428:255",
			"ml_pixel.png^[colorize:#3a2428:255",
			"ml_pixel.png^[colorize:#3a2428:255",
		},
		visual_size = {x = 0.7, y = 1.4},
		physical = false,
		collide_with_objects = false,
		pointable = true,
		hp_max = 60,
		nametag = "suitor",
	},
	on_activate = function(self, staticdata)
		self.object:set_armor_groups({fleshy = 100})
		self.i = 1
		self.acc = 0
		self.hit_acc = 0
		self.dead = false
		self.stun_until = 0
		if staticdata == "lead" then
			self.boss = true
			self.object:set_hp(48)
			self.object:set_properties({
				visual_size = {x = 1.15, y = 2.1},
				nametag = "lead suitor",
				textures = {
					"ml_pixel.png^[colorize:#1a1018:255",
					"ml_pixel.png^[colorize:#1a1018:255",
					"ml_pixel.png^[colorize:#1a1018:255",
					"ml_pixel.png^[colorize:#1a1018:255",
					"ml_pixel.png^[colorize:#1a1018:255",
					"ml_pixel.png^[colorize:#1a1018:255",
				},
			})
		else
			self.boss = false
			self.object:set_hp(20)
		end
	end,
	get_staticdata = function(self)
		return self.boss and "lead" or ""
	end,
	on_step = function(self, dtime)
		if self.dead or ml.outcome() ~= "" then
			return
		end
		local pos = self.object:get_pos()
		self.hit_acc = (self.hit_acc or 0) + dtime
		if self.hit_acc > 1 then
			self.hit_acc = 0
			for _, player in ipairs(minetest.get_connected_players()) do
				if vector.distance(player:get_pos(), pos) < 1.8 and player:get_hp() > 0 then
					local dmg = 3
					if self.boss then
						dmg = 5
					end
					if ml.touch_damage then
						dmg = ml.touch_damage(player, 3, self.boss)
					end
					player:set_hp(player:get_hp() - dmg)
				end
			end
		end
		if (self.stun_until or 0) > minetest.get_us_time() then
			return
		end
		self.acc = self.acc + dtime
		if self.acc < 0.25 then
			return
		end
		self.acc = 0
		local goal = WAY[self.i]
		if not goal then
			return
		end
		if vector.distance(pos, goal) < 0.9 then
			self.i = self.i + 1
			if not WAY[self.i] then
				self.dead = true
				ml.damage_hall(self.boss and 50 or 30)
				ml.creep_down()
				self.object:remove()
				return
			end
			goal = WAY[self.i]
		end
		local dir = vector.direction(pos, goal)
		self.object:set_pos(vector.add(pos, vector.multiply(dir, self.boss and 0.65 or 0.85)))
		self.object:set_yaw(minetest.dir_to_yaw(dir))
	end,
	on_punch = function(self, puncher)
		if self.dead then
			return
		end
		local bonus = (ml.punch_bonus and ml.punch_bonus(puncher)) or 0
		if bonus > 0 and self.object:get_hp() > 0 then
			self.object:set_hp(self.object:get_hp() - bonus)
		end
		minetest.after(0, function()
			if self.dead or not self.object or not self.object:get_pos() then
				return
			end
			if self.object:get_hp() > 0 then
				return
			end
			kill_credit(self, puncher)
		end)
	end,
})

local prev_down = ml.creep_down
function ml.creep_down()
	if prev_down then
		prev_down()
	end
	if ml.storage:get_int("wave") == 3 and ml.storage:get_int("creeps_alive") == 0 then
		ml.storage:set_int("wave", 4)
		minetest.chat_send_all("The last suitors are gone. The hall step is open.")
		ml.check_end()
	end
end

function ml.schedule_wave()
	if ml.storage:get_int("wave") ~= 0 then
		return
	end
	if ml._wave_timer then
		return
	end
	ml._wave_timer = true
	minetest.after(12, function()
		ml._wave_timer = false
		if ml.storage:get_int("wave") ~= 0 then
			return
		end
		if ml.outcome() ~= "" then
			return
		end
		ml.clear_suitors()
		ml.storage:set_int("wave", 1)
		ml.storage:set_int("creeps_alive", 4)
		for n = -1, 1 do
			minetest.add_entity({x = n * 2, y = 10, z = 34}, "ml_creeps:suitor")
		end
		minetest.add_entity({x = 0, y = 10, z = 36}, "ml_creeps:suitor", "lead")
		minetest.chat_send_all("Three suitors and their lead are on the approach. Skills make the lead easy.")
	end)
end

function ml.start_last_wave()
	if ml.storage:get_int("wave") ~= 2 then
		return false
	end
	if ml.outcome() ~= "" then
		return false
	end
	ml.clear_suitors()
	ml.storage:set_int("wave", 3)
	ml.storage:set_int("creeps_alive", 5)
	for n = -2, 2 do
		if n ~= 0 then
			minetest.add_entity({x = n * 2, y = 10, z = 36}, "ml_creeps:suitor")
		end
	end
	minetest.add_entity({x = 0, y = 10, z = 38}, "ml_creeps:suitor", "lead")
	minetest.chat_send_all("The last suitors are on the approach.")
	return true
end

minetest.register_on_joinplayer(function()
	ml.schedule_wave()
end)
