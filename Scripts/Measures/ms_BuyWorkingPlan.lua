-- -----------------------
-- Run
-- -----------------------
function Run()

	if not GetInsideBuilding("", "Guildhouse") then
		StopMeasure()
	end

	BuildingGetCity("Guildhouse", "my_settlement")
	if (gameplayformulas_CheckPublicBuilding("my_settlement", GL_BUILDING_TYPE_BANK)[1]==0) then
		MsgQuick("", "@L_MEASURE_CONTRACTGUILDHOUSE_TASK_FAILURE_+1", GetID("my_settlement"))
		StopMeasure()
	end

	local alderman = false
	local guildmaster = false
	if chr_GetAlderman()==GetID("") then
		alderman = true
	elseif chr_CheckGuildMaster("","Guildhouse") then
		guildmaster = true
	end

	local Elder
	local Plan
	local Object
	local ItemName1
	local ItemCount1
	local ItemLabel1
	local ItemName2
	local ItemCount2
	local ItemLabel2
	local ItemName3
	local ItemCount3
	local ItemLabel3
	if SimGetClass("")==1 then
		Elder = "Patron"
		Plan = "WorkingPlanPatron1"
		Object = "BarrelBrewerBeer"
		ItemName1 = "Honey"
		ItemCount1 = 1
		ItemName2 = "Wheat"
		ItemCount2 = 1
		ItemName3 = "SmallBeer"
		ItemCount3 = 1
	elseif SimGetClass("")==2 then
		Elder = "Artisan"
		Plan = "WorkingPlanArtisan1"
		Object = "ChurchBell"
		ItemName1 = "iron"
		ItemCount1 = 1
		ItemName2 = "silver"
		ItemCount2 = 1
		ItemName3 = "Tool"
		ItemCount3 = 1
	elseif SimGetClass("")==3 then
		Elder = "Scholar"
		Plan = "WorkingPlanScholar1"
		Object = "Almanac"
		ItemName1 = "Pinewood"
		ItemCount1 = 1
		ItemName2 = "Oakwood"
		ItemCount2 = 1
		ItemName3 = "Leather"
		ItemCount3 = 1
	elseif SimGetClass("")==4 then
		Elder = "Chiseler"
		Plan = "WorkingPlanChiseler1"
		Object = "PoisonDagger"
		ItemName1 = "Silver"
		ItemCount1 = 1
		ItemName2 = "Tool"
		ItemCount2 = 1
		ItemName3 = "Dagger"
		ItemCount3 = 1
	end

	local npc = GetProperty("Guildhouse", Elder.."Elder")
	if npc==nil then
		guildhouse_CheckGuildElders()
		StopMeasure()
	end
	GetAliasByID(npc, "GuildClerk")

	local choice
	local PlanCount = 1
	local PlanLabel = ItemGetLabel(Plan, true)
	local ObjectCount = 1
	local ObjectLabel = ItemGetLabel(Object, true)

	local money
	if alderman==true then
		money = 75
	elseif guildmaster==true then
		money = 150
	else
		money = 250
	end

	if ItemCount1 > 1 then
		ItemLabel1 = ItemGetLabel(ItemName1, false)
	else
		ItemLabel1 = ItemGetLabel(ItemName1, true)
	end
	if ItemCount2 > 1 then
		ItemLabel2 = ItemGetLabel(ItemName2, false)
	else
		ItemLabel2 = ItemGetLabel(ItemName2, true)
	end
	if ItemCount3 > 1 then
		ItemLabel3 = ItemGetLabel(ItemName3, false)
	else
		ItemLabel3 = ItemGetLabel(ItemName3, true)
	end

	if GetRemainingInventorySpace("",Plan) < 1 then
		MsgQuick("", "@L_MEASURE_BUYWORKINGPLAN_FAILURE_+1", GetID(""), PlanLabel)
		StopMeasure()
	end

	--get the locators
	if not GetLocatorByName("Guildhouse",Elder.."Owner","OwnerPos") then
		StopMeasure()
	end
	if not GetLocatorByName("Guildhouse",Elder.."Elder","ClerkPos") then
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
	Sleep(2)
	
	if IsStateDriven() then
		PlayAnimationNoWait("GuildClerk","talk")
		MsgSay("GuildClerk","@L_GUILDHOUSE_MISSIONS_ITEMS_PRODUCE_TEXT_+0",
							PlanLabel, ObjectLabel, ItemCount1, ItemLabel1, ItemCount2, ItemLabel2, ItemCount3, ItemLabel3, money)
		choice = 0
		StopAnimation("GuildClerk")
		Sleep(1)
		PlayAnimationNoWait("","talk")
		MsgSay("","@L_GUILDHOUSE_MISSIONS_ITEMS_PRODUCE_OPT_+0")
		StopAnimation("")
	else
		PlayAnimationNoWait("GuildClerk","talk")
		choice = MsgSayInteraction("","GuildClerk","",
							"@B[0,@L_GUILDHOUSE_MISSIONS_ITEMS_PRODUCE_OPT_+0]"..
							"@B[1,@L_GUILDHOUSE_MISSIONS_ITEMS_PRODUCE_OPT_+1]",
							"@L_GUILDHOUSE_MISSIONS_ITEMS_PRODUCE_HEAD_+0",
							"@L_GUILDHOUSE_MISSIONS_ITEMS_PRODUCE_TEXT_+0",
							PlanLabel, ObjectLabel, ItemCount1, ItemLabel1, ItemCount2, ItemLabel2, ItemCount3, ItemLabel3, money)
		StopAnimation("GuildClerk")
	end

	if (choice==0) then

		if GetRemainingInventorySpace("",Plan) < 1 then
			MsgQuick("", "@L_MEASURE_BUYWORKINGPLAN_FAILURE_+1", GetID(""), PlanLabel)
			StopMeasure()
		elseif not f_SpendMoney("", money, "WorkingPlan", false) then
			MsgQuick("", "@L_MEASURE_BUYWORKINGPLAN_FAILURE_+0", GetID(""), PlanLabel)
			StopMeasure()
		end

		local time1
		local time2
		time1 = PlayAnimationNoWait("GuildClerk", "use_object_standing")
		time2 = PlayAnimationNoWait("","cogitate")
		Sleep(1)
		PlaySound3D("GuildClerk","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
		CarryObject("GuildClerk","Handheld_Device/Anim_openscroll.nif",false)
		
		Sleep(1)
		CarryObject("GuildClerk","",false)
		CarryObject("","Handheld_Device/Anim_openscroll.nif",false)
		time2 = PlayAnimationNoWait("","fetch_store_obj_R")
		Sleep(1)	
		StopAnimation("GuildClerk")
		PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
		CarryObject("","",false)

		AddItems("",Plan,1)
	
	end
end

function CleanUp()
	EndCutscene("")
	DestroyCutscene("cutscene")
	MoveSetActivity("")
	if AliasExists("GuildClerk") then
		MoveSetActivity("GuildClerk")
	end
	SetState("", STATE_LOCKED, false)
	ReleaseAvoidanceGroup("")
end
