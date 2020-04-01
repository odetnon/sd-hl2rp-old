
ITEM.name = "Combine Lock"
ITEM.description = "A combine made door lock"
ITEM.model = "models/props_combine/combine_lock01.mdl"
ITEM.height = 2

ITEM.functions.Place = {
	isMulti = true,
	multiOptions = {
		[1] = {
			name = "Combine Lock",
			data = {
				lockType = 1
			}
		},
		[2] = {
			name = "CWU Lock",
			data = {
				lockType = 2
			}
		},
		[3] = {
			name = "Union Lock",
			data = {
				lockType = 3
			}
		}
	},
	OnRun = function(itemTable, data)
		local client = itemTable.player
		local traceData = {}
			traceData.start = client:GetShootPos()
			traceData.endpos = traceData.start + client:GetAimVector() * 96
			traceData.filter = client

		local lock = scripted_ents.Get("ix_combinelock"):SpawnFunction(client, util.TraceLine(traceData))

		if (IsValid(lock)) then
			lock:SetLockMode(data.lockType or 1)

			client:EmitSound("physics/metal/weapon_impact_soft2.wav", 75, 80)
		else
			return false
		end
	end
}
