
local PLUGIN = PLUGIN

PLUGIN.name = "Enhanced Radio"
PLUGIN.author = "wowm0d"
PLUGIN.description = "Adds extended radio library and utilies."

if (SERVER) then
	util.AddNetworkString("ixItemFrequency")
end

ix.util.Include("cl_hooks.lua")
ix.util.Include("sv_hooks.lua")

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text
	COMMAND.alias = "R"

	function COMMAND:OnRun(client, message)
		return ix.radio.SayRadio(client, message)
	end

	ix.command.Add("Radio", COMMAND)

	COMMAND = {}
	COMMAND.arguments = ix.type.text
	COMMAND.alias = "RW"

	function COMMAND:OnRun(client, message)
		return ix.radio.SayRadio(client, message, {chatType = "w"})
	end

	ix.command.Add("RadioWhisper", COMMAND)

	COMMAND = {}
	COMMAND.arguments = ix.type.text
	COMMAND.alias = "RY"

	function COMMAND:OnRun(client, message)
		return ix.radio.SayRadio(client, message, {chatType = "y"})
	end

	ix.command.Add("RadioYell", COMMAND)
end

function PLUGIN:InitializedChatClasses()
	local CLASS = {}
	CLASS.color = Color(75, 150, 50)
	CLASS.format = "%s %s on %s: \"%s\""

	function CLASS:OnChatAdd(speaker, text, anonymous, data)
		local textColor = data.color and data.color or self.color
		local speakerName = hook.Run("GetCharacterName", speaker, "radio_trasmit") or speaker:Name()

		chat.AddText(textColor, string.format(self.format, speakerName, data.prefix, data.channel, text))
	end

	ix.chat.Register("radio_transmit", CLASS)

	CLASS = {}
	CLASS.GetColor = ix.chat.classes.ic.GetColor
	CLASS.format = "%s %s on radio: \"%s\""

	function CLASS:OnChatAdd(speaker, text, anonymous, data)
		local speakerName = hook.Run("GetCharacterName", speaker, "radio_trasmit") or speaker:Name()

		if (data.prefix == "radios") then
			data.prefix = "says"
		end

		chat.AddText(self:GetColor(speaker, text), string.format(self.format, speakerName, data.prefix, text))
	end

	ix.chat.Register("radio_eavesdrop", CLASS)
end
