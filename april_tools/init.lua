minetest.log('action', '[MOD] April Tools mod loading...')

local tool_chance = 100 -- one out of hundred punches triggers a tool swap

--randomly replace puncher's tool with smth else
local function april_tools(_, _, puncher, _)
	local wielded_item = puncher:get_wielded_item():get_name()
	--check it it's a tool (and not smth else)
	local tools = minetest.registered_tools
	if tools[wielded_item] ~= nil then
		if math.random(tool_chance) == 1 then
			local tool_keys = {}
			--replace current tool with a random item from tools array
			for key,_ in pairs(tools) do
				tool_keys[#tool_keys + 1] = key
			end
			puncher:set_wielded_item(tool_keys[math.random(#tool_keys)])
		end
	end
end

minetest.register_on_punchnode(april_tools)

minetest.log('action', '[MOD] April Tools mod loaded!')
