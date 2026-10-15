-- Circe through the hall. Each stop stays in the poem's order.
-- Way posts name the places. The carrying ship starts the last suitor band.

local SPAWN = {x = 0, y = 9, z = -8}

local function put(x, y, z, name)
	minetest.set_node({x = x, y = y, z = z}, {name = name})
end

local function tell(player, text)
	if player and player:is_player() then
		minetest.chat_send_player(player:get_player_name(), text)
	end
end

local function now_s()
	return math.floor(minetest.get_us_time() / 1000000)
end

local function gate(player, key, earlier)
	if not player or not player:is_player() then
		return false
	end
	if ml.outcome() ~= "" then
		return false
	end
	if ml.storage:get_int(key) ~= 1 then
		tell(player, earlier)
		return false
	end
	return true
end

local function back(player, line)
	player:set_pos(SPAWN)
	minetest.chat_send_all(line)
end

local function mark(player, key, xp, gold, line)
	if ml.storage:get_int(key) == 1 then
		tell(player, "That stop is already done.")
		return
	end
	ml.storage:set_int(key, 1)
	ml.add_xp(player, xp)
	ml.add_gold(player, gold)
	minetest.chat_send_all(line)
	ml.check_end()
end

local function simple(name, desc, tile, box, fn)
	minetest.register_node(name, {
		description = desc,
		tiles = {tile},
		drawtype = "nodebox",
		paramtype = "light",
		sunlight_propagates = true,
		groups = {not_in_creative_inventory = 1},
		node_box = {type = "fixed", fixed = box},
		on_dig = function() end,
		on_rightclick = function(pos, node, clicker)
			fn(clicker)
		end,
	})
end

minetest.register_node("ml_voyage:post", {
	description = "Way post",
	tiles = {"ml_marble.png"},
	drawtype = "nodebox",
	paramtype = "light",
	sunlight_propagates = true,
	groups = {not_in_creative_inventory = 1},
	node_box = {
		type = "fixed",
		fixed = {-0.12, -0.5, -0.12, 0.12, 0.5, 0.12},
	},
	on_dig = function() end,
})

local function post(x, y, z, text)
	local pos = {x = x, y = y, z = z}
	minetest.set_node(pos, {name = "ml_voyage:post"})
	minetest.get_meta(pos):set_string("infotext", text)
end

simple("ml_voyage:cup", "Circe's cup", "ml_bronze.png", {-0.2, -0.5, -0.2, 0.2, -0.1, 0.2}, function(player)
	if not gate(player, "shore", "Hold one ship off the beach first.") then
		return
	end
	if ml.storage:get_int("circe") == 1 then
		tell(player, "The cup is empty. Leave it.")
		return
	end
	if ml.storage:get_int("herb") == 1 then
		tell(player, "You have the herb. Restore the companions. Do not drink.")
		return
	end
	back(player, "Odysseus drinks. The place turns him aside and throws him back to the shore.")
end)

simple("ml_voyage:herb", "Wild herb", "ml_olive.png", {-0.15, -0.5, -0.15, 0.15, 0.1, 0.15}, function(player)
	if not gate(player, "shore", "Hold one ship off the beach first.") then
		return
	end
	if ml.storage:get_int("herb") == 1 then
		tell(player, "You already hold the herb.")
		return
	end
	ml.storage:set_int("herb", 1)
	tell(player, "You take the herb. Restore both companions.")
end)

local function restore(player, which)
	if not gate(player, "shore", "Hold one ship off the beach first.") then
		return
	end
	if ml.storage:get_int("circe") == 1 then
		tell(player, "They are already restored.")
		return
	end
	if ml.storage:get_int("herb") ~= 1 then
		tell(player, "He stays turned. Take the herb first.")
		return
	end
	if ml.storage:get_int(which) == 1 then
		tell(player, "That companion is already himself.")
		return
	end
	ml.storage:set_int(which, 1)
	tell(player, "The herb undoes it. He is himself again.")
	if ml.storage:get_int("mate_a") == 1 and ml.storage:get_int("mate_b") == 1 then
		mark(player, "circe", 15, 12, "Both companions are restored. Next: the dead, west of the spawn.")
	end
end

simple("ml_voyage:mate_a", "Turned companion", "ml_olive.png", {-0.25, -0.5, -0.25, 0.25, 0.2, 0.25}, function(p)
	restore(p, "mate_a")
end)
simple("ml_voyage:mate_b", "Turned companion", "ml_olive.png", {-0.25, -0.5, -0.25, 0.25, 0.2, 0.25}, function(p)
	restore(p, "mate_b")
end)

simple("ml_voyage:dead", "Stone of the dead", "ml_stone.png", {-0.35, -0.5, -0.35, 0.35, 0.15, 0.35}, function(player)
	if not gate(player, "circe", "Restore the companions first.") then
		return
	end
	mark(player, "dead", 15, 10, "The dead say: pass the singers without stopping, pay the cliff, do not touch the cattle, leave the long hold, and the ship after that brings the last suitors.")
end)

