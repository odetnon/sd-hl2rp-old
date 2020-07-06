PLUGIN.name = "OTA Shoving"
PLUGIN.description = "Implements shoving for OTA characters."


COMMAND = {}

function COMMAND:OnCheckAccess(client)
	return client:Team() == FACTION_OTA and client:OnGround()
end

function COMMAND:OnRun(client)
	
	client:ForceSequence("melee_gunhit", nil, 0.89999995708466, true)

	local trace = util.TraceLine({
		start = client:EyePos() - client:EyeAngles():Forward() * 4,
		endpos = client:EyePos() + client:EyeAngles():Forward() * 94,
		filter = client
	})

	timer.Simple(0.4, function()
		if (!IsValid(client)) then return end

		client:ViewPunch(Angle(-10, 10, -3))

		if (IsValid(trace.Entity)) then
			local target = trace.Entity
			local hitGroup = trace.HitGroup

			if (target:IsPlayer()) then
				target:ViewPunch(Angle(-12, -12, 0))
			end

			target:SetGroundEntity(nil)

			local forward = Angle(0, client:EyeAngles().y, 0):Forward()

			if (IsValid(target:GetPhysicsObject()) and !(target:IsNPC() or target:IsPlayer())) then
				target:GetPhysicsObject():SetVelocity(forward * 200)
				target:TakeDamage(10, client, client)
			else
				target:SetVelocity(forward * 200)
			end

			if (target:IsPlayer() and (hitGroup == HITGROUP_HEAD or hitGroup == HITGROUP_CHEST or hitGroup == HITGROUP_STOMACH)) then
				target:SetRagdolled(true, ix.config.Get("shoveTime", 20))

				local force = forward * 250 + target:EyeAngles():Forward() * -100
				local ragdoll = Entity(target:GetLocalVar("ragdoll", 0))

				if (IsValid(ragdoll)) then
					local headIndex = ragdoll:LookupBone("ValveBiped.Bip01_Head1")

					for i = 1, ragdoll:GetPhysicsObjectCount() do
						local physicsObject = ragdoll:GetPhysicsObjectNum(i)
						local boneIndex = ragdoll:TranslatePhysBoneToBone(i)

						if (IsValid(physicsObject)) then
							physicsObject:ApplyForceCenter(boneIndex == headIndex and force * 1.5 or force)
						end
					end
				end

				target:ScreenFade(SCREENFADE.IN, color_black, 4, 10)
				target:SetDSP(133)

				timer.Simple(5, function()
					if (IsValid(target)) then
						target:SetDSP(0)
					end
				end)
			end

			sound.Play("NPC_Combine.WeaponBash", trace.HitPos)
		end
	end)
end

ix.command.Add("Shove", COMMAND)