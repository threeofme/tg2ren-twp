-------------------------------------------------------------------------------
----
----	OVERVIEW "state_levelingup"
----
----	With this state a building is leveled up
----
-------------------------------------------------------------------------------

-- -----------------------
-- Init
-- -----------------------
function Init()
	SetStateImpact("no_upgrades")
	SetStateImpact("upgrading")	
end

-- -----------------------
-- Run
-- -----------------------
function Run()
	local MovingBuilding = GetState("",STATE_MOVING_BUILDING)
	
	if MovingBuilding then
		SetState("",STATE_MOVING_BUILDING, false)
	end

	local	Proto = GetProperty("", "LevelUpProto")
	if not Proto then
		return
	end
	AddImpact("","LevelingUp",1,-1)		
	local BuildTime = GetDatabaseValue("Buildings", Proto, "buildtime") or 0.01
	local TotalTime = 0.666 * BuildTime
	
	local 	H4x0r = GetSettingNumber("DEBUG", "DisableBuildtime", 0)
	if (H4x0r==1) then
		TotalTime = 0.01 
	end
	Attach3DSound("", "measures/ms_BuildHouse_s_01.wav", 1.0)
	local MaxTotalTime	= Gametime2Realtime(TotalTime)
	
	SetProcessMaxProgress("",MaxTotalTime)
	SetProcessProgress("",0)
	
	RemoveProperty("", "LevelUpProto")
	GetPosition("", "FinalPos")
	local xfin2, yfin2, zfin2 = PositionGetVector("")
	local xfin, yfin, zfin = PositionGetVector("FinalPos")

	local ProgressAdd = 0
	local LevelUp = BuildingGetLevel("")+1
	local BuildType = BuildingGetType("")
	if BuildType ~= 2 and LevelUp > 3 then
		LevelUp = 3
	end
	local type, level, nenner, gebBez = bld_BauStuff(BuildType,LevelUp,"")
	gebBez = gebBez + 1
	nenner = 4
	if type~="" then
		local x = GfxAttachObject("Geruest1","buildings/Baugerueste/"..type.."/"..level.."/"..gebBez..".nif")
		GfxSetPosition("Geruest1",xfin,yfin,zfin,true)
		SetProperty("", "CurrentGeruest", 1)
		gebBez = gebBez + 1
	end

	if not BuildingGetOwner("","Cheffe") then
		AddImpact("",391,3,-1)
	else
		AddImpact("",391,0,-1)
--		MeasureRun("","","BauZusatzMeasure",true)
	end

	if (H4x0r==0) then	
		Sleep(4)
	end
	
	local TimeToUpgrade = 0
	local tries = 0
	while(TimeToUpgrade < MaxTotalTime) do
		ProgressAdd = GetImpactValue("",391)
		
		if tries > 30 and ProgressAdd < 1 then
			ProgressAdd = 1
		end		
		TimeToUpgrade = TimeToUpgrade + ProgressAdd
		
		if type~="" then
			if TimeToUpgrade >= ((MaxTotalTime / nenner ) * 1) and TimeToUpgrade < ((MaxTotalTime / nenner ) * 2) and GetProperty("", "CurrentGeruest") ~= 2 then
				GfxDetachObject("Geruest1")
				GfxAttachObject("Geruest2","buildings/Baugerueste/"..type.."/"..level.."/"..gebBez..".nif")
				GfxSetPosition("Geruest2",xfin,yfin,zfin,true)
				SetProperty("", "CurrentGeruest", 2)
				gebBez = gebBez + 1
			elseif TimeToUpgrade >= ((MaxTotalTime / nenner ) * 2) and TimeToUpgrade < ((MaxTotalTime / nenner ) * 3) and GetProperty("", "CurrentGeruest") ~= 3 then
				GfxDetachObject("Geruest2")
				GfxAttachObject("Geruest3","buildings/Baugerueste/"..type.."/"..level.."/"..gebBez..".nif")
				GfxSetPosition("Geruest3",xfin,yfin,zfin,true)
				SetProperty("", "CurrentGeruest", 3)
			end
			
			if nenner == 6 then
				gebBez = gebBez + 1
				if TimeToUpgrade >= ((MaxTotalTime / nenner ) * 3) and GetProperty("", "CurrentGeruest") ~= 4 then
					GfxDetachObject("Geruest3")
					GfxAttachObject("Geruest4","buildings/Baugerueste/"..type.."/"..level.."/"..gebBez..".nif")
					GfxSetPosition("Geruest4",xfin,yfin,zfin,true)
					SetProperty("", "CurrentGeruest", 4)
				end
			end
		end

		Sleep(1)
		SetProcessProgress("",TimeToUpgrade)
		tries = tries + 1
	end

	ShowBuildingFlags("", false)
	BuildingInternalLevelUp("", Proto)
	ShowBuildingFlags("", true)
	
	if AliasExists("Geruest4") then
		GfxDetachObject("Geruest4")
	elseif AliasExists("Geruest3") then
		GfxDetachObject("Geruest3")
	end	
	
	BuildingGetOwner("", "Builder")	
	feedback_MessageWorkshop("",
		"@L_BUILDING_LEVELUP_HEAD_+0",
		"@L_BUILDING_LEVELUP_BODY_+0", GetID(""))
	
	if MovingBuilding then
		SetState("",STATE_MOVING_BUILDING, true)
	end		
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	ResetProcessProgress("")
	Detach3DSound("")
	RemoveImpact("","LevelingUp",1,-1)
	RemoveImpact("",391)
end

