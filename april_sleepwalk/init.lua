minetest.log('action', '[MOD] April Sleepwalk mod loading...')

-- actual timeout between attempts = teleport_timeout / nr. players + 1 second (to be sure it's non zero)
local sleepwalk_timeout = 300 -- 5 mins
local sleepwalk_chance = 10 -- one out of ten

local function sleepwalk(player)
	local pos = player:getpos()
	local newpos = pos
	local random_number = math.random(4)
	if random_number == 1 then
		newpos.x = newpos.x + 1
	elseif random_number == 2 then
		newpos.x = newpos.x - 1
	elseif random_number == 3 then
		newpos.z = newpos.z + 1
	else
		newpos.z = newpos.z - 1
	end
	-- if there's enough space for the player and the node below is walkable
	if minetest.get_node(pos).name == "air" and minetest.get_node({x = pos.x, y = pos.y + 1, z = pos.z}).name == "air" and minetest.get_node({x = pos.x, y = pos.y - 1, z = pos.z}).walkable ~= false and minetest.get_node({x = pos.x, y = pos.y - 1, z = pos.z}).name ~= "air" then
		player:moveto(newpos)
	end
end

local function timer()
	local connected_players = minetest.get_connected_players()
	local nr_connected_players = table.getn(connected_players)
	if nr_connected_players == 0 then
		minetest.after(sleepwalk_timeout, timer)
		return
	end
	local unlucky_player = connected_players[ math.random( nr_connected_players ) ]
	if math.random(sleepwalk_chance) == 1 then
		sleepwalk(unlucky_player)
	end
	-- recalculate timeout
	minetest.after(sleepwalk_timeout / nr_connected_players + 1, timer)
end

timer()

minetest.log('action', '[MOD] April Sleepwalk mod loaded!')
