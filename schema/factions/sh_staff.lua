FACTION.name = "Server Administration"
FACTION.description = "A staff member that is happy to help! /pm me or use !help"
FACTION.color = Color(0,255,255)
FACTION.pay = 0
FACTION.models = {"models/bloocobalt/combine/combine_s.mdl"}
FACTION.isDefault = false
FACTION.isGloballyRecognized = true
FACTION.noNeeds = true

function FACTION:OnCharacterCreated(client, character)
    character:GiveFlags("pet")
end

FACTION_STAFF = FACTION.index
