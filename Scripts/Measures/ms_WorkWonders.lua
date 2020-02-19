-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_WorkWonders"
----
----	With this measure the player can stop a catastrophe in a certain area
----  
----  1. Zielgebiet wählen
----  2. Kardinal schickt Stossgebet
----  3. Auswirkungen einer Katastrophe verschwinden (Pestkranke werden geheilt, Feuer hören auf zu brennen etc.)
----     (Alle Sims und Gebäude im Aktionsradius sind betroffen)
----  (3b. Gerade wütende Katastrophen werden beendet ??)
----  
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()
	PlayAnimationNoWait("","preach")
	Sleep(2)
	
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	SetMeasureRepeat(TimeOut)
	GetPosition("","ParticleSpawnPos")
	GetPosition("","ParticleSpawnPos2")
	PositionModify("ParticleSpawnPos",0,20,0)
	PositionModify("ParticleSpawnPos2",0,-100,0)
	StartSingleShotParticle("particles/miracle.nif","ParticleSpawnPos",1,1)
	StartSingleShotParticle("particles/rage.nif","ParticleSpawnPos",2,1)
	StartSingleShotParticle("particles/summon2.nif","ParticleSpawnPos2",5,2)
	StartSingleShotParticle("particles/pray_glow.nif","ParticleSpawnPos2",15,2)
	
	local SimFilter = "__F((Object.GetObjectsByRadius(Sim)==1600)AND NOT(Object.GetState(townnpc)))"
	local NumSims = Find("",SimFilter,"Sim",-1)
	if NumSims > 0 then
		for i=0,NumSims-1 do
			GetPosition("Sim"..i,"PSpawn")
			StartSingleShotParticle("particles/aesculap.nif","PSpawn",1.3,1)
			if (GetHP("Sim"..i) < GetMaxHP("Sim"..i)) then
				ModifyHP("Sim"..i,GetMaxHP("Sim"..i))
			end
			if GetImpactValue("Sim"..i,"Sickness")>0 then
				diseases_Sprain("Sim"..i,false)	
				diseases_Cold("Sim"..i,false)
				diseases_Influenza("Sim"..i,false)
				diseases_BurnWound("Sim"..i,false)
				diseases_Pox("Sim"..i,false)
				diseases_Pneumonia("Sim"..i,false)
				diseases_Blackdeath("Sim"..i,false)
				diseases_Fracture("Sim"..i,false)
				diseases_Caries("Sim"..i,false)
				MoveSetActivity("Sim"..i,"")
				if GetCurrentMeasureName("Sim"..i)=="idle" then
					StopMeasure("Sim"..i)
				end
			end
		end
	end
	local BuildingFilter = "__F((Object.GetObjectsByRadius(Building)==1600)AND NOT(Object.HasImpact(Fever))"
	local NumBuilding = Find("",BuildingFilter,"Building",-1)
	if NumBuilding > 0 then
		for i=0,NumBuilding-1 do
			GetPosition("Building"..i,"PSpawn")
			StartSingleShotParticle("particles/pray_glow.nif","PSpawn",10,2)
			if GetState("Building"..i,STATE_BURNING) then
				SetState("Building"..i,STATE_BURNING,false)
			end
			if GetImpactValue("Building"..i,"toadexcrements")==1 then
				RemoveImpact("Building"..i,"toadexcrements")
			end
		end
	end	
	
	chr_GainXP("",GetData("BaseXP"))
	Sleep(5)
	
end

function CleanUp()
	StopAnimation("")
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

