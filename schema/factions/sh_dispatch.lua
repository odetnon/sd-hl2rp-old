
FACTION.name = "Airwatch"
FACTION.description = ""
FACTION.color = Color(35, 60, 70)
FACTION.models = {"models/hlvr/combine_scanner/hlvr_scanner_ref.mdl"}
FACTION.isGloballyRecognized = true
FACTION.channels = {
	["union"] = true,
	["um"] = true,
	["terminal"] = true,
	["division"] = true,
	["cwui"] = true,
	["overwatch"] = true,
	["combine"] = true,
	["tac"] = true
}
FACTION.canSeeWaypoints = true
FACTION.canAddWaypoints = true
FACTION.canRemoveWaypoints = true
FACTION.canUpdateWaypoints = true
FACTION.noGas = true
FACTION.noNeeds = true

function FACTION:GetDefaultName(client)
	return "CMB:AW.AI-"..math.random(1000, 9999), true
end

function FACTION:OnSpawn(client)
	local scanners = ix.plugin.list["scanner"]

	if (scanners) then
		timer.Simple(0.1, function()
			scanners:CreateScanner(client, nil)
		end)
	end
end

FACTION_DISP = FACTION.index
