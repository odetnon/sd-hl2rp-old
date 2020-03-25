
FACTION.name = "Citizen"
FACTION.description = ""
FACTION.color = Color(150, 125, 100)
FACTION.isDefault = true
FACTION.bAllowDatafile = true

function FACTION:OnCharacterCreated(client, character)
	local cid = string.format(math.random(1, 99999), "%05d")
	local inventory = character:GetInventory()

	character:SetData("cid", cid)

	inventory:Add("suitcase", 1)
	inventory:Add("cid", 1, {
		name = character:GetName(),
		cid = tostring(cid)
	})
end

FACTION_CITIZEN = FACTION.index
