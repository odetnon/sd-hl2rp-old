
function Schema:CanPlayerUseBusiness(client, uniqueID)
	local itemTable = ix.item.Get(uniqueID)

	if (itemTable) then
		if (itemTable.permit) then
			local character = client:GetCharacter()
			local inventory = character:GetInventory()

			if (!inventory:HasItem("permit_"..itemTable.permit)) then
				return false
			end
		elseif (itemTable.base ~= "base_permit") then
			return false
		end

		if (!itemTable.business) then
			return false
		end
	end
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
