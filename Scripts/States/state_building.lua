-------------------------------------------------------------------------------
----
----	OVERVIEW "state_building"
----
----	With this state a building is built
----
-------------------------------------------------------------------------------

-- -----------------------
-- Init
-- -----------------------
function Init()

	SetStateImpact("no_enter")
	SetStateImpact("no_enter_camera")
	SetStateImpact("no_control")
	SetStateImpact("no_upgrades")
	SetStateImpact("upgrading")
	SetStateImpact("no_attackable")
	SetStateImpact("no_measure_start")
	--SetStateImpact("no_measure_attach")
end

--Include("Measures/ms_BauZusatz.lua")

function Run()

	if IsType("","Building") or IsType("","GuildResource")then
		state_building_BuildingLoop()
	elseif IsType("","Cart")then
		state_building_CartLoop() 
	end
end

-- -----------------------
-- ShipLoop
-- -----------------------
function CartLoop()
	
	--------------------------
	------ Preparations ------
	--------------------------
	SetInit("")
	SetState("",STATE_MONITORDAMAGE,true)
	
	local	Played = ScenarioGetTimePlayed()
	local 	H4x0r = GetSettingNumber("DEBUG", "DisableBuildtime", 0)
	if (Played==0 or H4x0r==1) then
		SetData("InstaBuild", 1)
		return
	end
	
	-- start buildsound
	Attach3DSound("", "measures/ms_BuildHouse_s_01.wav", 1.0)
	
	-- add particles and let them appear out of the ground
 	GfxAttachObject("ParticleDust", "particles/build.nif")
 	GfxSetPosition("ParticleDust", 0, -100, 0, false, true)
 	GfxMoveToPositionNoWait("ParticleDust", 0, 100, 0, 4, false)
 	
	-- Get the buildingtime (add a value to the prefpattern table)
	local CartPrefPattern = MoveGetPrefPattern("")
	local Buildtime = GetDatabaseValue("PathPrefPatternNames", CartPrefPattern , "buildtime")
	local MaxProgress = Gametime2Realtime(Buildtime)
	local Progress = 0
	local ProgressAdd = 0
	local CurrentHeight = 0
	local TimeToBuild = 0
	local Time = 0
	
	------------------------
	------ Buildphase ------
	------------------------
	SetProcessMaxProgress("",MaxProgress)	
	while Progress < MaxProgress do
		
		ProgressAdd = 1

		Progress = Progress + ProgressAdd 
		TimeToBuild = MaxProgress - Progress

		if TimeToBuild < 0 then
			TimeToBuild  = 0
		end

		Time = TimeToBuild / ProgressAdd
		
		Sleep(1)
		SetProcessProgress("",Progress)
	end
	
	--------------------
	------ Rework ------
	--------------------

	--GetDynasty("", "BuildingDynasty")
	if DynastyIsPlayer("") then
		PlaySound3D("", "fanfare/FanfarPositiveShort_s_01.ogg", 1.0)
	end
end

