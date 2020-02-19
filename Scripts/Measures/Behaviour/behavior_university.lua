-------------------------------------------------------------------------------
----
----	OVERVIEW "behavior_university.lua"
----
----	Behavior of a child from 12 to 16 years of age.
----	The child can be sent to university to raise its skills.
----	Since the child can not be directly controlled by the player
----	it must be sent back to the residence if it is not already there
----	and not in the university.
----	
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()
	
	if not GetSettlement("", "City") then
		GetNearestSettlement("", "City")
	end	
	
	-- Check if the sim is at the residence. If not let him move to.
	if not AliasExists("Residence") then
		if SimGetMother("","MyMother")==false or GetHomeBuilding("MyMother", "Residence")==false then
			if SimGetFather("","MyFather")==false or GetHomeBuilding("MyFather", "Residence")==false then
				GetHomeBuilding("", "Residence")
			end
		end
	end
	
	MeasureSetNotRestartable()	
	
	if not AliasExists("Residence") then
		Sleep(100)
		return
	end

	if BuildingGetType("Residence") == 2 then
		if GetInsideBuilding("", "InsideBuilding") then
			if not GetID("Residence") == GetID("InsideBuilding") then
				f_MoveTo("", "Residence")
			end
		else
			f_MoveTo("", "Residence")
		end
	else
		CityGetNearestBuilding("City", "", -1, 1, -1, -1, FILTER_IGNORE, "NewHome")
		SetHomeBuilding("", "NewHome")
		CopyAlias("NewHome", "Residence")
	end
	
	-- Check if the sim is old enough for the grown up model
	local Age = SimGetAge("")
	if SimGetAge("") > GL_AGE_FOR_GROWNUP then
		
		-- The SimSetAge will internally set the grown-up model for the sim
		local Age = SimGetAge("")
		SimSetAge("", Age)
		
		-- Remove the child state so that the child can be controlled
		SetState("", STATE_CHILD, false)		
		
		
		SimResetBehavior("")
		return
		
	end
	
	--idle behaviours
	local Hour = math.mod(GetGametime(), 24)
	local Action = Rand(6)
	if Hour < 7 or Hour > 21 then
		-- ab nach Hause
		if GetInsideBuildingID("")==GetID("Residence") then
			Sleep(10)
		else
			f_MoveTo("", "Residence")
		end
	else
		if Action == 0 then	
			f_ExitCurrentBuilding("")
			idlelib_GoTownhall()
		elseif Action == 1 then	
			f_ExitCurrentBuilding("")
			idlelib_SitDown()
		elseif Action == 2 then
			f_ExitCurrentBuilding("")
			idlelib_CollectWater()
		elseif Action == 3 then
			f_ExitCurrentBuilding("")
			idlelib_BuySomethingAtTheMarket()
		elseif Action == 4 then
			if CityGetRandomBuilding("City", -1, GL_BUILDING_TYPE_LINGERPLACE, -1, -1, FILTER_IGNORE, "Market") then
				GetFleePosition("","Market",300,"MovePos")
				f_MoveTo("", "MovePos", nil, 200)
			end
			local ChildFilter = "__F((Object.GetObjectsByRadius(Sim) == 5000)AND NOT(Object.MinAge(16)))"
			local NumChilds = Find("", ChildFilter,"Child", -1)
			if NumChilds > 0 then
				if not ai_StartInteraction("", "Child", 1000, 150, "BlockMe") then
					return
				end
				AlignTo("","Child")
				AlignTo("Child","")
				Sleep(1)
				
				local TargetArray = {"Drumstick","Flute","cake","perfumebottle"}
				local TargetCount = 3
			
				PlayAnimationNoWait("","child_play_02_in")
				PlayAnimation("Child","child_play_02_in")
				CarryObject("","Handheld_Device/Anim_"..TargetArray[Rand(TargetCount)+1]..".nif",false)
				CarryObject("Child","Handheld_Device/Anim_"..TargetArray[Rand(TargetCount)+1]..".nif",false)
				LoopAnimation("","child_play_02_loop",0)
				LoopAnimation("Child","child_play_02_loop",0)
				CarryObject("","",false)
				CarryObject("Child","",false)
				PlayAnimationNoWait("","child_play_02_out")
				PlayAnimation("Child","child_play_02_out")
				chr_ModifyFavor("Child","",1)
				SetData("Blocked",1)
				return
			end
		else
			f_ExitCurrentBuilding("")
			idlelib_GoToRandomPosition()
			local season = GetSeason()
			if season == EN_SEASON_WINTER then
				local FightPartners = Find("", "__F((Object.GetObjectsByRadius(Sim)==2000)AND NOT(Object.HasDynasty()))","FightPartner", -1)
				if FightPartners>0 then
					idlelib_SnowballBattle("FightPartner")
					return
				end
			end
		end
	end
	Sleep(1)
	
end

function BlockMe()
	SetData("Blocked",0)
	while GetData("Blocked")~=1 do
		Sleep(0.76)
	end
end

function CleanUp()
	f_EndUseLocator("","PlayPos",GL_STANCE_STAND)
end

