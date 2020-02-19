function Init()
	SetStateImpact("no_upgrades")
	SetStateImpact("no_enter")
end

function Run()
  Evacuate("", false) 
	
	local FireFactor = 1.25 - GetImpactValue("Owner", "ProtectionFromFire")
	local PercentDamage = 70* FireFactor
	if PercentDamage <= 0 then
		return
	end
	local BurnToHP = 0
	BurnToHP = GetMaxHP("")-(GetMaxHP("")*(PercentDamage/100))
	if BurnToHP < (GetMaxHP("")*0.2) then
		BurnToHP = -25
	end
	SetProperty("Owner", "BurnToHP", BurnToHP)
	SetProperty("Owner", "BurningToDo", PercentDamage)

	CommitAction("fire","Owner","Owner")
	
	-- prevents worker's dwellings from being destroyed
	
	local BurnToHP = 0
	BurnToHP = GetMaxHP("")-(GetMaxHP("")*(PercentDamage/100))
	if BuildingGetType("")==1 then
		if BurnToHP < (GetMaxHP("")*0.2) then	
			BurnToHP = (GetMaxHP("")*0.2)
		end
	end 

	-- count the fire locator
	local FireLocatorCount = 1
	while GetFreeLocatorByName("Owner", "Fire"..FireLocatorCount, -1, -1, "FlameLocator"..FireLocatorCount) do
		FireLocatorCount = FireLocatorCount + 1
	end

	if FireLocatorCount>0 then
		FireLocatorCount = FireLocatorCount
	end

	-- create the flame particles, size and position them
	local FlameCount
	for FlameCount=1, FireLocatorCount-1 do
		if AliasExists("FlameLocator"..FlameCount) then
			GfxStartParticle("Flames"..FlameCount, "particles/fire1.nif", "FlameLocator"..FlameCount, 5)
		end
	end

	local SmokeCount
	for SmokeCount=1, FireLocatorCount-1 do
		GfxStartParticle("Smoke"..SmokeCount, "particles/smoke_light.nif", "FlameLocator"..SmokeCount, 5)

	end

	-- create the spark particles, size and position them
	local SparkCount
	for SparkCount=1, FireLocatorCount-1 do
		if AliasExists("FlameLocator"..SparkCount) then
			GfxStartParticle("Spark"..SparkCount, "particles/spark1.nif", "FlameLocator"..SparkCount, 8)
		end
	end

	Attach3DSound("", "fire/Fire_01.wav", 1,0)
	
	local DPS = (FireFactor/150)*GetMaxHP("")

	while GetHP("Owner")>BurnToHP do

		Evacuate("Owner")
		Sleep(3)
		Attach3DSound("", "fire/Fire_01.wav", 1,0)

		PercentDamage = GetProperty("Owner", "BurningToDo")
		if not PercentDamage or PercentDamage<1 then
			break
		end
		if (Weather_GetSeason()==3) then
			DPS = DPS * 0.75
		end
		ModifyHP("Owner", -DPS, false)
		--TFTODO: RAIN DAY
		BurnToHP = GetProperty("Owner","BurnToHP")
		local RainValue = Weather_GetValue(0)
		if RainValue > 0 then
			BurnToHP = GetProperty("Owner","BurnToHP")
			local NewValue = 0+BurnToHP+(RainValue*(0.03*GetMaxHP("Owner")))
			SetProperty("Owner","BurnToHP",NewValue )
		end


		PercentDamage = PercentDamage - FireFactor
		SetProperty("Owner", "BurningToDo", PercentDamage)
		local BuildingFilter = "__F((Object.GetObjectsByRadius(Building) == 1500)AND NOT(Object.GetState(burning))AND NOT(Object.HasImpact(Extinguished))AND NOT(Object.IsClass(5))AND NOT(Object.IsClass(3))AND NOT(Object.IsClass(6))AND NOT(Object.IsClass(0)))"
		local NumBuildings = Find("",BuildingFilter,"NexBuilding", -1)
		local FirePos = 95
		local ExtPos = 95
		if (Weather_GetSeason()==1) then -- higher chance for fire going to next building in summer
			FirePos = FirePos - 5
			ExtPos = ExtPos + 2 -- lesser chance for fire getting extinguished by rain in summer
		elseif (Weather_GetSeason()==3) then -- lower chance for fire going to next building in winter
			FirePos = FirePos + 2
			ExtPos = ExtPos - 2 -- higher chance for fire getting extinguished by snow in summer
		elseif (Weather_GetSeason()==2) then -- slightly lower chance for fire going to next building in winter
			FirePos = FirePos + 1
			ExtPos = ExtPos - 5 -- higher chance for fire getting extinguished by rain in fall
		end

		if (Weather_GetValue(0) > 0.5) then -- weather value 0 is precipitation
			FirePos = FirePos + 2 -- lesser chance for fire going to next building when rain or snow
			if (Rand(100) > ExtPos) then
				break
			end
		end
		
		if NumBuildings > 0 then
			if Rand(100) > FirePos then
				local DestAlias = "NexBuilding"..Rand(NumBuildings-1)
				local FireProtection = GetImpactValue(DestAlias,"ProtectionFromFire")*100
				if (Rand(100) >= FireProtection) then
					if GetPosition("","ParticleSpawnPos") then
						StartSingleShotParticle("particles/Explosion.nif", "ParticleSpawnPos", 4,5)
						PlaySound3D(DestAlias,"fire/Explosion_s_01.wav", 1.0)
						Sleep(2)
					end
					SetState(DestAlias,STATE_BURNING,true)
				end
			end
		end
		AddImpact("","Extinguished",1,4)
	end

	SetState("OWNER", STATE_BURNING, false)

end

function CleanUp()
	Detach3DSound("")
	StopAction("fire","Owner")
	RemoveProperty("Owner", "BurningToDo")
	RemoveProperty("Owner", "BurnToHP")
end