simple("ml_voyage:song", "Singers' rock", "ml_sea.png", {-0.4, -0.5, -0.4, 0.4, 0.3, 0.4}, function(player)
	if not gate(player, "dead", "Speak to the dead first.") then
		return
	end
	if ml.storage:get_int("sirens") == 1 then
		tell(player, "You already passed. Do not stop now.")
		return
	end
	back(player, "Odysseus stops to listen. The song throws him back to the shore.")
end)

simple("ml_voyage:pass", "Pass the singers", "ml_marble.png", {-0.3, -0.5, -0.3, 0.3, -0.2, 0.3}, function(player)
	if not gate(player, "dead", "Speak to the dead first.") then
		return
	end
	mark(player, "sirens", 12, 8, "He passes the singers without stopping. Next: the cliff east of the spawn. It will cost the hall.")
end)

simple("ml_voyage:whirl", "Whirlpool", "ml_sea.png", {-0.45, -0.5, -0.45, 0.45, -0.15, 0.45}, function(player)
	if not gate(player, "sirens", "Pass the singers first.") then
		return
	end
	if ml.storage:get_int("scylla") == 1 then
		tell(player, "You already took the cliff.")
		return
	end
	back(player, "The whirlpool takes the ship and throws Odysseus back to the shore.")
end)

simple("ml_voyage:cliff", "Cliff path", "ml_stone.png", {-0.35, -0.5, -0.35, 0.35, 0.4, 0.35}, function(player)
	if not gate(player, "sirens", "Pass the singers first.") then
		return
	end
	if ml.storage:get_int("scylla") == 1 then
		tell(player, "The cliff is already paid.")
		return
	end
	ml.damage_hall(20)
	if ml.outcome() ~= "" then
		return
	end
	mark(player, "scylla", 12, 0, "The cliff takes its due. The hall loses 20, and the ship still passes. Next: the cattle to the north-west. Do not touch them.")
end)

simple("ml_voyage:cattle", "Sun cattle", "ml_roof.png", {-0.4, -0.5, -0.3, 0.4, 0.15, 0.3}, function(player)
	if not gate(player, "scylla", "Pay the cliff first.") then
		return
	end
	if ml.storage:get_int("cattle") == 1 then
		tell(player, "You already sailed past. Do not touch them.")
		return
	end
	ml.storage:set_string("outcome", "lose")
	minetest.chat_send_all("You touched the cattle. The voyage is lost.")
end)

simple("ml_voyage:pasture", "Sail past the cattle", "ml_sand.png", {-0.3, -0.5, -0.3, 0.3, -0.25, 0.3}, function(player)
	if not gate(player, "scylla", "Pay the cliff first.") then
		return
	end
	mark(player, "cattle", 12, 8, "The cattle are left untouched. Next: the long hold to the north-east. Start it, wait, then leave.")
end)

simple("ml_voyage:loom", "Long hold", "ml_marble.png", {-0.4, -0.5, -0.25, 0.4, 0.1, 0.25}, function(player)
	if not gate(player, "cattle", "Sail past the cattle first.") then
		return
	end
	if ml.storage:get_int("calypso") == 1 then
		tell(player, "You already left the hold.")
		return
	end
	ml.storage:set_int("calypso_at", now_s())
	tell(player, "The hold begins. Wait, then right-click the raft. Do not leave early.")
end)

simple("ml_voyage:raft", "Raft off the hold", "ml_bronze.png",
	{{-0.45, -0.5, -0.2, 0.45, -0.2, 0.2}, {-0.05, -0.2, -0.05, 0.05, 0.4, 0.05}},
	function(player)
		if not gate(player, "cattle", "Sail past the cattle first.") then
			return
		end
		if ml.storage:get_int("calypso") == 1 then
			tell(player, "The raft has already gone.")
			return
		end
		local at = ml.storage:get_int("calypso_at")
		if at <= 0 then
			tell(player, "Start the hold first.")
			return
		end
		if now_s() - at < 25 then
			tell(player, "Not yet. The hold is not finished.")
			return
		end
		mark(player, "calypso", 15, 10, "Odysseus leaves the long hold. Next: the ship to the south-west. It brings the last suitors.")
	end)

simple("ml_voyage:ship", "Ship of the carriers", "ml_bronze.png",
	{{-0.45, -0.5, -0.25, 0.45, -0.15, 0.25}, {-0.05, -0.15, -0.05, 0.05, 0.45, 0.05}},
	function(player)
		if not gate(player, "calypso", "Leave the long hold first.") then
			return
		end
		if ml.storage:get_int("phaeacians") == 1 then
			tell(player, "The ship has already landed. Face the last suitors, then the hall step.")
			return
		end
		local wave = ml.storage:get_int("wave")
		if wave < 2 then
			tell(player, "The first suitors are still on the approach. Clear them, then take this ship.")
			return
		end
		if wave ~= 2 or not ml.start_last_wave or not ml.start_last_wave() then
			tell(player, "The last band is already ashore.")
			return
		end
		mark(player, "phaeacians", 20, 15, "The ship carries Odysseus home. A last band of suitors is on the approach. Then the hall step.")
	end)

