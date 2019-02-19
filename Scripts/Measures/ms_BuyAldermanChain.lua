-- -----------------------
-- Run
-- -----------------------
function Run()
	GetInsideBuilding("", "Guildhouse")
	BuildingGetCity("Guildhouse", "my_settlement")
	if (gameplayformulas_CheckPublicBuilding("my_settlement", GL_BUILDING_TYPE_BANK)[1]==0) then
		MsgQuick("", "@L_MEASURE_CONTRACTGUILDHOUSE_TASK_FAILURE_+1", GetID("my_settlement"))
		StopMeasure()
	end

	BuildingFindSimByProperty("Guildhouse", "BUILDING_NPC", 12, "GuildClerk")			

	local alderman = false
	local guildmaster = false
	if chr_GetAlderman()==GetID("") then
		alderman = true
	elseif chr_CheckGuildMaster("","Guildhouse") then
		guildmaster = true
	end

	if GetRemainingInventorySpace("","AldermanChain") < 1 then
		MsgQuick("", "@L_MEASURE_BUYALDERMANCHAIN_FAILURE_+1", GetID(""))
		StopMeasure()
	end
	
	--get the locators
	if not GetLocatorByName("Guildhouse","OwnerPos","OwnerPos") then
		StopMeasure()
	end
	if not GetLocatorByName("Guildhouse","GuildClerkPos","ClerkPos") then
		StopMeasure()
	end
	
	--if locator is blocked
	while true do
		if LocatorStatus("Guildhouse","OwnerPos",true)==1 then
			break
		end
		Sleep(2)
	end

	if not f_BeginUseLocator("","OwnerPos",GL_STANCE_STAND,true) then
		StopMeasure()
	end
	if not f_BeginUseLocator("GuildClerk","ClerkPos",GL_STANCE_STAND,true) then
		StopMeasure()
	end
	Sleep(1)

	AlignTo("", "GuildClerk")
	AlignTo("GuildClerk", "")

	SetAvoidanceGroup("", "GuildClerk")
	MoveSetActivity("", "converse")
	MoveSetActivity("GuildClerk", "converse")
	CreateCutscene("default","cutscene")
	CutsceneAddSim("cutscene","")
	CutsceneAddSim("cutscene","GuildClerk")
	CutsceneCameraCreate("cutscene","")
	camera_CutsceneBothLock("cutscene", "GuildClerk")

	Sleep(1)

	local Title = GetNobilityTitle("")

	local Cost
	if alderman==true then
		Cost = (Title * Title) * 15
	elseif guildmaster==true then
		Cost = (Title * Title) * 30
	else
		Cost = (Title * Title) * 50
	end

	local greeting
	local gradelabel
	if alderman==true then
		greeting = "@L_GUILDHOUSE_GREETINGS_+2"
		gradelabel = "@L_CHECKALDERMAN_ALDERMAN"
	elseif guildmaster==true then
		greeting = "@L_GUILDHOUSE_GREETINGS_+1"
		gradelabel = "@L_GUILDHOUSE_MASTERLIST_GUILDMASTER"
	else
		greeting = "@L_GUILDHOUSE_GREETINGS_+0"
		gradelabel = ""
	end
	if SimGetGender("")==GL_GENDER_MALE then
		gradelabel = gradelabel.."_MALE_+0"
	else
		gradelabel = gradelabel.."_FEMALE_+0"
	end

	PlayAnimationNoWait("GuildClerk","talk")
	MsgSay("GuildClerk", greeting, GetID(""), gradelabel)
	StopAnimation("GuildClerk")
	Sleep(1)

	local choice
	
	if IsStateDriven() then
		PlayAnimationNoWait("GuildClerk","talk")
		MsgSay("GuildClerk","@L_MEASURE_BUYALDERMANCHAIN_QUESTION_+0","", Cost)
		StopAnimation("GuildClerk")
		Sleep(2)
		PlayAnimationNoWait("","talk")
		MsgSay("","@L_MEASURE_BUYALDERMANCHAIN_AI_OPTION_+0")
		StopAnimation("")
		choice = 0
	else
		PlayAnimationNoWait("GuildClerk","talk")
		choice = MsgSayInteraction("","GuildClerk","",
							"@B[0,@L_MEASURE_BUYALDERMANCHAIN_OPTION_+0]"..
							"@B[1,@L_MEASURE_BUYALDERMANCHAIN_OPTION_+1]",
							"@L_MEASURE_BUYALDERMANCHAIN_HEAD_+0",
							"@L_MEASURE_BUYALDERMANCHAIN_QUESTION_+0",
							GetID(""), Cost)
		StopAnimation("GuildClerk")
	end

	if (choice==0) then

		if GetRemainingInventorySpace("","AldermanChain") < 1 then
			MsgQuick("", "@L_MEASURE_BUYALDERMANCHAIN_FAILURE_+1", GetID(""))
			StopMeasure()
		elseif not f_SpendMoney("", Cost, "AldermanChain", false) then
			MsgQuick("", "@L_MEASURE_BUYALDERMANCHAIN_FAILURE_+0", GetID(""))
			StopMeasure()
		end

		local time1
		local time2
		time1 = PlayAnimationNoWait("GuildClerk", "use_object_standing")
		time2 = PlayAnimationNoWait("","cogitate")
		Sleep(1)
		PlaySound3D("GuildClerk","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
		CarryObject("GuildClerk","Handheld_Device/ANIM_Smallsack.nif",false)
		
		Sleep(1)
		CarryObject("GuildClerk","",false)
		CarryObject("","Handheld_Device/ANIM_Smallsack.nif",false)
		time2 = PlayAnimationNoWait("","fetch_store_obj_R")
		Sleep(1)	
		StopAnimation("GuildClerk")
		PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
		CarryObject("","",false)	

		AddItems("","AldermanChain",1)
	
		if IsStateDriven() then
			MeasureRun("", nil, "UseAldermanChain", true)
		end
	end
end

function CleanUp()
	DestroyCutscene("cutscene")
	MoveSetActivity("")
	MoveSetActivity("GuildClerk")
	SetState("", STATE_LOCKED, false)
	ReleaseAvoidanceGroup("")
	EndCutscene("")
end
