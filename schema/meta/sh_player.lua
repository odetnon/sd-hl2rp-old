
local playerMeta = FindMetaTable("Player")

function playerMeta:IsCombine()
	return IsValid(self) and (self:Team() == FACTION_CP or self:Team() == FACTION_OTA)
end
