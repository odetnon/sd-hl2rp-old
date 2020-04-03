
ITEM.name = "Metropolice Functionary Grade Ration Unit"
ITEM.model = Model("models/weapons/w_packatm.mdl")
ITEM.description = "A black shrink-wrapped packet containing Metropolice supplements and a can of A.L:10 grade liquid nourishment."
ITEM.items = {"mpfsupp","watermpf"}

ITEM.functions.Open = {
	OnRun = function(itemTable)
		local client = itemTable.player
		local character = client:GetCharacter()

		for k, v in ipairs(itemTable.items) do
			if (!character:GetInventory():Add(v)) then
				ix.item.Spawn(v, client)
			end
		end

		character:GiveMoney(ix.config.Get("rationTokens", 20))
		client:EmitSound("ambient/fire/mtov_flame2.wav", 75, math.random(160, 180), 0.35)
	end
}