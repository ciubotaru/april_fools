minetest.log('action', '[MOD] April Craft mod loading...')

local craft_chance = 100 -- one out of hundred craftings goes wrong (number can not be less than 2)

local function april_craft(itemstack, player, old_craft_grid, craft_inv)
	local node_count = itemstack:get_count()
	local random_number = math.random(2 * hallucination_chance)
	if random_number == 1 then --replace craft output with a random node
		local craft_nodes = {}
		for v in pairs(minetest.registered_nodes) do
			table.insert(craft_nodes, v)
		end
		itemstack:clear()
		itemstack:add_item({name = craft_nodes[math.random(#craft_nodes)], count = node_count, wear = 0, metadata = ""})
	elseif random_number == 2 then --increment craft output count
		itemstack:set_count(node_count + 1)
	end
	return itemstack
end

minetest.register_on_craft(april_craft)

minetest.log('action', '[MOD] April Craft mod loaded!')