-- -----------------------
-- BuildingLoop
-- -----------------------
function BuildingLoop()
	--------------------------
	------ Preperations ------
	--------------------------
	SetInit("")
	ShowBuildingFlags("", false)
	SetState("",STATE_MONITORDAMAGE,true)
	
	local MovingBuilding = GetState("",STATE_MOVING_BUILDING)
	
	if MovingBuilding then
		SetState("",STATE_MOVING_BUILDING, false)
	end
	
	local	Played = ScenarioGetTimePlayed()
	local 	H4x0r = GetSettingNumber("DEBUG", "DisableBuildtime", 0)
	if (Played==0 or H4x0r==1) then
		SetData("InstaBuild", 1)
		return
	end

	-- Indicates a water building
	local IsWaterBuilding = 0
	
	-- Save the final building position
	GetPosition("", "FinalPos")
	px, py, pz = PositionGetVector("FinalPos")
	
	-- Get the proto of the building
	local Proto = BuildingGetProto("")

	GetLocatorByName("", "walledge4", "Pos")

	-- start buildsound
	Attach3DSound("", "measures/ms_BuildHouse_s_01.wav", 1.0)
 	
 	-- Get the building height which should work with the flag locator 	
 	local Height = 0
 	if GetLocatorByName("", "Flag1", "Top") then
 		local TopX = 0
 		local TopY = 0
 		local TopZ = 0
 		TopX, TopY, TopZ = PositionGetVector("Top") 		
 		local BotX = 0
 		local BotY = 0
 		local BotZ = 0
 		BotX, BotY, BotZ = PositionGetVector("Pos")
 		Height = TopY - BotY
 	end
 	-- Somehow it did not work -> get the height as usual
 	if Height == 0 then
 		Height = GfxGetHeight("")
 	end
 	local HeightFin = Height + 2000
	-- Set the building below the ground
	GfxSetPosition("", 0, -HeightFin, 0, false, true) 	

	-- Get the buildingtime
	local Buildtime = GetDatabaseValue("Buildings", Proto, "buildtime")
	-- local MaxProgress = Gametime2Realtime(GetDatabaseValue("ConstructionTime", BuildtimeID, "value"))
	local MaxProgress = Gametime2Realtime(Buildtime)
	local	Progress = 0
	local Workers = 0
	
	local ProgressAdd = 0
	local CurrentHeight = 0
	GetPosition("", "CurrentPos")
	local posx = 0
	local posy = 0
	local posz = 0
	posx, posy, posz = PositionGetVector("CurrentPos")
	local StartHeight = posy
	local TimeToBuild = 0
	local Time = 0
	
	local xfin2, yfin2, zfin2 = PositionGetVector("")
	local xfin, yfin, zfin = PositionGetVector("FinalPos")
	
	GetLocatorByName("", "Entry1", "Eingang")
	
	------------------------
	------ Buildphase ------
	------------------------
	local type, level, nenner, gebBez = bld_BauStuff(BuildingGetType(""),BuildingGetLevel(""),"")

	if type~="" then
		if GfxAttachObject("Geruest1","buildings/Baugerueste/"..type.."/"..level.."/"..gebBez..".nif") then
			GfxSetPosition("Geruest1",xfin,yfin,zfin,true)
			SetProperty("", "CurrentGeruest", 1)
			gebBez = gebBez + 1
		end
	end

	if not GetDynasty("", "BuildingDynasty") then
	    -- BuildingGetCity("","BuildingDynasty")
		AddImpact("",391,3,-1)
	else
		AddImpact("",391,0,-1)
		MeasureRun("BuildingDynasty","","BauZusatzMeasure",true)
	end
	
	SetProcessMaxProgress("",MaxProgress)
	
	local tries = 0
	
	while Progress < MaxProgress do
		
		ProgressAdd = GetImpactValue("",391)
		if tries > 30 and ProgressAdd < 1 then
			ProgressAdd = 1
		end		
		Progress = Progress + ProgressAdd 

		if type~="" then
			if Progress >= ((MaxProgress / nenner ) * 1) and Progress < ((MaxProgress / nenner ) * 2) and GetProperty("", "CurrentGeruest") ~= 2 then
				GfxDetachObject("Geruest1")
				GfxAttachObject("Geruest2","buildings/Baugerueste/"..type.."/"..level.."/"..gebBez..".nif")
				GfxSetPosition("Geruest2",xfin,yfin,zfin,true)
				SetProperty("", "CurrentGeruest", 2)
				gebBez = gebBez + 1
			elseif Progress >= ((MaxProgress / nenner ) * 2) and Progress < ((MaxProgress / nenner ) * 3) and GetProperty("", "CurrentGeruest") ~= 3 then
				GfxDetachObject("Geruest2")
				GfxAttachObject("Geruest3","buildings/Baugerueste/"..type.."/"..level.."/"..gebBez..".nif")
				GfxSetPosition("Geruest3",xfin,yfin,zfin,true)
				SetProperty("", "CurrentGeruest", 3)
				gebBez = gebBez + 1
			elseif Progress >= ((MaxProgress / nenner ) * 3) and Progress < ((MaxProgress / nenner ) * 4) and GetProperty("", "CurrentGeruest") ~= 4 then
				GfxDetachObject("Geruest3")
				GfxAttachObject("Geruest4","buildings/Baugerueste/"..type.."/"..level.."/"..gebBez..".nif")
				GfxSetPosition("Geruest4",xfin,yfin,zfin,true)
				SetProperty("", "CurrentGeruest", 4)
			end
				
			if nenner == 6 then
			  gebBez = gebBez + 1
			  if Progress >= ((MaxProgress / nenner ) * 4) and GetProperty("", "CurrentGeruest") ~= 5 then
					GfxDetachObject("Geruest4")
					GfxAttachObject("Geruest5","buildings/Baugerueste/"..type.."/"..level.."/"..gebBez..".nif")
					GfxSetPosition("Geruest5",xfin,yfin,zfin,true)
					SetProperty("", "CurrentGeruest", 5)
				end
			end
			


		end
		Sleep(1)
		SetProcessProgress("",Progress)
		tries = tries + 1
	end
				-- if Progress == ((MaxProgress / nenner ) * (nenner-1)) then		
	GfxSetPosition("", 0, HeightFin, 0, false)
			--end
	--------------------
	------ Rework ------
	--------------------
	if type~="" then
		-- GfxSetPosition("", 0, yfin2, 0, false, true)
		GfxSetPosition("", 0, yfin, 0, false, true)
		if AliasExists("Geruest5") then
			GfxDetachObject("Geruest5")
		elseif AliasExists("Geruest4") then
			GfxDetachObject("Geruest4")
		end
	end
	
	--GetDynasty("", "BuildingDynasty2")
	if DynastyIsPlayer("") then
		PlaySound3D("", "fanfare/FanfarPositiveShort_s_01.ogg", 1.0)
	end

	feedback_MessageWorkshop("",
		"@L_BUILDING_BUILD_HEAD_+0",
		"@L_BUILDING_BUILD_BODY_+0", GetID(""))
		
	if MovingBuilding then
		SetState("",STATE_MOVING_BUILDING, true)
	end		
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	ResetProcessProgress("")
	SetReady("")
	RemoveImpact("",391)
	RemoveProperty("","CurrentGeruest")
	if not HasData("InstaBuild") then
		BuildingGetOwner("", "Builder")
		Detach3DSound("")
	end
	if AliasExists("FinalPos") then
		GfxSetPositionTo("", "FinalPos")
	end
	ShowBuildingFlags("", true)
end
