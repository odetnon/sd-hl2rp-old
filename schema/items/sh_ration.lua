
ITEM.name = "Ration"
ITEM.description = "A plain blue package filled with required sustenance"
ITEM.model = "models/foodnhouseholdaaaaa/combirationb.mdl"

ITEM.functions.Open = {
	OnRun = function(item)
		local client = item.player
		local character = client:GetCharacter()
		local inventory = character:GetInventory()

		inventory:Add("supplements", 1)
		inventory:Add("water", 1)
	end
}
