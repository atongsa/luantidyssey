-- Bag of winds. Opening it sends you back. Keeping it shut is the stop.

local SPAWN = {x = 0, y = 9, z = -8}

local function put(x, y, z, name)
	minetest.set_node({x = x, y = y, z = z}, {name = name})
end

local function tell(player, text)
	if player and player:is_player() then
		minetest.chat_send_player(player:get_player_name(), text)
	end
end

local function ready(player)
	if ml.outcome() ~= "" then
		return false
	end
	if ml.storage:get_int("cyclops") ~= 1 then
		tell(player, "Slip out of the cave first. The bag comes after that.")
		return false
	end
	return true
end

local function blow_back(player)
	if not player or not player:is_player() then
		return
	end
	player:set_pos(SPAWN)
	minetest.chat_send_all("The cord comes loose. The winds rush out and blow Odysseus back to the shore.")
end

local function keep_shut(player)
	if ml.storage:get_int("winds") == 1 then
		tell(player, "The bag is already shut. Leave it.")
		return
	end
	ml.storage:set_int("winds", 1)
	ml.add_xp(player, 15)
	ml.add_gold(player, 12)
	minetest.chat_send_all("Odysseus leaves the bag shut. The winds stay inside. Next stop is not built: the cannibal shore.")
	ml.check_end()
end

minetest.register_node("ml_winds:bag", {
	description = "Sealed bag",
	tiles = {"ml_sand.png"},
	drawtype = "nodebox",
	paramtype = "light",
	sunlight_propagates = true,
	groups = {not_in_creative_inventory = 1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.35, -0.5, -0.28, 0.35, 0.05, 0.28},
			{-0.12, 0.05, -0.12, 0.12, 0.35, 0.12},
		},
	},
	on_dig = function() end,
	on_rightclick = function(pos, node, clicker)
		if not ready(clicker) then
			return
		end
		keep_shut(clicker)
	end,
	on_punch = function(pos, node, puncher)
		if not ready(puncher) then
			return
		end
		if ml.storage:get_int("winds") == 1 then
			tell(puncher, "It is shut. Do not open it now.")
			return
		end
		blow_back(puncher)
	end,
})

minetest.register_node("ml_winds:cord", {
	description = "Loose cord",
	tiles = {"ml_bronze.png"},
	drawtype = "nodebox",
	paramtype = "light",
	sunlight_propagates = true,
	groups = {not_in_creative_inventory = 1},
	node_box = {
		type = "fixed",
		fixed = {-0.45, -0.5, -0.08, 0.45, -0.35, 0.08},
	},
	on_dig = function() end,
	on_rightclick = function(pos, node, clicker)
		if not ready(clicker) then
			return
		end
		if ml.storage:get_int("winds") == 1 then
			tell(clicker, "The bag is already shut. Leave the cord.")
			return
		end
		blow_back(clicker)
	end,
})

function ml.build_winds()
	for x = -12, -8 do
		for z = 12, 16 do
			put(x, 8, z, "ml_map:marble")
		end
	end
	put(-10, 9, 14, "ml_winds:bag")
	put(-8, 9, 14, "ml_winds:cord")
	ml.storage:set_int("winds_ver", 1)
end

local old_build = ml.build_map
function ml.build_map()
	if old_build then
		old_build()
	end
	ml.build_winds()
end

if ml.storage:get_int("winds_ver") < 1 then
	ml.build_winds()
end
