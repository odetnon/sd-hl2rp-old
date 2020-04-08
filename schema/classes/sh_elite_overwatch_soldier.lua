CLASS.name = "Elite Overwatch Soldier"
CLASS.faction = FACTION_OTA
CLASS.isDefault = false


function CLASS:OnCanBe(client)
	local name = client:Name()
	local bStatus = false

	for k, v in ipairs({ "ELT"}) do
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
		character:SetModel("models/characters/combine_soldier/jqblk/combine_s_super.mdl")
	end
end

CLASS_EOW = CLASS.index
