-- Match state for the first slice. Other mods call ml.* .

ml = {
	storage = minetest.get_mod_storage(),
}

local function boot()
	if ml.storage:get_string("ready") == "1" then
		return
	end
	ml.storage:set_int("hall", 100)
	ml.storage:set_int("wave", 0)
	ml.storage:set_int("creeps_alive", 0)
	ml.storage:set_int("lotus", 0)
	ml.storage:set_int("cyclops", 0)
	ml.storage:set_int("wine", 0)
	ml.storage:set_int("blinded", 0)
	ml.storage:set_string("outcome", "")
	ml.storage:set_string("ready", "1")
end

boot()

function ml.hall()
	return ml.storage:get_int("hall")
end

function ml.outcome()
	return ml.storage:get_string("outcome")
end

function ml.task_line()
	if ml.storage:get_int("lotus") ~= 1 then
		return "Lotus-eaters: right-click the lotus stand and refuse it."
	end
	if ml.storage:get_int("cyclops") ~= 1 then
		return "Cyclops: cave east of the path. Wine, then the stake, then the mouth."
	end
	return "You slipped out of the cave. Next stop is not built: the bag of winds."
end

function ml.gold(player)
	return player:get_meta():get_int("ml_gold")
end

function ml.level(player)
	local n = player:get_meta():get_int("ml_level")
	if n < 1 then
		return 1
	end
	return n
end

function ml.xp(player)
	return player:get_meta():get_int("ml_xp")
end

function ml.add_gold(player, n)
	if not player or ml.outcome() ~= "" then
		return
	end
	local meta = player:get_meta()
	meta:set_int("ml_gold", meta:get_int("ml_gold") + n)
	minetest.chat_send_player(player:get_player_name(), "Gold " .. meta:get_int("ml_gold") .. "  (+" .. n .. ")")
end

function ml.add_xp(player, n)
	if not player or ml.outcome() ~= "" then
		return
	end
	local meta = player:get_meta()
	local xp = meta:get_int("ml_xp") + n
	local level = ml.level(player)
	local gained = 0
	while xp >= 10 do
		xp = xp - 10
		level = level + 1
		gained = gained + 1
		minetest.chat_send_player(player:get_player_name(), "Level " .. level .. ". Skill point.")
	end
	meta:set_int("ml_xp", xp)
	meta:set_int("ml_level", level)
	if gained > 0 then
		meta:set_int("ml_points", meta:get_int("ml_points") + gained)
		if ml.offer_pick then
			ml.offer_pick(player)
		end
	end
end

function ml.check_end()
	if ml.outcome() ~= "" then
		return
	end
	if ml.hall() <= 0 then
		ml.storage:set_int("hall", 0)
		ml.storage:set_string("outcome", "lose")
		minetest.chat_send_all("The hall fell. Ithaca is lost.")
		return
	end
	if ml.storage:get_int("lotus") == 1
		and ml.storage:get_int("cyclops") == 1
		and ml.storage:get_int("wave") == 2 then
		ml.storage:set_string("outcome", "win")
		minetest.chat_send_all("The lotus is refused, the cave is behind you, and the hall still stands. Next stop is not built: the bag of winds.")
	end
end

function ml.damage_hall(n)
	if ml.outcome() ~= "" then
		return
	end
	local hp = math.max(0, ml.hall() - n)
	ml.storage:set_int("hall", hp)
	minetest.chat_send_all("The hall is hit. Life " .. hp .. " / 100.")
	ml.check_end()
end

function ml.refuse_lotus(player)
	if ml.outcome() ~= "" then
		return false, "The match is already over."
	end
	if ml.storage:get_int("lotus") == 1 then
		return false, "You already refused the lotus."
	end
	ml.storage:set_int("lotus", 1)
	ml.add_gold(player, 20)
	ml.add_xp(player, 10)
	local inv = player:get_inventory()
	if minetest.registered_items["ml_items:voyage_token"] then
		inv:add_item("main", "ml_items:voyage_token")
	end
	minetest.chat_send_all("Odysseus refuses the lotus. The cyclops cave is east of the path.")
	ml.check_end()
	return true, "Lotus refused."
end

function ml.creep_down()
	local left = ml.storage:get_int("creeps_alive") - 1
	if left < 0 then
		left = 0
	end
	ml.storage:set_int("creeps_alive", left)
	if ml.storage:get_int("wave") == 1 and left == 0 then
		ml.storage:set_int("wave", 2)
		minetest.chat_send_all("The suitors on this wave are gone.")
		ml.check_end()
	end
end

local function clear_hero_meta(player)
	local meta = player:get_meta()
	meta:set_int("ml_gold", 0)
	meta:set_int("ml_xp", 0)
	meta:set_int("ml_level", 1)
	meta:set_int("ml_pending", 0)
	meta:set_int("ml_did_intro", 0)
	meta:set_int("ml_points", 1)
	meta:set_string("ml_owned", "")
	meta:set_string("ml_brand_until", "")
	for _, id in ipairs({"armor", "weapon", "fruit", "blood"}) do
		meta:set_string("ml_cd_" .. id, "0")
		meta:set_int("ml_rank_" .. id, 0)
	end
end

minetest.register_chatcommand("ml", {
	description = "Gold, hall life, and the current task",
	func = function(name)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "No player."
		end
		local skills = ""
		if ml.skill_line then
			skills = "\n" .. ml.skill_line(player)
		end
		local line = "gold " .. ml.gold(player)
			.. "  level " .. ml.level(player)
			.. "  xp " .. ml.xp(player) .. "/10"
			.. "  hall " .. ml.hall() .. "/100"
			.. "  wave " .. ml.storage:get_int("wave")
			.. "\n" .. ml.task_line()
			.. skills
		if ml.outcome() ~= "" then
			line = line .. "\noutcome: " .. ml.outcome()
		end
		return true, line
	end,
})

minetest.register_chatcommand("ml_reset", {
	description = "Reset the slice (server privilege)",
	privs = {server = true},
	func = function(name)
		ml.storage:set_int("hall", 100)
		ml.storage:set_int("wave", 0)
		ml.storage:set_int("creeps_alive", 0)
		ml.storage:set_int("lotus", 0)
		ml.storage:set_int("cyclops", 0)
		ml.storage:set_int("wine", 0)
		ml.storage:set_int("blinded", 0)
		ml.storage:set_string("outcome", "")
		local player = minetest.get_player_by_name(name)
		if player then
			clear_hero_meta(player)
		end
		if ml.clear_suitors then
			ml.clear_suitors()
		end
		if ml.clear_cyclops then
			ml.clear_cyclops()
		end
		if ml.build_map then
			ml.build_map()
		end
		if ml.schedule_wave then
			ml.schedule_wave()
		end
		if player and ml.offer_pick then
			player:get_meta():set_int("ml_did_intro", 1)
			ml.offer_pick(player)
		end
		return true, "Reset. One skill point is ready."
	end,
})
