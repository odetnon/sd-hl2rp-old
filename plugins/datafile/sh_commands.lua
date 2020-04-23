
local PLUGIN = PLUGIN

ix.command.Add("Datafile", {
	description = "View the datafile of someone.",
	arguments = {
		ix.type.player,
	},
	OnRun = function(self, client, target)
	    if (target) then
	        if (PLUGIN:IsRestrictedFaction(target) or !PLUGIN:HasDatafile(target)) then
            	client:Notify("This datafile does not exist.")
        	else
            	PLUGIN:HandleDatafile(client, target)
       	 	end
	    else
	        client:Notify("This datafile does not exist.")
	    end
	end
})

ix.command.Add("ClearDatafile", {
	description = "Scrub someone their datafile.",
	superAdminOnly = true,
	arguments = {
		ix.type.player,
	},
	OnRun = function(self, client, target)
		if (target) then
        	PLUGIN:ClearDatafile(target)
   		else
        	client:Notify("You have entered an invalid character.")
    	end
	end
})

ix.command.Add("ManageDatafile", {
	description = "Manage the datafile of someone.",
	arguments = {
		ix.type.player,
	},
	OnRun = function(self, client, target)
		if (target) then
			local permission = PLUGIN:ReturnPermission(client)

       		if (permission == DATAFILE_PERMISSION_ELEVATED) then
	       		net.Start("CreateManagementPanel")
	       			net.WriteEntity(target)
	       			net.WriteTable(PLUGIN:ReturnDatafile(target))
	       		net.Send(client)
	       	else
	       	    client:Notify("You are not authorized to manage this datafile.")
	       	end
	    else
	        client:Notify("This datafile does not exist.")
	    end
	end
})

ix.command.Add("RestrictDatafile", {
	description = "Make someone their datafile (un)restricted.",
	arguments = {
		ix.type.player,
		bit.bor(ix.type.string, ix.type.optional),
	},
	OnRun = function(self, client, target, reason)
	    local text = reason

	    if (!text or text == "") then
	    	text = nil
	    end

	    if (target) then
	    	if (PLUGIN:ReturnPermission(client) >= DATAFILE_PERMISSION_FULL) then
	    		if (text) then
		        	PLUGIN:SetRestricted(true, text, target, client)

		        	client:Notify(target:Name() .. "'s file has been restricted.")
	    		else
		        	PLUGIN:SetRestricted(false, "", target, client)

		        	client:Notify(target:Name() .. "'s file has been unrestricted.")
	    		end
		    else
		    	client:Notify("You do not have access to this command.")
		    end
	    else
	        client:Notify("You have entered an invalid character.")
	    end
	end
})
