
local PLUGIN = PLUGIN

PLUGIN.name = "Medical"
PLUGIN.author = "wowm0d"
PLUGIN.description = "Adds an enhanced Medical system."

ix.util.Include("sv_hooks.lua")
ix.util.Include("meta/sv_player.lua")

ix.config.Add("maxHealBoost", 100, "The maximum you can slowly heal at any time.", nil, {
	data = {min = 1, max = 256},
	category = "Medical"
})

ix.config.Add("healRepetitions", 4, "How many repetitions of the delay it should take to heal fully.", nil, {
	data = {min = 1, max = 10},
	category = "Medical"
})

ix.config.Add("healDelay", 10, "How long between each repetitions to slow heal.", nil, {
	data = {min = 1, max = 64},
	category = "Medical"
})
