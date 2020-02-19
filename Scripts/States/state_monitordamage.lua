function Run()
	GetScenario("scenario")
	if not HasProperty("scenario", "static") then
		--if building then start smoking
		if IsType("","Building") or IsType("","GuildResource")then
			state_monitordamage_BuildingLoop()
		
		elseif IsType("","Ship")then
			state_monitordamage_ShipLoop() 
		end
	end
end

function CleanUp()
	
end

function ShipLoop()
	
	local Filename = VehicleGetModelName("")
	local DamageStateCurrent = 0
	local DamageStateNew = 0
	
	while true do
		if (GetHPRelative("") < 0.35) then	
			DamageStateNew = 2
			SetProperty("","DamageState",2)
		elseif (GetHPRelative("") < 0.60) then
			DamageStateNew = 1
			SetProperty("","DamageState",1)
		else
			DamageStateNew = 0
			SetProperty("","DamageState",0)
		end
		
		if (DamageStateNew ~= DamageStateCurrent) then
			if AliasExists("Trine") then
				GfxDetachObject("Trine")
			end
			
			Filename = string.sub(Filename, 0, -2)
			Filename = Filename ..DamageStateNew
			DamageStateCurrent = DamageStateNew;			
			VehicleChangeModel("",Filename)
			if DamageStateNew == 2 then
				GfxAttachObject("Trine","particles/ship_burn.nif")
				AttachModel("", "Trine")
				GfxSetPosition("Trine", 0, 50, 100, true)
				GfxScale("Trine",6)
			end
			
		end
		
		Sleep(Rand(20)*0.1+1)
	end
end


function BuildingLoop()

	-- as long as this state is set, spawn Fire, smoke and wreckage particles of
	-- different intesities, depending on the hp status of the building.
	-- also play some burning sounds.
	
	if BuildingGetLevel("")<1 then
		SetState("",STATE_MONITORDAMAGE,false)
		return
	end
	
	
	local IsRuined = 0
	local SmokeStatus = 0	
	local SmokeStatusOld = 0
	local IsFighting = false
	local IsFightingOld = false
	local SmokeType = ""
	local FlameType = ""
	-- 0 no smoke
	-- 1 light smoke
	-- 2 medium smoke
	-- 3 heavy smoke
	
	local FlameSize = 6
	-- 3 small
	-- 5 medium
	-- 7 large
	
	while true do	
		local Wreckage = Rand(10)
		local j = Rand(3)
		
		if not AliasExists("") then
			return
		end
		
		GetFreeLocatorByName("", "Fire"..j,-1,-1,"ParticlePos", true)
		SmokeStatusOld = SmokeStatus
		IsFightingOld = IsFighting
		IsFighting = BattleIsFighting("")
		
		
		--RUIN 	at 10%
		if (GetHPRelative("") < 0.10) then	
			if (IsRuined == 0) then
				GetPosition("","ParticlePosition")
				StartSingleShotParticle("particles/big_crash.nif", "ParticlePosition", 3.5,20)
				PlaySound3D("","measures/76_TearDownBuilding+0.wav", 1.0)
				IsRuined = 1
				SetStateImpact("no_enter")
			end
			SmokeStatus = 4
		--HEAVY DAMAGE when building HP is lower than 30%
		else
		
			if IsRuined==1 then
				ClearStateImpact("no_enter")
				IsRuined = 0
			end
		
			if (GetHPRelative("") < 0.20) then
			--if building is under attack
				if (IsFighting == true) then
					SmokeStatus = 3
					SmokeType = "particles/smoke_heavy.nif"
					FlameType = "particles/flame_small.nif"
					FlameSize = 5
					if (Wreckage > 7) then
						PlaySound3D("Owner","fire/Explosion_s_04.wav",0.9)
						StartSingleShotParticle("particles/small_explo.nif", "ParticlePos",3,5)
						StartSingleShotParticle("particles/wreckage.nif", "ParticlePos",1,2)
					end
				--if not under attack
				else
					SmokeStatus = 3
					SmokeType = "particles/smoke_heavy.nif"
					FlameType = ""
					FlameSize = 3			
				end
		--DAMAGED when building HP is lower than 50%
			elseif (GetHPRelative("") < 0.30) then
				--if building is under attack
				if (IsFighting == true) then
					SmokeStatus = 2
					SmokeType = "particles/smoke_medium.nif"
					FlameType = "particles/flame_small.nif"
					FlameSize = 3
				--if not under attack
				else
					SmokeStatus = 2
					SmokeType = "particles/smoke_medium.nif"
					FlameType = ""
					FlameSize = 3				
				end
			--SLIGHTLY DAMAGED when building HP is lower than 90%
			elseif (GetHPRelative("") < 0.45) then
				--if building is under attack
				if (IsFighting == true) then
					SmokeStatus = 1
					SmokeType = "particles/smoke_light.nif"
					FlameType = "particles/flame_small.nif"
					FlameSize = 2
				--if not under attack
				else
					SmokeStatus = 1
					SmokeType = "particles/smoke_light.nif"
					FlameType = ""
				end	
			
			--UNDAMAGED full repair
			else
				IsFighting = BattleIsFighting("")
				IsRuined = 0
				SmokeStatus = 0
				SmokeType = ""
				FlameType = ""
			end
		end
		
		--check if the damage state has changed
		if SmokeStatusOld ~= SmokeStatus or IsFightingOld ~= IsFighting then
		
			local Detach = not (GetState("",STATE_BURNING) or GetState("",STATE_REPAIRING) or GetState("",STATE_BUILDING) or GetState("",STATE_LEVELINGUP))
			if Detach then
				-- Detach3DSound("")
			end
			if (IsFighting == true) then
				if (SmokeStatus == 1) then
					Attach3DSound("","fire/Fire_l_01.wav", 1.0)
				elseif (SmokeStatus == 2) then
					Attach3DSound("","fire/Fire_l_02.wav", 1.0)
				elseif (SmokeStatus == 3) then
					Attach3DSound("","fire/Fire_01.wav", 1.0)
				else
					-- Detach3DSound("")
				end
			else
				if Detach then
					-- Detach3DSound("")
				end
			end
			
			-- count the fire locator
			FireLocatorCount = 1
			while GetFreeLocatorByName("", "Fire"..FireLocatorCount, -1, -1, "SmokeLocator"..FireLocatorCount, true) do
				FireLocatorCount = FireLocatorCount + 1
			end
			FireLocatorCount = FireLocatorCount - 1
			
			--remove existing smoke and Fire particles
			local SmokeCount
			SmokeCount = FireLocatorCount-1
			while(SmokeCount > 0) do
				GfxStopParticle("Smoke"..SmokeCount)
				GfxStopParticle("Flames"..SmokeCount)
				SmokeCount = SmokeCount -1
			end
			
			-- create the smoke particles, size and position them
			if SmokeType~="" and not GetState("",STATE_BURNING) then
				SmokeCount = FireLocatorCount-1
				while(SmokeCount > 0) do
				
					GfxStartParticle("Smoke"..SmokeCount, SmokeType, "SmokeLocator"..SmokeCount, 7)
					SmokeCount = SmokeCount -1	
				end
			end
			
			-- create the flame particles, size and position them
			SmokeCount = FireLocatorCount-1
			if FlameType~="" then
				while(SmokeCount > 0) do
					GfxStartParticle("Flames"..SmokeCount, FlameType,"SmokeLocator"..SmokeCount, FlameSize)
					SmokeCount = SmokeCount -1							
				end
			end
		end			
		Sleep(Rand(20)*0.1+1)
	end
end



