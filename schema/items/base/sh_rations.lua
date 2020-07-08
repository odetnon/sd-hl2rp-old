
ITEM.name = "Ration Base"
ITEM.model = Model("models/weapons/w_package.mdl")
ITEM.description = "A base for ration items."
ITEM.category = "Union Branded Items"
ITEM.cash = ix.config.Get("rationTokens", 20)
ITEM.items = {}
-- ITEM.randomItem = {}
ITEM.junk = "ration_empty"

ITEM.functions.Open = {
    OnRun = function(itemTable)
        local client = itemTable.player
        local character = client:GetCharacter()

        if (itemTable.cash) then
            character:GiveMoney(itemTable.cash)
        end

        for k, v in ipairs(itemTable.items) do
            if (!character:GetInventory():Add(v)) then
				ix.item.Spawn(v, client)
			end
		end
		
		if (itemTable.randomItem) then
            if (math.random(1, 100) <= itemTable.randomItem.chance) then
                if (!character:GetInventory():Add(itemTable.randomItem.item)) then
                    ix.item.Spawn(itemTable.randomItem.item, client)
                end
            end
        end

        if (itemTable.junk) then
            local junk = client:GetCharacter():GetInv():Add(itemTable.junk)

            if (junk) then
                client:GetCharacter():GetInv():sync(client)
            else
                ErrorNoHalt("[Error] Item "..itemTable.name.." attempted to give unexisting junk item "..itemTable.junk..".")
            end
        end

        client:EmitSound("ambient/fire/mtov_flame2.wav", 75, math.random(160, 180), 0.35)
    end
}