CLASS.name = "Overwatch Soldier"
CLASS.faction = FACTION_OTA
CLASS.isDefault = true

function CLASS:OnSet(client)
	local character = client:GetCharacter()

	if (character) then
		character:SetModel("models/characters/combine_soldier/jqblk/combine_s.mdl")
	end
end

CLASS_OWS = CLASS.index
