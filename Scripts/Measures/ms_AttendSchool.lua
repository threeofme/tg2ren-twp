
-- -----------------------
-- Run
-- -----------------------
function Run()

	if not GetSettlement("", "MyCity") then
		return
	end

	local FameLvl = chr_DynastyGetFameLevel("") + 1
	local ImpFameLvl = chr_DynastyGetImperialFameLevel("") + 1
	local Schoolmoney
	local School1 = GL_SCHOOLMONEY
	local School2 = GL_SCHOOLMONEY*(2+FameLvl)
	local School3 = GL_SCHOOLMONEY*(10+ImpFameLvl)
	local BuildingType		
	local choice

	if IsStateDriven() then
		--random choice
		choice = Rand(3) + 1
		if (choice==1) then
			if not FindNearestBuilding("", -1, GL_BUILDING_TYPE_WEDDINGCHAPEL, -1, false, "DestBuilding1") then
			--if not CityGetRandomBuilding("MyCity", -1, GL_BUILDING_TYPE_WEDDINGCHAPEL, -1, -1, FILTER_IGNORE, "DestBuilding1") then
				StopMeasure()
			end
		elseif (choice==2) then
			if (gameplayformulas_CheckPublicBuilding("MyCity", GL_BUILDING_TYPE_BANK)[1]>0) then
				if not CityGetRandomBuilding("MyCity", -1, GL_BUILDING_TYPE_BANK, -1, -1, FILTER_IGNORE, "DestBuilding2") then
					StopMeasure()
				end
			else
				StopMeasure()
			end
		elseif (choice==3) then
			if not CityGetRandomBuilding("MyCity", -1, GL_BUILDING_TYPE_TOWNHALL, -1, -1, FILTER_IGNORE, "DestBuilding3") then
				StopMeasure()
			end
		else
			StopMeasure()
		end		
	else
		-- GetLocalPlayerDynasty("Player")
		local BossID = dyn_GetValidMember("dynasty")
		GetAliasByID(BossID, "boss")
		
		local button1 = "@B[1,@L_ATTEND_SCHOOL_NEW_OPTION1_+0]"
		local button2 = "@B[2,@L_ATTEND_SCHOOL_NEW_OPTION2_+0]"
		local button3 = "@B[3,@L_ATTEND_SCHOOL_NEW_OPTION3_+0]"
		
		if not FindNearestBuilding("", -1, GL_BUILDING_TYPE_WEDDINGCHAPEL, -1, false, "DestBuilding1") then
		--if not CityGetRandomBuilding("MyCity", -1, GL_BUILDING_TYPE_WEDDINGCHAPEL, -1, -1, FILTER_IGNORE, "DestBuilding1") then
			button1 = ""
		end
		
		if (gameplayformulas_CheckPublicBuilding("MyCity", GL_BUILDING_TYPE_BANK)[1]>0) then
			if not CityGetRandomBuilding("MyCity", -1, GL_BUILDING_TYPE_BANK, -1, -1, FILTER_IGNORE, "DestBuilding2") then
				button2 = ""
			end
		else
			button2 = ""
		end
		
		if GetNobilityTitle("") < 5 or GetOutdoorLocator("MapExit1",1,"DestPos") == 0 then
			button3 = ""
		end
		
		choice = MsgBox("boss", "", "@P"..
						button1..
						button2..
						button3..
						"@B[0,@L_REPLACEMENTS_BUTTONS_CANCEL_+0]",
					"@L_ATTEND_SCHOOL_NEW_HEAD_+0",
					"@L_ATTEND_SCHOOL_NEW_BODY_+0",
					GetID(""),School1,School2,School3)
	end
				

	if (choice==1) then
		Schoolmoney = School1
	elseif (choice==2) then
		Schoolmoney = School2
	elseif (choice==3) then
		Schoolmoney = School3
	else
		StopMeasure()
	end
	
	-------------------------

	if choice < 3 or IsStateDriven() then
		GetLocatorByName("DestBuilding"..choice, "Entry1", "DestPos") 
	end -- else DestPos is mapexit!
	
	if not HasProperty("","SchoolPayed") then	
		if not f_SpendMoney("Dynasty", Schoolmoney, "CostEducation") then
			MsgQuick("", "@L_FAMILY_149_ATTENDSCHOOL_FAILURES_+0", GetID(""), Schoolmoney)
			return
		end
		SetProperty("","SchoolPayed",1)
	end
	
	local Time = GL_SCHOOLTIME
	SetData("MaxTime",Time)	
	local SchoolStart = math.floor(0+GetGametime())
	SetData("StartTime",SchoolStart)
	if HasProperty("","Time_done_school") then
		local TimeLeft = 0+GetProperty("","Time_done_school")
		Time = 0+Time - TimeLeft
	end
	SetMeasureRepeat(Time)
	StartGameTimer(Time)

	if not f_MoveTo("","DestPos",GL_MOVESPEED_RUN, 100) then
		StopMeasure()
	end
	
	if not FindNearestBuilding("", GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_DUELPLACE, -1, false, "InvisContainer") then
		StopMeasure()
	end
	
	SimBeamMeUp("","InvisContainer",false)
	SetInvisible("", true)
	AddImpact("", "Hidden", 1 , -1)
	
	
	-- wait till school is finished
	while not CheckGameTimerEnd() do
		Sleep(Rand(10)+2)
	end		
	
	-- school is finished, get rewards and prepare the certificate
	RemoveProperty("","Time_done_school")
	RemoveProperty("","SchoolPayed")
	SetData("Finished",1)
	
	GetSettlement("", "Settlement")
	
	local textLabel
	local bonus = 0
	
	if choice == 1 then
		-- "CHARISMA"      			-- 3
		-- "RHETORIC"				-- 7
		-- "EMPATHY"				-- 8
		-- "SECRET_KNOWLEDGE"		-- 10
		--IncrementSkillValue("",3,1)
		--IncrementSkillValue("",7,2)
		--IncrementSkillValue("",8,1)
		--IncrementSkillValue("",10,1)
		textLabel = "@L_FAMILY_ATTENDSCHOOL_CHURCH_END_CERTIFICATE_DOCUMENT_+0"
	elseif choice == 2 then
		-- "CRAFTSMANSHIP"  		-- 5
		-- "BARGAINING"    			-- 9
		-- "DEXTERITY"     			-- 2
		-- "CHARISMA"      			-- 3
		--if FameLvl > 10 then
		--	bonus = 2
		--elseif FameLvl > 6 then
		--	bonus = 1
		--end
		chr_GainXP("",250)
		--IncrementSkillValue("",5,2+bonus)
		--IncrementSkillValue("",9,2+bonus)
		--IncrementSkillValue("",2,1+bonus)
		--IncrementSkillValue("",3,1+bonus)
		textLabel = "@L_FAMILY_ATTENDSCHOOL_GUILD_END_CERTIFICATE_DOCUMENT_+0"
	else
		-- "CONSTITUTION"  			-- 1
		-- "FIGHTING"         		-- 4
		-- "SHADOW_ARTS"    		-- 6
		-- "CHARISMA"      			-- 3
		--if ImpFameLvl > 10 then
		--	bonus = 2
		--elseif ImpFameLvl > 6 then
		--	bonus = 1
		--end
		--IncrementSkillValue("",1,2+bonus)
		--IncrementSkillValue("",4,2+bonus)
		--IncrementSkillValue("",6,1+bonus)
		--IncrementSkillValue("",3,2+bonus)
		chr_GainXP("",500)
		textLabel = "@L_FAMILY_ATTENDSCHOOL_LORD_END_CERTIFICATE_DOCUMENT_+0"
	end
	
	if (choice==2) then
		if not HasProperty("", "Fame") then
			SetProperty("","Fame",FameLvl)
		else
			local fame = GetProperty("","Fame") + FameLvl
			SetProperty("","Fame",fame)
		end
		feedback_OverheadFame("", FameLvl)
	elseif (choice==3) then
		if not HasProperty("", "ImperialFame") then
			SetProperty("","ImperialFame",ImpFameLvl)
		else
			local fame = GetProperty("","ImperialFame") + ImpFameLvl
			SetProperty("","ImperialFame",fame)
		end
		feedback_OverheadImpFame("", ImpFameLvl)
	end
	
	MsgNewsNoWait("", "", "panel_nobility_title_deed", "intrigue", -1, "@L_FAMILY_149_ATTENDSCHOOL_END_CERTIFICATE_HEADER", textLabel, 
		GetID(""),
		GetID("Settlement"),
		Gametime2Total(GetGametime()))
	
	SetProperty("", "EduLevel", EDULEVEL_SCHOOL)
	
	SimBeamMeUp("","DestPos", false)
	SetInvisible("", false)
	RemoveImpact("","Hidden")
	xp_School("")
	PlayAnimation("","cheer_01")
	if GetHomeBuilding("","Home") then
		f_MoveToNoWait("","Home",GL_MOVESPEED_WALK)
	end
	
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	SetMeasureRepeat(0.001)
	if HasData("StartTime") and not HasData("Finished") then
		local SchoolEnd = math.floor(0+GetGametime())
		local SchoolStart = 0+GetData("StartTime")
		local Difference = 0+ SchoolEnd - SchoolStart
		local MaxTime = 0+GetData("MaxTime")
		if HasProperty("","Time_done_school") then
			Difference = Difference + GetProperty("","Time_done_school")
		end
		if Difference < MaxTime then
			SetProperty("","Time_done_school",Difference)
			
			feedback_MessageSchedule("",
				"@L_FAMILY_149_ATTENDSCHOOL_NOTFINISHED_HEAD",
				"@L_FAMILY_149_ATTENDSCHOOL_NOTFINISHED_BODY",GetID(""),MaxTime-Difference)
			
			-- get the sim back to the DestPos and let him go home
			SimBeamMeUp("","DestPos", false)
			SetInvisible("", false)
			RemoveImpact("","Hidden")
			if GetHomeBuilding("","Home") then
				f_MoveToNoWait("","Home",GL_MOVESPEED_WALK)
			end
		end
	end
end

function GetOSHData(MeasureID)
	--OSHSetMeasureCost("@L_INTERFACE_HEADER_+6",GL_SCHOOLMONEY)
end

