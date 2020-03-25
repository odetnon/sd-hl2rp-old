-- Hides OTA on scoreboard from anyone outside the faction.
function Schema:ShouldShowPlayerOnScoreboard(client)
    
    if LocalPlayer():GetCharacter():GetFaction()~=FACTION_OTA then
        if client:GetCharacter():GetFaction()==FACTION_OTA then 
            return false
        end
    end
end
