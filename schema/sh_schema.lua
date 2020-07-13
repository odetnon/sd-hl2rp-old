
Schema.name = "HL2 RP"
Schema.author = "nebulous.cloud"
Schema.description = "A schema based off of HL2."

ix.util.Include("sh_commands.lua")
ix.util.Include("sh_configs.lua")
ix.util.Include("sh_voices.lua")

ix.util.Include("cl_hooks.lua")
ix.util.Include("sh_hooks.lua")
ix.util.Include("sv_hooks.lua")
ix.util.Include("sv_schema.lua")

ix.util.Include("meta/sh_player.lua")
ix.util.Include("meta/sh_character.lua")

ix.anim.SetModelClass("models/characters/combine_soldier/jqblk/combine_s.mdl", "overwatch")
ix.anim.SetModelClass("models/characters/combine_soldier/jqblk/combine_s_super.mdl", "overwatch")
ix.anim.SetModelClass("models/cultist/hl_a/metropolice/npc/metrocop.mdl", "metrocop")
ix.anim.SetModelClass("models/cultist/hl_a/worker/hazmat_2/npc/hazmat_2.mdl", "citizen_male")
ix.anim.SetModelClass("models/cultist/hl_a/worker/hazmat_1/npc/hazmat_1.mdl", "citizen_male")
ix.anim.SetModelClass("models/player/female_02_suit.mdl", "citizen_female")
ix.anim.SetModelClass("models/hlvr/characters/vortigaunt/vortigaunt_uncombined_hlvr.mdl", "vortigaunt")
ix.anim.SetModelClass("models/hlvr/characters/vortigaunt/vortigaunt_hlvr.mdl", "vortigaunt")

for i = 1, 4 do
	ix.anim.SetModelClass( "models/humans/medic/female_0"..i..".mdl", "citizen_female" )
end
	
for i = 6, 7 do
	ix.anim.SetModelClass( "models/humans/medic/female_0"..i..".mdl", "citizen_female" )
end
						
for i = 1, 9 do
	ix.anim.SetModelClass( "models/humans/medic/male_0"..i..".mdl", "citizen_male" )
end

function Schema:IsCombineRank(text, rank)
	return string.find(text, "[%D+]"..rank.."[%D+]")
end
-- Dispatch chat class.
do
	local CLASS = {}
	CLASS.color = Color(150, 100, 100)
	CLASS.format = "Dispatch broadcasts \"%s\""

	function CLASS:CanSay(speaker, text)
		if (!speaker:IsDispatch()) then
			speaker:NotifyLocalized("notAllowed")

			return false
		end
	end

	function CLASS:OnChatAdd(speaker, text)
		chat.AddText(self.color, string.format(self.format, text))
	end

	ix.chat.Register("dispatch", CLASS)
end
-- Request chat class.
do
	local CLASS = {}
	CLASS.color = Color(175, 125, 100)
	CLASS.format = "%s requests \"%s\""

	function CLASS:CanHear(speaker, listener)
		return listener:IsCombine() or listener:IsDispatch()
	end

	function CLASS:OnChatAdd(speaker, text)
		chat.AddText(self.color, string.format(self.format, speaker:Name(), text))
		Schema:AddCombineDisplayMessage("@cRequest", Color(0, 0, 255, 255), nil, speaker:Name())
		Schema:AddWaypoint(client:GetPos(), "Civil Request", Color(0, 0, 255, 255), 300, client)
	end

	ix.chat.Register("request", CLASS)
end
-- Request eavesdrop chat class
do
	local CLASS = {}
	CLASS.color = Color(175, 125, 100)
	CLASS.format = "%s requests \"%s\""

	function CLASS:CanHear(speaker, listener)
		if (ix.chat.classes.request:CanHear(speaker, listener)) then
			return false
		end

		local chatRange = ix.config.Get("chatRange", 280)

		return (speaker:GetPos() - listener:GetPos()):LengthSqr() <= (chatRange * chatRange)
	end

	function CLASS:OnChatAdd(speaker, text)
		chat.AddText(self.color, string.format(self.format, speaker:Name(), text))
	end

	ix.chat.Register("request_eavesdrop", CLASS)
end
-- Broadcast chat class
do
	local CLASS = {}
	CLASS.color = Color(150, 125, 175)
	CLASS.format = "%s broadcasts \"%s\""

	function CLASS:CanSay(speaker, text)
		if (speaker:Team() != FACTION_CAB) then
			speaker:NotifyLocalized("notAllowed")

			return false
		end
	end

	function CLASS:OnChatAdd(speaker, text)
		chat.AddText(self.color, string.format(self.format, speaker:Name(), text))
	end

	ix.chat.Register("broadcast", CLASS)
end
