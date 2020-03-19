
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
