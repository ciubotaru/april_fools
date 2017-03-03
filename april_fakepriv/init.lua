minetest.log('action', '[MOD] April Fakepriv mod loading...')

-- actual timeout between attempts = fakepriv_timeout / nr. players + 1 second (to be sure it's non zero)
local fakepriv_timeout = 300 -- 5 mins
local fakepriv_chance = 10 -- one out of ten
local fakeprivs = { 'stoptime', 'steal' }

local function timer()
	local connected_players = minetest.get_connected_players()
	local nr_connected_players = table.getn(connected_players)
	if nr_connected_players == nil then
		minetest.after(fakepriv_timeout, timer)
		return
	end
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
