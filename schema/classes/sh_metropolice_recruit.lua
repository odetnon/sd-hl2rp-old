CLASS.name = "Metropolice Recruit"
CLASS.faction = FACTION_CP
CLASS.isDefault = true

function CLASS:OnCanBe(client)
	local name = client:Name()
	local bStatus = false

	for k, v in ipairs({ "i7", "i6"}) do
		if (Schema:IsCombineRank(name, v)) then
			bStatus = true

			break
		end
	end

	return bStatus
end

CLASS_MPR = CLASS.index