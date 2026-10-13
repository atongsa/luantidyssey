-- Cannibal shore. Landing a ship here loses it. Hold one hull off the beach.

local SPAWN = {x = 0, y = 9, z = -8}

local function put(x, y, z, name)
	minetest.set_node({x = x, y = y, z = z}, {name = name})
end

local function tell(player, text)
	if player and player:is_player() then
		minetest.chat_send_player(player:get_player_name(), text)
	end
end

local function after_bag(player)
	if ml.outcome() ~= "" then
		return false
	end
	if ml.storage:get_int("winds") ~= 1 then
		tell(player, "Leave the bag shut first. This beach comes after that.")
		return false
	end
	return true
end

minetest.register_node("ml_shore:landing", {
	description = "Beach landing",
	tiles = {"ml_sand.png"},
	drawtype = "nodebox",
	paramtype = "light",
	sunlight_propagates = true,
	groups = {not_in_creative_inventory = 1},
	node_box = {
		type = "fixed",
		fixed = {-0.45, -0.5, -0.35, 0.45, -0.25, 0.35},
	},
	on_dig = function() end,
	on_rightclick = function(pos, node, clicker)
		if not after_bag(clicker) then
			return
		end
		if ml.storage:get_int("shore") == 1 then
			tell(clicker, "You already held the ship off. Do not land now.")
			return
		end
		clicker:set_pos(SPAWN)
		minetest.chat_send_all("That ship is smashed on the beach. Odysseus is driven back. Do not land what you cannot hold.")
	end,
})

minetest.register_node("ml_shore:hold", {
	description = "Outer hull",
	tiles = {"ml_bronze.png"},
	drawtype = "nodebox",
	paramtype = "light",
	sunlight_propagates = true,
	groups = {not_in_creative_inventory = 1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.45, -0.5, -0.22, 0.45, -0.15, 0.22},
			{-0.06, -0.15, -0.06, 0.06, 0.45, 0.06},
		},
	},
	on_dig = function() end,
	on_rightclick = function(pos, node, clicker)
		if not after_bag(clicker) then
			return
		end
		if ml.storage:get_int("shore") == 1 then
			tell(clicker, "This hull is already held off the beach.")
			return
		end
		ml.storage:set_int("shore", 1)
		ml.add_xp(clicker, 15)
		ml.add_gold(clicker, 12)
		minetest.chat_send_all("Odysseus holds one ship off the beach and sails on. Next stop is not built: Circe's island.")
		ml.check_end()
	end,
})

function ml.build_shore()
	for z = 34, 38 do
		for x = 4, 8 do
			put(x, 8, z, "ml_map:sand")
			put(x, 9, z, "air")
		end
	end
	for z = 38, 44 do
		for x = 4, 8 do
			put(x, 8, z, "ml_map:foundation")
			put(x, 9, z, "air")
		end
	end
	put(5, 9, 40, "ml_shore:landing")
	put(7, 9, 40, "ml_shore:landing")
	put(6, 9, 43, "ml_shore:hold")
	ml.storage:set_int("shore_ver", 1)
end

local old_build = ml.build_map
function ml.build_map()
	if old_build then
		old_build()
	end
	ml.build_shore()
end

if ml.storage:get_int("shore_ver") < 1 then
	ml.build_shore()
end
