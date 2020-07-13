
function Schema:CanPlayerUseBusiness(client, uniqueID)
	return false
end

function Schema:CanDrive()
	return false
end

function Schema:IsCharacterRecognized(character, id)
	local factionTable = ix.faction.Get(character:GetFaction())
	local other = ix.char.loaded[id]

	if (other) then
		local otherFaction = ix.faction.Get(other:GetFaction())

		if (factionTable.factionRecognized) then
			return factionTable.factionRecognized[otherFaction.uniqueID]
		end
	end
end
