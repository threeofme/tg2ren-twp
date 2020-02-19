function Init()
	if IsType("","Building") then
		SetStateImpact("no_enter")
	end
end

function Run()

	--contaminated also works for perfume on sims
	if IsType("","Sim") then
		if GetImpactValue("","perfume")==1 then
			CommitAction("perfume","","")
			while GetImpactValue("","perfume")>0 do
				Sleep(5)
			end
			StopAction("perfume", "")
			SetState("",STATE_CONTAMINATED,false)
			return
		end
	end
	
	--Pox
	if IsType("","Sim") then
		if GetImpactValue("","Pox")==1 then
			CommitAction("Pox","","")
			while GetImpactValue("","Pox")>0 do
				Sleep(5)
			end
			StopAction("Pox", "")
			SetState("",STATE_CONTAMINATED,false)
			return
		end
	end

	--der Kamm wirkt bei Amtskollegen
	if IsType("","Sim") then
		if GetImpactValue("","kamm")==1 then
			CommitAction("kamm","","")
			while GetImpactValue("","kamm")>0 do
				Sleep(5)
			end
			SetState("",STATE_CONTAMINATED,false)
			return
		end
	end
	
	-- Solange der State contaminated gesetzt ist, immer alle Leute aus dem Gebäude schmeissen
	-- Der State wird aufgehoben, sobald der impact zurueckgesetzt wird
	if (BuildingGetType("")==GL_BUILDING_TYPE_WELL) then
		if GetImpactValue("","polluted")==1 then
		-- Fajeth Mod
			CommitAction("PollutedWell","","")
		-- Mod End
			GetPosition("","ParticleSpawnPos")
			GfxStartParticle("Smoke", "particles/toadexcrements.nif", "ParticleSpawnPos", 4)
			while (GetImpactValue("","polluted")==1) do
				if GetImpactValue("","toadexcrements")==1 then
				Evacuate("")
				end
			Sleep(5)
			end
			-- Fajeth Mod
			StopAction("PollutedWell","")
			-- Mod end
			SetState("",STATE_CONTAMINATED,false)
			return
		end
		return
	end
	
	-- count the fire locator
	FireLocatorCount = 1
	while GetFreeLocatorByName("Owner", "Fire"..FireLocatorCount, -1, -1, "SmokeLocator"..FireLocatorCount) do
		FireLocatorCount = FireLocatorCount + 1
	end
	FireLocatorCount = FireLocatorCount - 1
	-- create the smoke particles, size and position them
	SmokeCount = FireLocatorCount-1
	while(SmokeCount > 0) do
	
		GfxStartParticle("Smoke"..SmokeCount, "particles/toadexcrements.nif", "SmokeLocator"..SmokeCount, 7)
		SmokeCount = SmokeCount -1	
	end
	
	while (GetImpactValue("","toadexcrements")==1)  do
		Evacuate("Owner")
		Sleep(2)
	end
end

function CleanUp()
	
	SetState("Owner", STATE_CONTAMINATED, false)
	if HasProperty("Owner", "perfume") then
		RemoveProperty("Owner","perfume")
	end
	
end

