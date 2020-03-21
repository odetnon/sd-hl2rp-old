
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

for i = 1, 7 do
	if (i == 7) then
		ix.anim.SetModelClass("models/kake/metropolice_female06_naomi.mdl", "metrocop")
	else
		ix.anim.SetModelClass("models/kake/metropolice_female0"..i..".mdl", "metrocop")
	end
end

for i = 1, 10 do
	if (i == 10) then
		ix.anim.SetModelClass("models/kake/metropolice_male09_hair.mdl", "metrocop")
	else
		ix.anim.SetModelClass("models/kake/metropolice_male0"..i..".mdl", "metrocop")
	end
end
