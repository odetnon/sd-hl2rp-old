CLASS.name = "Overwatch Commander"
CLASS.faction = FACTION_OTA
CLASS.isDefault = false

function CLASS:OnCanBe(client)
	local name = client:Name()
	local bStatus = false

	for k, v in ipairs({ "OWL", "OWC"}) do
		if (Schema:IsCombineRank(name, v)) then
			bStatus = true

			break
		end
	end

	return bStatus
end

function CLASS:OnSet(client)
	local character = client:GetCharacter()

	if (character) then
		character:SetModel("models/cultist/hl_a/combine_commander/npc/combine_commander.mdl")
	end
end

CLASS_OWC = CLASS.index
