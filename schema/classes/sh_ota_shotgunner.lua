CLASS.name = "Overwatch Shotgunner"
CLASS.faction = FACTION_OTA
CLASS.isDefault = true

function CLASS:OnCanBe(client)
	local name = client:Name()
	local bStatus = false

	for k, v in ipairs({ "MACE"}) do
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
		character:SetModel("models/characters/combine_soldier/jqblk/combine_s.mdl", 1)
	end
end

CLASS_SOW = CLASS.index
