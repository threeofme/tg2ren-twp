-- -----------------------
-- Run
-- -----------------------
function Run()

-- Fajeth Mod
local MeasureID = GetCurrentMeasureID("")
local TimeOut = mdata_GetTimeOut(MeasureID)
-- Mod End

	if IsStateDriven() then
		if not f_MoveTo("", "Destination", GL_MOVESPEED_RUN) then
			StopMeasure()
		end
		if GetInsideBuilding("", "Guildhouse") then
			if not (GetID("Destination")==GetID("Guildhouse")) then
				StopMeasure()
			end
		else
			StopMeasure()
		end
	end

	GetInsideBuilding("", "Guildhouse")
	BuildingGetCity("Guildhouse", "my_settlement")
	if (gameplayformulas_CheckPublicBuilding("my_settlement", GL_BUILDING_TYPE_BANK)[1]==0) then
		MsgQuick("", "@L_MEASURE_CONTRACTGUILDHOUSE_TASK_FAILURE_+1", GetID("my_settlement"))
		StopMeasure()
	end

	local npc = GetProperty("Guildhouse", "PatronElder")
	if npc==nil then
		guildhouse_CheckGuildElders()
		StopMeasure()
	end
	GetAliasByID(npc, "GuildClerk")
	
	local alderman = false
	local guildmaster = false
	if chr_GetAlderman()==GetID("") then
		alderman = true
	elseif chr_CheckGuildMaster("","Guildhouse") then
		guildmaster = true
	else
	-- Fajeth Mod
		--StopMeasure()
	-- Mod end
	end
	
	local items = { 
			"Wheat", "WheatFlour", "Beef", "Fat", "Milch", "Honey", "Fruit", "Fungi", "Herring"
			}

	local	itemcount = 1
	while items[itemcount] do
		itemcount = itemcount + 1
	end

	local moneymod
	local money = {}
	local box
		-- Fajeth Mod
	if alderman==true then
		moneymod = 10
		box = 3
	elseif guildmaster==true then
		moneymod = 15
		box = 3
	else
		moneymod = 20
		local random = Rand(4) + 1
		if random==4 then
			box = 3
		elseif random < 2 then
			box = 1
		else
			box = 2
		end
	end

	local	ItemLabel = {}
	local ItemTexture
	local btn = ""
	local Rabatt = 1-GetSkillValue("", BARGAINING)*0.03
	for x = 1, itemcount-1 do
		ItemLabel[x] = "@L"..ItemGetLabel(items[x],true)
		money[x] = math.floor(ItemGetBasePrice(items[x]) * moneymod)*Rabatt
		ItemLabel[x-1+itemcount] = money[x]
		ItemTexture = "Hud/Items/Item_"..ItemGetName(items[x])..".tga"
		btn = btn.."@B[A"..x..",,%"..x.."l %"..x-1+itemcount.."t,"..ItemTexture.."]"
	end

	local Result
	if IsStateDriven() then
		Result = "A"..Rand(itemcount-1)
	else
		Result = InitData("@P"..btn,
				nil,
				"@L_MEASURE_BUYRAWMATERIAL_TEXT_+1",
				"",
				ItemLabel[1],ItemLabel[2],
				ItemLabel[3],ItemLabel[4],
				ItemLabel[5],ItemLabel[6],
				ItemLabel[7],ItemLabel[8],
				ItemLabel[9],ItemLabel[10],
				ItemLabel[11],ItemLabel[12],
				ItemLabel[13],ItemLabel[14],
				ItemLabel[15],ItemLabel[16],
				ItemLabel[17],ItemLabel[18],
				ItemLabel[19],ItemLabel[20]
				)
	end

	if Result == "C" then
		return
	end

	--check the item
	local ItemIndex
	if Result == "A0" then
		ItemIndex = 0
	elseif Result == "A1" then
		ItemIndex = 1
	elseif Result == "A2" then
		ItemIndex = 2
	elseif Result == "A3" then
		ItemIndex = 3
	elseif Result == "A4" then
		ItemIndex = 4
	elseif Result == "A5" then
		ItemIndex = 5
	elseif Result == "A6" then
		ItemIndex = 6
	elseif Result == "A7" then
		ItemIndex = 7
	elseif Result == "A8" then
		ItemIndex = 8
	elseif Result == "A9" then
		ItemIndex = 9
	else
		ItemIndex = 10
	end

	local Object = ItemGetName(items[ItemIndex]).."Box"..box
	local ObjectLabel = ItemGetLabel(items[ItemIndex].."Box"..box, true)

	if GetRemainingInventorySpace("",Object) < 1 then
		MsgQuick("", "@L_MEASURE_BUYRAWMATERIAL_FAILURE_+0", GetID(""), ObjectLabel)
		StopMeasure()
	elseif GetMoney("") < money[ItemIndex] then
		MsgQuick("", "@L_MEASURE_BUYRAWMATERIAL_FAILURE_+1", GetID(""), ObjectLabel)
		StopMeasure()
	end

	--get the locators
	if not GetLocatorByName("Guildhouse","PatronOwner","OwnerPos") then
		StopMeasure()
	end
	if not GetLocatorByName("Guildhouse","PatronElder","ClerkPos") then
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
	Sleep(1)

	local choice
	if IsStateDriven() then
		PlayAnimationNoWait("GuildClerk","talk")
		MsgSay("GuildClerk","@L_MEASURE_BUYRAWMATERIAL_TEXT_+0",
							ObjectLabel, money[ItemIndex])
		choice = 0
		StopAnimation("GuildClerk")
		Sleep(2)
		PlayAnimationNoWait("","talk")
		MsgSay("","@L_GUILDHOUSE_MISSIONS_ITEMS_PRODUCE_OPT_+0")
		StopAnimation("")
	else
		PlayAnimationNoWait("GuildClerk","talk")
		choice = MsgSayInteraction("","GuildClerk","",
							"@B[0,@L_GUILDHOUSE_MISSIONS_ITEMS_PRODUCE_OPT_+0]"..
							"@B[1,@L_GUILDHOUSE_MISSIONS_ITEMS_PRODUCE_OPT_+1]",
							"@L_MEASURE_BUYRAWMATERIAL_HEAD_+0",
							"@L_MEASURE_BUYRAWMATERIAL_TEXT_+0",
							ObjectLabel, money[ItemIndex])
		StopAnimation("GuildClerk")
	end

	if (choice==0) then

		if GetRemainingInventorySpace("",Object) < 1 then
			MsgQuick("", "@L_MEASURE_BUYRAWMATERIAL_FAILURE_+0", GetID(""), ObjectLabel)
			StopMeasure()
		elseif not f_SpendMoney("", money[ItemIndex], "BuyRawMaterial", false) then
			MsgQuick("", "@L_MEASURE_BUYRAWMATERIAL_FAILURE_+1", GetID(""), ObjectLabel)
			StopMeasure()
		end

		local time1
		local time2
		time1 = PlayAnimationNoWait("GuildClerk", "use_object_standing")
		time2 = PlayAnimationNoWait("","cogitate")
		Sleep(1)
		PlaySound3D("GuildClerk","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
		CarryObject("GuildClerk","Handheld_Device/Anim_Bag.nif",false)
		
		Sleep(1)
		CarryObject("GuildClerk","",false)
		CarryObject("","Handheld_Device/Anim_Bag.nif",false)
		time2 = PlayAnimationNoWait("","fetch_store_obj_R")
		Sleep(1)	
		StopAnimation("GuildClerk")
		PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
		CarryObject("","",false)	

		AddItems("",Object,1)
		-- Fajeth_Mod Timeout
		SetMeasureRepeat(TimeOut)
		-- Mod end
		if IsStateDriven() then
			SetProperty("", "RawMaterial", Object)
			SetState("",STATE_AIUNPACKRAWMATERIAL,true)
		end
	end
end

function CleanUp()
	EndCutscene("")
	DestroyCutscene("cutscene")
	MoveSetActivity("")
	SetState("", STATE_LOCKED, false)
	ReleaseAvoidanceGroup("")
end

-- Fajeth Mod
function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

-- Mod end