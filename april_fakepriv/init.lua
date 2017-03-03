minetest.log('action', '[MOD] April Fakepriv mod loading...')

-- actual timeout between attempts = fakepriv_timeout / nr. players + 1 second (to be sure it's non zero)
local fakepriv_timeout = 300 -- 5 mins
local fakepriv_chance = 10 -- one out of ten
local fakeprivs = { 'stoptime', 'steal' }

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
	if minetest.get_node(pos).name == "air" and minetest.get_node({x = pos.x, y = pos.y + 1, z = pos.z}).name == "air" and minetest.get_node({x = pos.x, y = pos.y - 1, z = pos.z}).walkable == true then
		player:moveto(newpos)
	end
end

local function timer()
	local connected_players = minetest.get_connected_players()
	if connected_players == nil then
		minetest.after(fakepriv_timeout, timer)
		return
	end
	local nr_connected_players = #connected_players
	--we need at least two active players to run the prank
	if nr_connected_players > 1 then
		if math.random(fakepriv_chance) == 1 then
			--run the prank
			-- pick a random grantor
			local random_number = math.random( nr_connected_players )
			local fake_admin = connected_players[ random_number ]
			-- remove the grantor from table and pick a random grantee
			connected_players[ random_number ] = nil
			random_number = math.random( nr_connected_players )
			local victim = connected_players[ random_number ]
			-- give or take?
			if math.random(2) == 1 then
				-- pick a fake privilege
				local fakepriv = fakeprivs[ math.random(#fakeprivs) ]
				core.chat_send_player(victim, fake_admin .. " granted you privileges: " .. fakepriv)
			else
				local realprivs = minetest.get_player_privs(victim)
				core.chat_send_player(victim, fake_admin .. " revoked privileges from you: " .. realprivs[ math.random(#realprivs) ])
			end
		end
	end
	-- recalculate timeout
	minetest.after(fakepriv_timeout / nr_connected_players + 1, timer)
end

timer()

minetest.log('action', '[MOD] April Fakepriv mod loaded!')
