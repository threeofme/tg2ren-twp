-------------------------------------------------------------------------------
----
----	OVERVIEW "behavior_childness.lua"
----
----	Behavior of a child from 0 to 4 years of age.
----	The child cannot be controlled by the player and will stay
----	inside the residence playing.
----
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()
	
	if not GetSettlement("", "City") then
		GetNearestSettlement("", "City")
	end	

	-- Check if the sim is old enough for the school
	if SimGetAge("") > (GL_AGE_FOR_SCHOOL - 1) then
	
		local Money = GL_SCHOOLMONEY
		feedback_MessageSchedule("", "@L_FAMILY_149_ATTENDSCHOOL_INTRO_HEAD", "@L_FAMILY_149_ATTENDSCHOOL_INTRO_BODY", GetID(""), Money)
		SimSetBehavior("", "Schooldays")
		return
		
	end
	
	MeasureSetNotRestartable()

	-- Check if the sim is at the residence. If not let him move to.
	if not AliasExists("Residence") then
		if SimGetMother("","MyMother")==false or GetHomeBuilding("MyMother", "Residence")==false then
			if SimGetFather("","MyFather")==false or GetHomeBuilding("MyFather", "Residence")==false then
				GetHomeBuilding("", "Residence")
			end
		end
	end	
	
	if not AliasExists("Residence") then
		Sleep(100)
		return
	end
	
	local BuildType = BuildingGetType("Residence")
	if BuildType == 2 or BuildType == 1  then
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
	
	Sleep(10+Rand(10))
	
	--idle behaviours
	local Action = Rand(4)
	if BuildingGetType("Residence")== 2 then
		if Action == 0 then	
			if GetFreeLocatorByName("Residence", "Play",1,3, "PlayPos") then
				if f_BeginUseLocator("","PlayPos",GL_STANCE_STAND,true) then
					PlayAnimation("","child_play_02_in")
					LoopAnimation("","child_play_02_loop",10)
					PlayAnimation("","child_play_02_out")
					f_EndUseLocator("","PlayPos",GL_STANCE_STAND)
					Sleep(5)
				end
			end
		elseif Action == 1 then	
			if GetLocatorByName("Residence", "Apples", "PlayPos") then
				if f_BeginUseLocator("","PlayPos",GL_STANCE_STAND,true) then
					if Rand(100)>50 then
						PlayAnimation("","manipulate_middle_low_r")
						PlayAnimation("","eat_standing")
					else
						PlayAnimation("","cogitate")
					end
					Sleep(5)
				end
			end
		elseif Action == 2 then
			if GetFreeLocatorByName("Residence", "ChildStroll",1,1, "PlayPos") then
				if f_MoveTo("","PlayPos") then
					Sleep(3+Rand(4))
				end
			end
			if GetFreeLocatorByName("Residence", "ChildStroll",2,2, "PlayPos") then
				if f_MoveTo("","PlayPos") then
					Sleep(3+Rand(2))
				end
			end
			if GetFreeLocatorByName("Residence", "ChildStroll",3,3, "PlayPos") then
				if f_MoveTo("","PlayPos") then
					Sleep(1)
				end
			end
			if GetFreeLocatorByName("Residence", "ChildStroll",4,4, "PlayPos") then
				if f_MoveTo("","PlayPos") then
					Sleep(1+Rand(4))
				end
			end
		else
			if GetLocatorByName("Residence", "BearRug", "PlayPos") then
				if f_BeginUseLocator("","PlayPos",GL_STANCE_SITGROUND,true) then
					Sleep(Rand(20)+12)
					f_EndUseLocator("","PlayPos",GL_STANCE_STAND)
				end
			end
		end
	
		Sleep(5)
	else
		local Chance = Rand(3)
		if Chance == 0 then
			Sleep(5)
			PlayAnimation("","child_play_02_in")
			LoopAnimation("","child_play_02_loop",10)
			PlayAnimation("","child_play_02_out")
			Sleep(5)
			return
		elseif Chance == 1 then
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
				local TargetCount = 4
		
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
				chr_ModifyFavor("Child","",5)
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
			return
		end
	end	
end

function BlockMe()
	SetData("Blocked",0)
	while GetData("Blocked")~=1 do
		Sleep(0.76)
	end
end
