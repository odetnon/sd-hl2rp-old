
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

		for _, tbl in ipairs(itemTable.randomItem) do
			if (math.random(1, tbl.chance) == 2) then
				items[#items + 1] = istable(tbl.items) and tbl.items[math.random(1, #tbl.items)] or tbl.items
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