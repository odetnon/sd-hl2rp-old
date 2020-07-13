
local communityCommands = {
	["Content"] = {desc = "Open the servers content pack.", url = "https://steamcommunity.com/sharedfiles/filedetails/?id=1593990171"},
	["Discord"] = {desc = "Get the community discord invite link.", url = "https://discord.gg/CZpYthQ"},
}

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text

	function COMMAND:OnRun(client, message)
		if (!client:IsRestricted()) then
			ix.chat.Send(client, "dispatch", message)
		else
			return "@notNow"
		end
	end

	ix.command.Add("Dispatch", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text

	function COMMAND:OnRun(client, message)
		local character = client:GetCharacter()
		local inventory = character:GetInventory()

		if (inventory:HasItem("request_device") or client:IsCombine() or client:Team() == FACTION_CAB) then
			if (!client:IsRestricted()) then
				Schema:AddCombineDisplayMessage("@cRequest")

				ix.chat.Send(client, "request", message)
				ix.chat.Send(client, "request_eavesdrop", message)
			else
				return "@notNow"
			end
		else
			return "@needRequestDevice"
		end
	end

	ix.command.Add("Request", COMMAND)
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

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text

	function COMMAND:OnRun(client, message)
		if (!client:IsRestricted()) then
			ix.chat.Send(client, "broadcast", message)
		else
			return "@notNow"
		end
	end

	ix.command.Add("Broadcast", COMMAND)
end

do
	local COMMAND = {}

	function COMMAND:OnRun(client, arguments)
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local target = util.TraceLine(data).Entity

		if (IsValid(target) and target:IsPlayer() and target:IsRestricted()) then
			if (!client:IsRestricted()) then
				Schema:SearchPlayer(client, target)
			else
				return "@notNow"
			end
		end
	end

	ix.command.Add("CharSearch", COMMAND)
end

do
	for cmd, cmdTbl in pairs(communityCommands) do
		ix.command.Add(cmd, {
			description = cmdTbl.desc,
			OnRun = function(self, client)
				client:SendLua("gui.OpenURL(\""..cmdTbl.url.."\")")
			end
		})
	end
end
