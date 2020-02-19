-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_RoyalGuard"
----
----	With this measure the player can send out the royal guard
----  
----  1. Die Garde radiert alle Gauner im Zielgebiet über eine gewisse Zeitspanne aus
----  2. Jede Dynastie erhält eine Nachricht über die bevorstehende "Razzia"
----  3. Nach einer Zeit spawnt die Garde (sehr starte Kampfeinheiten) im Zielgebiet
----  4. Danach verschwindet die Garde wieder
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()
		
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	-- Get the residence of the king
	if not GetHomeBuilding("", "HomeBuilding") then
		StopMeasure()
	end
	
	local CurMeasID = GetCurrentMeasureID("")
	
	-- Spawn the guards at the home building
	GetLocatorByName("HomeBuilding", "Entry1", "GuardSpawnPos")
	for i=0, 4 do
	local i = 0
		if not SimCreate(50, "HomeBuilding", "GuardSpawnPos", "Guard"..i) then
			StopMeasure()
		else			
			local PosX, PosY, PosZ = GetWorldPositionXYZ("Destination")
			SetProperty("Guard"..i, "DestX", Rand(500)+PosX)
			SetProperty("Guard"..i, "DestZ", Rand(500)+PosZ)
			SetProperty("Guard"..i, "CurMeasID", CurMeasID)
			SetProperty("Guard"..i, "DynID", GetDynastyID(""))
			SimSetBehavior("Guard"..i, "RoyalGuardDuty")
		end
	end
	
	SetMeasureRepeat(TimeOut)
	
end

-- -----------------------
-- GetOSHData
-- -----------------------
function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2", Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
end

