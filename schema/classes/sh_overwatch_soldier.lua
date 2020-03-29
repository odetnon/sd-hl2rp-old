CLASS.name = "Overwatch Soldier"
CLASS.faction = FACTION_OTA
CLASS.isDefault = true

function CLASS:OnSet(client)
	local character = client:GetCharacter()

	if (character) then
		character:SetModel("models/bloocobalt/combine/combine_s.mdl")
	end
end

CLASS_OWS = CLASS.index
