
local communityCommands = {
	["Content"] = {desc = "Open the servers content pack.", url = "https://steamcommunity.com/sharedfiles/filedetails/?id=1593990171"},
	["Discord"] = {desc = "Get the community discord invite link.", url = "https://discord.gg/agwxw24"},
	["Forums"] = {desc = "Open the community forums.", url = "https://pulse-phase.com"}
}

do
	for cmd, cmdTbl in pairs(communityCommands) do
		ix.command.Add(cmd, {
			description = cmdTbl.desc,
			OnRun = function(self, client)
				client:SendLua("gui.OpenUrl(\""..cmbTbl.url.."\")")
			end
		})
	end
end

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.character
	COMMAND.privilege = "Manage Character Flags"
	COMMAND.superAdminOnly = true
	COMMAND.description = "@cmdCharViewFlags"

	function COMMAND:OnRun(client, target)
		if (target:GetFlags() != "") then
			client:NotifyLocalized("charFlags", client:GetName(), target:GetFlags())
		else
		    client:NotifyLocalized("charNoFlags", target:GetName())
		end
	end

	ix.command.Add("CharViewFlags", COMMAND)
end
