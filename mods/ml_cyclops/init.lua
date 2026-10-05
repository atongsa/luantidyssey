-- Cyclops: a camp, then an escape. A straight duel does not end him.

local function put(x, y, z, name)
	minetest.set_node({x = x, y = y, z = z}, {name = name})
end

function ml.clear_cyclops()
	for _, obj in ipairs(minetest.get_objects_inside_radius({x = 10, y = 10, z = 21}, 40)) do
		local ent = obj:get_luaentity()
		if ent and ent.name == "ml_cyclops:cyclops" then
			obj:remove()
		end
	end
end

local function tell(player, text)
	if player and player:is_player() then
		minetest.chat_send_player(player:get_player_name(), text)
	end
end

local function near_cyclops(pos, radius)
	for _, obj in ipairs(minetest.get_objects_inside_radius(pos, radius)) do
		local ent = obj:get_luaentity()
		if ent and ent.name == "ml_cyclops:cyclops" and not ent.dead then
			return ent, obj
		end
	end
end

local function need_lotus(player)
	if ml.storage:get_int("lotus") == 1 then
		return true
	end
	tell(player, "Refuse the lotus first. His cave comes after that stop.")
	return false
end

minetest.register_node("ml_cyclops:wine", {
	description = "Bowl of wine",
	tiles = {"ml_olive.png"},
	drawtype = "nodebox",
	paramtype = "light",
	sunlight_propagates = true,
	groups = {not_in_creative_inventory = 1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.28, -0.5, -0.28, 0.28, -0.22, 0.28},
			{-0.2, -0.22, -0.2, 0.2, -0.02, 0.2},
		},
	},
	on_dig = function() end,
	on_rightclick = function(pos, node, clicker)
		if not need_lotus(clicker) then
			return
		end
		if ml.storage:get_int("wine") == 1 then
			tell(clicker, "He has already drunk.")
			return
		end
		if not near_cyclops(pos, 8) then
			tell(clicker, "He is not close enough to drink.")
			return
		end
		ml.storage:set_int("wine", 1)
		tell(clicker, "He drinks. He dulls. The stake can reach the eye now.")
	end,
})

minetest.register_node("ml_cyclops:stake", {
	description = "Olive stake",
	tiles = {"ml_bronze.png"},
	drawtype = "nodebox",
	paramtype = "light",
	sunlight_propagates = true,
	groups = {not_in_creative_inventory = 1},
	node_box = {
		type = "fixed",
		fixed = {-0.08, -0.5, -0.08, 0.08, 0.45, 0.08},
	},
	on_dig = function() end,
	on_rightclick = function(pos, node, clicker)
		if not need_lotus(clicker) then
			return
		end
		if ml.storage:get_int("blinded") == 1 then
			tell(clicker, "The eye is already shut. Find the mouth of the cave.")
			return
		end
		if ml.storage:get_int("wine") ~= 1 then
			tell(clicker, "He is awake. A stake does nothing to a watching giant.")
			return
		end
		if not near_cyclops(pos, 8) then
			tell(clicker, "Get him beside the stake.")
			return
		end
		ml.storage:set_int("blinded", 1)
		tell(clicker, "The stake finds the eye. He cannot see the mouth. Slip out.")
	end,
})

minetest.register_node("ml_cyclops:mouth", {
	description = "Cave mouth",
	tiles = {"ml_stone.png"},
	groups = {not_in_creative_inventory = 1},
	on_dig = function() end,
	on_rightclick = function(pos, node, clicker)
		if not clicker or not clicker:is_player() then
			return
		end
		if ml.outcome() ~= "" then
			return
		end
		if ml.storage:get_int("cyclops") == 1 then
			tell(clicker, "You already slipped out.")
			return
		end
		if ml.storage:get_int("blinded") ~= 1 then
			tell(clicker, "He can still see this mouth.")
			return
		end
		ml.storage:set_int("cyclops", 1)
		ml.add_xp(clicker, 20)
		ml.add_gold(clicker, 15)
		minetest.chat_send_all("Odysseus slips out of the cave. The giant cannot see which way. Next stop is not built: the bag of winds.")
		ml.check_end()
	end,
})

