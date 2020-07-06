
ITEM.name = "Ration Base"
ITEM.model = Model("models/weapons/w_package.mdl")
ITEM.description = "A base for ration items."
ITEM.category = "Union Branded Items"
ITEM.items = nil
ITEM.randomItem = {}
ITEM.junk = "ration_empty"

ITEM.functions.Open = {
	OnRun = function(itemTable)
		local client = itemTable.player
		local character = client:GetCharacter()

		if (itemTable.cash) then
			character:GiveMoney(itemTable.cash)
		end

		local items = {}

		for k, v in ipairs(itemTable.items) do
			if (!character:GetInventory():Add(v)) then
				ix.item.Spawn(v, client)
			end
		end

		if (itemTable.randomItem) then
			

		for _, table in ipairs(itemTable.randomItem) do
			if (math.random(1, 100) <= table.chance) then
				items[#items + 1] = istable(table.items) and table.items[math.random(1, #table.items)] or table.items
				break
			end
		end
        
        if (itemTable.junk) then
			local junk = client:GetCharacter():GetInv():Add(itemTable.junk)

			if (junk) then
				client:GetCharacter():GetInv():sync(client)
			else
				ErrorNoHalt("[Error] Item "..item.name.." attempted to give unexisting junk item "..item.junk..".")
			end
		end

		client:EmitSound("ambient/fire/mtov_flame2.wav", 75, math.random(160, 180), 0.35)
	end
}