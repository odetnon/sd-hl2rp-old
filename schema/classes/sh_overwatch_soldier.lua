CLASS.name = "Overwatch Soldier"
CLASS.faction = FACTION_OTA
CLASS.isDefault = true

function CLASS:OnSet(client)
	local character = client:GetCharacter()

	if (character) then
		character:SetModel("models/cultist/hl_a/combine_commander/npc/combine_commander.mdl")
	end
end

CLASS_OWS = CLASS.index