minetest.register_entity("ml_cyclops:cyclops", {
	initial_properties = {
		visual = "cube",
		textures = {
			"ml_stone.png",
			"ml_stone.png",
			"ml_stone.png",
			"ml_stone.png",
			"ml_stone.png",
			"ml_stone.png",
		},
		visual_size = {x = 1.6, y = 2.4},
		physical = false,
		collide_with_objects = false,
		pointable = true,
		hp_max = 80,
		nametag = "cyclops",
	},
	on_activate = function(self)
		self.object:set_armor_groups({fleshy = 100})
		self.object:set_hp(80)
		self.acc = 0
		self.hit_acc = 0
		self.dead = false
	end,
	on_step = function(self, dtime)
		if self.dead or ml.outcome() ~= "" then
			return
		end
		local pos = self.object:get_pos()
		local blinded = ml.storage:get_int("blinded") == 1
		local dulled = ml.storage:get_int("wine") == 1
		if blinded then
			self.object:set_nametag_attributes({text = "cyclops (blind)", color = {a = 255, r = 180, g = 180, b = 180}})
		elseif dulled then
			self.object:set_nametag_attributes({text = "cyclops (dulled)", color = {a = 255, r = 200, g = 180, b = 80}})
		else
			self.object:set_nametag_attributes({text = "cyclops", color = {a = 255, r = 220, g = 80, b = 60}})
		end
		self.hit_acc = (self.hit_acc or 0) + dtime
		if self.hit_acc > 1 and not blinded and not dulled then
			self.hit_acc = 0
			for _, player in ipairs(minetest.get_connected_players()) do
				if vector.distance(player:get_pos(), pos) < 2.2 and player:get_hp() > 0 then
					local dmg = 6
					if ml.touch_damage then
						dmg = ml.touch_damage(player, 6, true)
					end
					player:set_hp(player:get_hp() - dmg)
				end
			end
		end
		if blinded or dulled then
			return
		end
		self.acc = self.acc + dtime
		if self.acc < 0.35 then
			return
		end
		self.acc = 0
		local nearest, nearest_d
		for _, player in ipairs(minetest.get_connected_players()) do
			local d = vector.distance(player:get_pos(), pos)
			if d < 9 and (not nearest_d or d < nearest_d) then
				nearest = player
				nearest_d = d
			end
		end
		if not nearest or nearest_d < 1.4 then
			return
		end
		local dir = vector.direction(pos, nearest:get_pos())
		self.object:set_pos(vector.add(pos, vector.multiply(dir, 0.45)))
		self.object:set_yaw(minetest.dir_to_yaw(dir))
	end,
	on_punch = function(self, puncher)
		local bonus = (ml.punch_bonus and puncher and ml.punch_bonus(puncher)) or 0
		if bonus > 0 and self.object:get_hp() > 1 then
			self.object:set_hp(math.max(1, self.object:get_hp() - bonus))
		end
		minetest.after(0, function()
			if not self.object or not self.object:get_pos() then
				return
			end
			if self.object:get_hp() > 0 then
				return
			end
			self.object:set_hp(1)
			if puncher and puncher:is_player() then
				minetest.chat_send_player(puncher:get_player_name(), "Steel will not finish him. Wine, then the stake.")
			end
		end)
	end,
})

function ml.build_cave()
	for x = 8, 12 do
		for z = 18, 24 do
			put(x, 8, z, "ml_map:foundation")
			put(x, 9, z, "air")
			put(x, 10, z, "air")
			put(x, 11, z, "ml_map:foundation")
		end
	end
	for z = 18, 24 do
		for y = 9, 10 do
			put(8, y, z, "ml_map:foundation")
			put(12, y, z, "ml_map:foundation")
		end
	end
	for x = 8, 12 do
		for y = 9, 10 do
			put(x, y, 24, "ml_map:foundation")
		end
	end
	for y = 9, 10 do
		put(9, y, 18, "ml_map:foundation")
		put(11, y, 18, "ml_map:foundation")
	end
	put(10, 9, 17, "ml_cyclops:mouth")
	put(10, 9, 20, "ml_cyclops:wine")
	put(10, 9, 22, "ml_cyclops:stake")
	ml.clear_cyclops()
	minetest.add_entity({x = 10, y = 10, z = 21}, "ml_cyclops:cyclops")
	ml.storage:set_int("cave_ver", 1)
end

local old_build = ml.build_map
function ml.build_map()
	if old_build then
		old_build()
	end
	ml.build_cave()
end

if ml.storage:get_int("cave_ver") < 1 then
	ml.build_cave()
end
