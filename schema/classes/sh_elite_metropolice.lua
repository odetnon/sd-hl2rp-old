CLASS.name = "Elite Metropolice"
CLASS.faction = FACTION_CP
CLASS.isDefault = false

function CLASS:OnCanBe(client)
	local name = client:Name()
	local bStatus = false

	for k, v in ipairs({ "i1", "i2"}) do
		if (Schema:IsCombineRank(name, v)) then
			bStatus = true

			break
		end
	end

	return bStatus
end

CLASS_EMP = CLASS.index