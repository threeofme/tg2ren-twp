-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_AttendUniversity"
----
----	With this measure the player can send a child into university
----	
----	The script uses the sim-property "EduLevel" which can be:
----	EDULEVEL_NONE = 0
----	EDULEVEL_SCHOOL = 1
----	EDULEVEL_UNIVERSITY1 = 2
----	EDULEVEL_UNIVERSITY2 = 3
----	
----	The script uses the time-constants - GL_STUDYTIME_FIRST and
----	- GL_STUDYTIME_SECOND, which can be found in the db-table "gl_constants"
----	
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()

	if not GetSettlement("", "MyCity") then
		return
	end
	
	if not CityGetRandomBuilding("MyCity", -1, GL_BUILDING_TYPE_TOWNHALL, -1, -1, FILTER_IGNORE, "Destination") then
		return
	end

	local Schoolmoney = GL_UNIVERSITYMONEY
	local BonusUniversity1 = 2
	local BonusUniversity2 = 4	
	
	--first time on university
	if GetProperty("","EduLevel")==EDULEVEL_SCHOOL then
		if not HasProperty("","Uni1Payed") then
			if not f_SpendMoney("Dynasty", Schoolmoney, "CostEducation") then
				MsgQuick("", "@L_FAMILY_151_ATTENDUNIVERSITY_FAILURES_+0", GetID(""), Schoolmoney)
				StopMeasure()
			end
			SetProperty("","Uni1Payed",1)
		end
		--time to study in hours
		local Time = GL_STUDYTIME_FIRST
		SetData("MaxTime",Time)
		
		local UniStart = math.floor(0+GetGametime())
		SetData("StartTime",UniStart)
		if HasProperty("","Time_done") then
			local TimeLeft = 0+GetProperty("","Time_done")
			Time = 0+Time - TimeLeft
		end
		SetMeasureRepeat(Time)
		StartGameTimer(Time)
		
		if not f_MoveTo("","Destination",GL_MOVESPEED_RUN) then
			StopMeasure()
		end
		
		if not FindNearestBuilding("", GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_DUELPLACE, -1, false, "InvisContainer") then
			StopMeasure()
		end
	
		SimBeamMeUp("","InvisContainer",false)
		SetInvisible("", true)
		AddImpact("", "Hidden", 1 , -1)
		
		while not CheckGameTimerEnd() do
			Sleep(Rand(10)+2)
		end		
		
		SetProperty("","EduLevel",EDULEVEL_UNIVERSITY1)
		
		-- Preparations for the certificate
		GetSettlement("", "Settlement")
		
		-- Certificate
		MsgNewsNoWait("", "", "panel_nobility_title_deed", "intrigue", -1, "", "@L_FAMILY_151_ATTENDUNIVERSITY_1ST_END_CERTIFICATE_DOCUMENT",
			GetID(""),
			GetID("Settlement"),
			Gametime2Total(GetGametime()))			
		
		RemoveProperty("","Time_done")
		RemoveProperty("","Uni1Payed")
		ms_attenduniversity_AddRandomBonusSkills(BonusUniversity1)
		SetData("Finished",1)
		SimBeamMeUp("","Destination", false)
		SetInvisible("", false)
		RemoveImpact("","Hidden")
		xp_University("")
		f_ExitCurrentBuilding("")
		PlayAnimation("","cheer_01")
	
	--doctor			
	elseif GetProperty("","EduLevel")==EDULEVEL_UNIVERSITY1 then
		if not HasProperty("","Uni2Payed") then
			if not f_SpendMoney("Dynasty", Schoolmoney, "CostEducation") then
				MsgQuick("", "@L_FAMILY_151_ATTENDUNIVERSITY_FAILURES_+1", GetID(""), Schoolmoney)
				StopMeasure()
			end
			SetProperty("","Uni2Payed",1)
		end
		--time to study in hours
		local Time = GL_STUDYTIME_SECOND
		SetData("MaxTime",Time)
		local UniStart = math.floor(0+GetGametime())
		SetData("StartTime",UniStart)
		if HasProperty("","Time_done") then
			local TimeLeft = 0+GetProperty("","Time_done")
			Time = 0+Time - TimeLeft
		end
		SetMeasureRepeat(Time)
		StartGameTimer(Time)
		if not f_MoveTo("","Destination",GL_MOVESPEED_RUN) then
			StopMeasure()
		end
		
		if not FindNearestBuilding("", GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_DUELPLACE, -1, false, "InvisContainer") then
			StopMeasure()
		end
	
		SimBeamMeUp("","InvisContainer",false)
		SetInvisible("", true)
		AddImpact("", "Hidden", 1 , -1)
		
		while not CheckGameTimerEnd() do
			Sleep(Rand(10)+2)
		end		
		
		SetProperty("","EduLevel",EDULEVEL_UNIVERSITY2)
		SetProperty("","IsADoctor",1)
		
		-- Preparations for the certificate
		GetSettlement("", "Settlement")
		
		-- Certificate
		MsgNewsNoWait("", "", "panel_nobility_title_deed", "intrigue", -1, "@L_FAMILY_151_ATTENDUNIVERSITY_2ND_END_CERTIFICATE_HEADER", "@L_FAMILY_151_ATTENDUNIVERSITY_2ND_END_CERTIFICATE_DOCUMENT",
			GetID(""),
			GetID("Settlement"),
			Gametime2Total(GetGametime()))
		
		ms_attenduniversity_AddRandomBonusSkills(BonusUniversity2)
		SetNobilityTitle("", NOBILITY_DOCTOR)
		SetData("Finished",1)
		RemoveProperty("","Time_done")
		RemoveProperty("","Uni2Payed")
		xp_Doctor("")
		SimBeamMeUp("","Destination", false)
		SetInvisible("", false)
		RemoveImpact("","Hidden")	
		f_ExitCurrentBuilding("")
		PlayAnimation("","cheer_02")
	end
end

-- -----------------------
-- AddRandomBonusSkills
-- -----------------------
function AddRandomBonusSkills(Count)
	local i
	for i=1,Count do
		IncrementSkillValue("", Rand(10)+1, 1)
	end
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	SetMeasureRepeat(0.001)
	if HasData("StartTime") and not HasData("Finished") then
		local UniEnd = math.floor(0+GetGametime())
		local UniStart = 0+GetData("StartTime")
		local Difference = 0+ UniEnd - UniStart
		local MaxTime = 0+GetData("MaxTime")
		if HasProperty("","Time_done") then
			Difference = Difference + GetProperty("","Time_done")
		end
		if Difference < MaxTime then
			SetProperty("","Time_done",Difference)
			
			feedback_MessageSchedule("",
				"@L_FAMILY_151_ATTENDUNIVERSITY_2ND_NOTFINISHED_HEAD",
				"@L_FAMILY_151_ATTENDUNIVERSITY_2ND_NOTFINISHED_BODY",GetID(""),MaxTime-Difference)
		end
	end
		SetInvisible("", false)
		RemoveImpact("","Hidden")
end

function GetOSHData(MeasureID)
	OSHSetMeasureCost("@L_INTERFACE_HEADER_+6",GL_UNIVERSITYMONEY)
end


