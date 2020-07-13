
local PLUGIN = PLUGIN

PLUGIN.name = "More Acts"
PLUGIN.author = "Sundown HL2RP"
PLUGIN.description = "Adds more acts/animations, primarily for citizen models."

if (!ix.act) then
	return
end

function PLUGIN:SetupActs()
    -- Template
    --ix.act.Register("name of the act", "what class, like vortigaunt, citizen_female, citizen_male", {
	--	start = {"start of the sequence", "second start of the sequence"},
	--	sequence = {"the main sequence", "second main sequence"},
	--	finish = {"the end of the sequence", "second end of the sequence"},
	--	untimed = true/false
	--})

    -- All citizens
    ix.act.Register("ScanID", {"citizen_male", "citizen_female"}, {
		sequence = "g_scan_ID"
    })

    ix.act.Register("RadioLean", {"citizen_male", "citizen_female"}, { -- Does this even work on female models? Pls check.
		sequence = "p_town05_RadioLean",
		untimed = true,
		idle = true
	})
    
    -- Male citizens

    -- Female citizens

    -- Vortigaunts

    -- Civil Protection
end