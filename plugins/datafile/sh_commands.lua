
local PLUGIN = PLUGIN

ix.command.Add("Datafile", {
	description = "View the datafile of someone.",
	arguments = {
		ix.type.player,
	},
	OnRun = function(self, player, target)
	    if (target) then
	        if (PLUGIN:IsRestrictedFaction(target) or !PLUGIN:HasDatafile(target)) then
            	player:Notify("This datafile does not exist.")
        	else
            	PLUGIN:HandleDatafile(player, target)
       	 	end
	    else
	        player:Notify("This datafile does not exist.")
	    end
	end
})

ix.command.Add("ClearDatafile", {
	description = "Scrub someone their datafile.",
	superAdminOnly = true,
	arguments = {
		ix.type.player,
	},
	OnRun = function(self, player, target)
		if (target) then
        	PLUGIN:ClearDatafile(target)
   		else
        	player:Notify("You have entered an invalid character.")
    	end
	end
})

ix.command.Add("ManageDatafile", {
	description = "Manage the datafile of someone.",
	arguments = {
		ix.type.player,
	},
	OnRun = function(self, player, target)
		if (target) then
			local permission = PLUGIN:ReturnPermission(player)

       		if (permission == DATAFILE_PERMISSION_ELEVATED) then
	       		net.Start("CreateManagementPanel")
	       			net.WriteTable({target, PLUGIN:ReturnDatafile(target)})
	       		net.Send(player)
	       	else
	       	    player:Notify("You are not authorized to manage this datafile.")
	       	end
	    else
	        player:Notify("This datafile does not exist.")
	    end
	end
})

ix.command.Add("RestrictDatafile", {
	description = "Make someone their datafile (un)restricted.",
	arguments = {
		ix.type.player,
		bit.bor(ix.type.string, ix.type.optional),
	},
	OnRun = function(self, player, target, reason)
	    local text = reason

	    if (!text or text == "") then
	    	text = nil
	    end

	    if (target) then
	    	if (PLUGIN:ReturnPermission(player) >= DATAFILE_PERMISSION_FULL) then
	    		if (text) then
		        	PLUGIN:SetRestricted(true, text, target, player)

		        	player:Notify(target:Name() .. "'s file has been restricted.")
	    		else
		        	PLUGIN:SetRestricted(false, "", target, player)

		        	player:Notify(target:Name() .. "'s file has been unrestricted.")
	    		end
		    else
		    	player:Notify("You do not have access to this command.")
		    end
	    else
	        player:Notify("You have entered an invalid character.")
	    end
	end
})