simple("ml_voyage:hallstep", "Hall step", "ml_marble.png", {-0.45, -0.5, -0.45, 0.45, -0.3, 0.45}, function(player)
	if not gate(player, "phaeacians", "The carrying ship has not brought you yet.") then
		return
	end
	local wave = ml.storage:get_int("wave")
	if wave < 4 then
		tell(player, "The last suitors are still on the approach.")
		return
	end
	if ml.hall() <= 0 then
		return
	end
	mark(player, "ithaca", 25, 20, "The hall is yours. The voyage is done.")
end)

local prev_task = ml.task_line
function ml.task_line()
	if ml.storage:get_int("shore") ~= 1 then
		return prev_task()
	end
	if ml.storage:get_int("circe") ~= 1 then
		return "Circe: west of the hall. Herb, then both companions. Do not drink the cup."
	end
	if ml.storage:get_int("dead") ~= 1 then
		return "The dead: stone west of the spawn. Right-click and listen."
	end
	if ml.storage:get_int("sirens") ~= 1 then
		return "Singers: east of the hall. Right-click the pass. Do not stop at the rock."
	end
	if ml.storage:get_int("scylla") ~= 1 then
		return "Cliff: east of the spawn. It costs the hall. The whirlpool sends you back."
	end
	if ml.storage:get_int("cattle") ~= 1 then
		return "Cattle: north-west. Sail past. Touching them loses the voyage."
	end
	if ml.storage:get_int("calypso") ~= 1 then
		return "Long hold: north-east. Start it, wait, then take the raft."
	end
	if ml.storage:get_int("phaeacians") ~= 1 then
		return "Carriers: south-west. Their ship starts the last suitors. Clear the first band first."
	end
	if ml.storage:get_int("wave") < 4 then
		return "Ithaca: the last suitors are on the approach. Then the hall step."
	end
	if ml.storage:get_int("ithaca") ~= 1 then
		return "Ithaca: right-click the hall step, south of the altar."
	end
	return "The hall is yours."
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
	if ml.storage:get_int("ithaca") == 1 and ml.storage:get_int("wave") == 4 then
		ml.storage:set_string("outcome", "win")
		minetest.chat_send_all("The voyage is done. The hall still stands.")
	end
end

function ml.build_voyage()
	local pads = {
		{-13, -11, 4, 8},
		{-13, -11, -7, -5},
		{11, 13, 4, 8},
		{11, 13, -7, -3},
		{-9, -5, 31, 33},
		{11, 13, 30, 34},
		{-7, -5, -9, -7},
		{1, 3, -6, -4},
	}
	for _, b in ipairs(pads) do
		for x = b[1], b[2] do
			for z = b[3], b[4] do
				put(x, 8, z, "ml_map:marble")
				put(x, 9, z, "air")
			end
		end
	end
	put(-12, 9, 5, "ml_voyage:cup")
	put(-12, 9, 6, "ml_voyage:herb")
	put(-13, 9, 7, "ml_voyage:mate_a")
	put(-11, 9, 7, "ml_voyage:mate_b")
	put(-12, 9, -6, "ml_voyage:dead")
	put(12, 9, 5, "ml_voyage:song")
	put(12, 9, 7, "ml_voyage:pass")
	put(12, 9, -4, "ml_voyage:whirl")
	put(12, 9, -6, "ml_voyage:cliff")
	put(-8, 9, 32, "ml_voyage:cattle")
	put(-6, 9, 32, "ml_voyage:pasture")
	put(12, 9, 31, "ml_voyage:loom")
	put(12, 9, 33, "ml_voyage:raft")
	put(-6, 9, -8, "ml_voyage:ship")
	put(2, 9, -5, "ml_voyage:hallstep")
	post(4, 9, -8, "Way post. Point at these posts. The line above says which place is next.")
	post(6, 9, 17, "Cyclops. Wine, then the stake, then the mouth. East of the path.")
	post(-12, 9, 15, "Bag of winds. Leave it shut. The cord sends you back.")
	post(4, 9, 39, "Cannibal shore. The outer hull is further north. Do not land.")
	post(-12, 9, 4, "Circe. Take the herb, then both companions. Do not drink.")
	post(-13, 9, -6, "The dead. Right-click the stone.")
	post(11, 9, 6, "Singers. Right-click the pass. Do not stop at the rock.")
	post(11, 9, -5, "Cliff. It costs the hall. The whirlpool sends you back.")
	post(-9, 9, 33, "Cattle. Do not touch them. Sail past.")
	post(11, 9, 30, "Long hold. Start it, wait, then the raft.")
	post(-7, 9, -9, "Carriers. Clear the first suitors, then this ship brings the last band.")
	post(3, 9, -4, "Hall step. Only after the last suitors are gone.")
	ml.storage:set_int("voyage_ver", 2)
end

local old_build = ml.build_map
function ml.build_map()
	if old_build then
		old_build()
	end
	ml.build_voyage()
end

if ml.storage:get_int("voyage_ver") < 2 then
	ml.build_voyage()
end
