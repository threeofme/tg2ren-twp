-------------------------------------------------------------------------------
----
----	OVERVIEW "state_repairing"
----
----	With this state a building is repaired
----
-------------------------------------------------------------------------------

-- -------------
-- Init
-- -------------
function Init()
	SetStateImpact("no_upgrades")
end

-- -------------
-- Run
-- -------------
function Run()

	local Proto = BuildingGetProto("")
	if Proto < 1 then
		return
	end

	
	local RepairPerSecond = 1
	
	Attach3DSound("", "measures/ms_BuildHouse_s_01.wav", 1.0)
	
	if IsType("", "Building") then
		RepairPerSecond = state_repairing_BuildingStart()
	end
	
	while GetHP("") < GetMaxHP("") do
		-- Modify the hitpoints by "RepairPerSecond" and suppress an overhead symbol
		ModifyHP("", RepairPerSecond, false)
		Sleep(1)
		if GetState("", STATE_FIGHTING) or GetState("", STATE_BURNING) or GetState("", STATE_DEAD) then
			break
		end
	end
	
	if IsType("", "Building") then
		state_repairing_BuildingEnd()
	end
		
	feedback_MessageWorkshop("", 
		"@L_BUILDING_RENOVATE_SUCCESS_HEAD_+0",
		"@L_BUILDING_RENOVATE_SUCCESS_BODY_+0", GetID(""))
end

-- -------------
-- BuildingStart
-- -------------
function BuildingStart()	

	-- Get the proto of the building
	local Proto = BuildingGetProto("")
	
	-- Get the offset for the scaffold
	local OffsetX = 0
	local OffsetZ = 0
	OffsetX, OffsetZ = bld_GetScaffoldOffsets(Proto)
	
	local TurnScaffold = 0
	if (Proto == 311) or (Proto == 312) or (Proto == 144) or (Proto == 174) or (Proto == 301) or (Proto == 390) or (Proto == 361) then
		TurnScaffold = 1
	end
	
	-- Get the id of the scaffoldmodel
	local scaffoldmodel = GetDatabaseValue("Buildings", Proto, "scaffoldmodel")
	if not scaffoldmodel or scaffoldmodel == "" or scaffoldmodel == 0 or scaffoldmodel == -1 then

		-- add particles and let them appear out of the ground
	 	GfxAttachObject("ParticleDust", "particles/build.nif")
	 	
	 	-- Get the base area of the building
	 	local BaseArea = GfxGetHeight("") 	
	 	local PartScale = BaseArea/300
		if PartScale > 6 then
			PartScale = 6
		end
	 	GfxScale("ParticleDust", PartScale)
	 	GfxSetPosition("ParticleDust", 0, -100, 0, false, true)
		GfxMoveToPositionNoWait("ParticleDust", 0, 100, 0, 4, false)

		SetData("ScaffoldLevel", -1)

	else
	
	 	-- Get the building height which should work with the flag locator 	
	 	local Height = 0
	 	if GetLocatorByName("", "Flag1", "Top") then
	 		TopX, TopY, TopZ = PositionGetVector("Top")
			GetLocatorByName("", "walledge4", "Pos")
	 		BotX, BotY, BotZ = PositionGetVector("Pos")
	 		Height = TopY - BotY
	 	end
	 	
		-- Init some values
	 	local ScaffoldHeight = GL_SCAFFOLDHEIGHT
		SetData("ScaffoldHeight", ScaffoldHeight)
	 	local ScaffoldMaxLevel = Height / ScaffoldHeight + 0.5
		local ScaffoldLevel = -1
	 	
		-- add particles and let them appear out of the ground
	 	GfxAttachObject("ParticleDust", "particles/build.nif")
	 	
	 	-- Get the base area of the building
	 	local BaseArea = GfxGetHeight("") 	
	 	local PartScale = BaseArea/300
		if PartScale > 6 then
			PartScale = 6
		end
	 	GfxScale("ParticleDust", PartScale)
	 	GfxSetPosition("ParticleDust", 0, -100, 0, false, true)
		GfxMoveToPositionNoWait("ParticleDust", 0, 100, 0, 4, false)
	 	
		if scaffoldmodel > 0 then
			while ScaffoldMaxLevel > 0.9 do			
				ScaffoldLevel = ScaffoldLevel + 1
				if GfxAttachObjectByID("level"..ScaffoldLevel, scaffoldmodel) then
					GfxSetPositionTo("level"..ScaffoldLevel, "Pos")
					if TurnScaffold == 1 then
						GfxSetRotation("level"..ScaffoldLevel, 0, 90, 0, false)
					end
					GfxSetPosition("level"..ScaffoldLevel, 0, ScaffoldHeight*ScaffoldLevel, 0, false, true)
					GfxSetPosition("level"..ScaffoldLevel, OffsetX, 0, OffsetZ, false, false)
				end
				Sleep(3)
	
				ScaffoldMaxLevel = ScaffoldMaxLevel - 1 
			end		
		end
		
		SetData("ScaffoldLevel", ScaffoldLevel)

	end
			
	local Repairstep = GetMaxHP("")*0.01
	return Repairstep
end

-- -----------
-- BuildingEnd
-- -----------
function BuildingEnd()
	
	-- get rid of the particle and all the scaffolds
	GfxMoveNoWait("ParticleDust", 0, -1, 0, 100)
	
	local ScaffoldLevel = GetData("ScaffoldLevel")
	
	if ScaffoldLevel<0 then
		Sleep(3)
	else
		local ScaffoldHeight = GetData("ScaffoldHeight")
		
		for i=0,ScaffoldLevel do
			if AliasExists("level"..i) then
				GfxMoveToPositionNoWait("level"..i, 0, -ScaffoldHeight*ScaffoldLevel - 50, 0, 3*ScaffoldLevel, false)
			end
		end
		
		Sleep(3*ScaffoldLevel)
	end
	
end

-- -------
-- CleanUp
-- -------
function CleanUp()
	Detach3DSound("")
	SetState("", STATE_REPAIRING, false)
end

