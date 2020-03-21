
Schema.name = "HL2 RP"
Schema.author = "wowm0d"
Schema.description = "A schema based off of HL2."

ix.util.Include("sh_commands.lua")
ix.util.Include("meta/sh_player.lua")
ix.util.Include("meta/sh_character.lua")

do
	local CLASS = {}
	CLASS.color = Color(177, 125, 26)
	CLASS.format = "%s broadcasts \"%s\""

	ix.chat.Register("dispatch", CLASS)
end

ix.anim.SetModelClass("models/bloocobalt/combine/combine_e.mdl", "overwatch")
ix.anim.SetModelClass("models/bloocobalt/combine/combine_s.mdl", "overwatch")
ix.anim.SetModelClass("models/dpfilms/metropolice/hdpolice.mdl", "metrocop")
