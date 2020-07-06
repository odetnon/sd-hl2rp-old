
--[[------------------------------------------------------------------------------------------
    Half-Life 2 Roleplay Hub - Global Ban Plugin

    If you require support, have suggestions, questions, or concerns, please join our discord:
    https://discord.gg/hyPtDAF
--]]------------------------------------------------------------------------------------------

PLUGIN.name = "HHub Global Ban"
PLUGIN.author = "Half-Life 2 Roleplay Hub"
PLUGIN.description = "A plugin which automatically bans malicious individuals based on a Global Ban list."
PLUGIN.version = "v2"

--[[
    Add people's Steam64IDs to this list to allow them to join your server regardless if they are in the Ban List or not.
    Please use causion when utilizing this feature - people are not added to the list for no reason. Misuse could have consequences.

    Here is how your list should look:
    PLUGIN.whitelist = {
        "12345678901234567",
        "12345678901234567",
        "12345678901234567"
    }
--]]

PLUGIN.whitelist = {}

-- A function to check if the player is whitelisted from the ban list.
function PLUGIN:IsWhitelisted(plyID)
    for k, whitelistIDs in pairs(PLUGIN.whitelist) do
        if (plyID == whitelistIDs) then
            return true
        end
    end
end

if (SERVER) then
	function PLUGIN:CheckVersion()
		MsgC(Color(231, 148, 60), "[HGB] The HHub Global Ban plugin has been initialized.\n")
		MsgC(Color(231, 148, 60), "[HGB] Local Version: "..self.version.."\n")
		MsgC(Color(231, 148, 60), "[HGB] Fetching for updates...\n")
		http.Fetch("https://dl.dropboxusercontent.com/s/i9khzmgp3hl136z/hgb_version_control_nut.txt", function(body)
			local info = string.Explode("\n", body)
			local versions = {}
			for k,v in pairs(info) do
				local version_info = string.Explode(": ", v)
				versions[version_info[1]] = version_info[2]
			end

			if (versions["nutHHubGlobalBan"]) then
				if (versions["nutHHubGlobalBan"] == self.version) then
					MsgC(Color(46, 204, 113), "[HGB] The HHub Global Ban plugin is up to date!\n")
				else
					MsgC(Color(231, 76, 60), "[HGB] The HHub Global Ban plugin is out of date! Please install the latest version at your earliest convenience.\n")
					MsgC(Color(231, 76, 60), "[HGB] Local version: "..self.version.."\n")
					MsgC(Color(231, 76, 60), "[HGB] Newest version: "..versions["nutHHubGlobalBan"].."\n")
				end
			else
				MsgC(Color(231, 76, 60), "[HGB] Failed to fetch local version information!\n")
			end
		end, function()
			MsgC(Color(231, 76, 60), "[HGB] Failed to connect with Version Tracker!\n")
		end)
	end

	local Initialized = false -- Ensure the plugin is initialized.
	function PLUGIN:Think()
		if (!Initialized) then
			self:CheckVersion()
			Initialized = true
		end
    end
    
    -- Called when a player initially spawns.
    function PLUGIN:PlayerInitialSpawn(player)
        local plyName = player:Name()
        local plyID = player:SteamID64()
        local plyIp = player:IPAddress()
        local banlist

        http.Fetch("https://dl.dropboxusercontent.com/s/j08c341boqj5x8w/hgb_ban_list.txt", function(body)
			banlist = body
			MsgC(Color(231, 148, 60), "[HGB] Comparing SteamID64 '"..plyID.."' with HHub Global Ban list...\n")
			if (string.find(banlist, plyID, nil, true)) then
				if (PLUGIN:IsWhitelisted(plyID)) then
					MsgC(Color(231, 148, 60), "[HGB] "..plyName.." is in the HHub Global Ban list but is whitelisted.\n")
				else
					if (serverguard) then
						serverguard:BanPlayer(nil, plyID, 0, "Autobanned by HHubGlobalBan.")
						-- No need to add it to the chatbox since SG does it on it's own anyway.
					elseif (ULib) then
						ULib.ban(plyID, 0, "Autobanned by HHubGlobalBan.")
						-- No need to add it to the chatbox since ULX does it on it's own anyway.
					else
						player:Ban(0, true)
						RunConsoleCommand("addip", 0, plyIp) -- Ban their IP too just to be sure.
						MsgC(Color(231, 76, 60), "[HGB] "..plyName.." was automatically banned for being in the HHub Global Ban list.\n")
					end
				end
            else
                MsgC(Color(46, 204, 113), "[HGB] "..plyName.." is not in the Global Ban list.\n")
            end
        end)
    end
end
