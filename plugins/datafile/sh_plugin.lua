
local PLUGIN = PLUGIN

PLUGIN.name = "Datafile"
PLUGIN.author = "James"
PLUGIN.description = "Adds /Datafile."

ix.util.Include("cl_plugin.lua")
ix.util.Include("cl_hooks.lua")
ix.util.Include("sv_plugin.lua")
ix.util.Include("sv_hooks.lua")
ix.util.Include("sh_commands.lua")

-- All the categories possible. Yes, the names are quite annoying.
PLUGIN.Categories = {
	["med"] = true,
	["union"] = true,
	["civil"] = true
}

DATAFILE_PERMISSION_NONE = 0
DATAFILE_PERMISSION_MINOR = 1
DATAFILE_PERMISSION_MEDIUM = 2
DATAFILE_PERMISSION_FULL = 3
DATAFILE_PERMISSION_ELEVATED = 4

-- Permissions for the numerous factions.
PLUGIN.Permissions = {
	["Airwatch"] = DATAFILE_PERMISSION_ELEVATED,

	["Overwatch Transhuman Arm"] = DATAFILE_PERMISSION_ELEVATED,
	["Civil Authority"] = DATAFILE_PERMISSION_FULL,
	["Civil Protection"] = DATAFILE_PERMISSION_FULL,

	["Server Administration"] = DATAFILE_PERMISSION_MEDIUM,

	["Civil Worker's Union"] = DATAFILE_PERMISSION_MINOR,
	["Union Medical"] = DATAFILE_PERMISSION_MINOR,

	["Citizen"] = DATAFILE_PERMISSION_NONE
}

-- All the civil statuses. Just for verification purposes.
PLUGIN.CivilStatus = {
	"Anti-Citizen",
	"Citizen",
	"Black",
	"Brown",
	"Red",
	"Blue",
	"Green",
	"White",
	"Gold",
	"Platinum",
}

PLUGIN.Default = {
	GenericData = {
        bol = {false, ""},
        restricted = {false, ""},
        civilStatus = "Citizen",
        lastSeen = os.date("%H:%M:%S - %d/%m/%Y", os.time()),
        points = 0,
        sc = 0,
	},
	CivilianData = {
        [1] = {
           	category = "union", // med, union, civil
            text = "TRANSFERRED TO DISTRICT WORKFORCE.",
            date = os.date("%H:%M:%S - %d/%m/%Y", os.time()),
            points = "0",
            poster = {"Overwatch", "BOT"},
        },
	},
	CombineData = {
        [1] = {
           	category = "union", // med, union, civil
            text = "INSTATED AS CIVIL PROTECTOR.",
            date = os.date("%H:%M:%S - %d/%m/%Y", os.time()),
            points = "0",
            poster = {"Overwatch", "BOT"},
        },
	},
}
