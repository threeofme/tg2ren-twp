-------------------------------------------------------------------------------
----
----	OVERVIEW "behavior_schooldays.lua"
----
----	Behavior of a child from 4 to 8 years of age.
----	The child can be sent to school to raise its skills.
----	Since the child can not be directly controlled by the player
----	it must be sent back to the residence if it is not already there and not in school.
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
	if SimGetAge("") > (GL_AGE_FOR_APPRENTICESHIP - 1) then
	
		local Money = GL_APPRENTICESHIPMONEY
		feedback_MessageSchedule("", "@L_FAMILY_150_ATTENDAPPRENTICESHIP_INTRO_HEAD", "@L_FAMILY_150_ATTENDAPPRENTICESHIP_INTRO_BODY", GetID(""), Money)
		SimSetBehavior("", "Apprenticeship")
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
	
	Sleep(10+Rand(5))
	
	--idle behaviours
	local Hour = math.mod(GetGametime(), 24)	
	local Action = Rand(6)
	if BuildingGetType("Residence")== 2 then
		if Action == 0 then	
		if GetFreeLocatorByName("Residence", "Play",1,3, "PlayPos") then
			if f_BeginUseLocator("","PlayPos",GL_STANCE_STAND,true) then
				PlayAnimation("","child_play_02_in")
				LoopAnimation("","child_play_02_loop",10)
				PlayAnimation("","child_play_02_out")
				f_EndUseLocator("","PlayPos",GL_STANCE_STAND)
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
			end
		end
	elseif Action == 2 then
		if GetFreeLocatorByName("Residence", "ChildStroll",1,1, "PlayPos") then
			f_MoveTo("","PlayPos",GL_MOVESPEED_RUN,100)
		end
		if GetFreeLocatorByName("Residence", "ChildStroll",2,2, "PlayPos") then
			f_MoveTo("","PlayPos",GL_MOVESPEED_RUN,100)
		end
		if GetFreeLocatorByName("Residence", "ChildStroll",3,3, "PlayPos") then
			f_MoveTo("","PlayPos",GL_MOVESPEED_RUN,100)
		end
		if GetFreeLocatorByName("Residence", "ChildStroll",4,4, "PlayPos") then
			f_MoveTo("","PlayPos",GL_MOVESPEED_RUN,100)
		end
	elseif Action == 3 then
		if GetLocatorByName("Residence", "BearRug", "PlayPos") then
			if f_BeginUseLocator("","PlayPos",GL_STANCE_SITGROUND,true) then
				Sleep(Rand(20)+10)
				f_EndUseLocator("","PlayPos",GL_STANCE_STAND)
			end
		end
	elseif Hour < 8 or Hour > 20 then
		-- ab nach Hause
		if GetInsideBuildingID("")==GetID("Residence") then
			Sleep(10)
		else
			local BuildType = BuildingGetType("Residence")
			if BuildType == 2 or BuildType == 1  then
				f_MoveTo("", "Residence")
			else
				CityGetNearestBuilding("City", "", 1, 1, -1, -1, FILTER_IGNORE, "Home")
				f_MoveTo("", "Home")
				SetHomeBuilding("", "Home")
			end
		end
	elseif Action == 4 then
		f_ExitCurrentBuilding("")
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
		Sleep(4)
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
				GetFleePosition("","Market", 400,"MovePos")
				f_MoveTo("", "MovePos", nil, Rand(200)+200)
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
				chr_ModifyFavor("Child","",3)
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
