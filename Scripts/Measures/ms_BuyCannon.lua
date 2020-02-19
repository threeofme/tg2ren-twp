-- -----------------------
-- Run
-- -----------------------
function Run()
	GetNearestSettlement("", "City")
	if (gameplayformulas_CheckPublicBuilding("city", GL_BUILDING_TYPE_SCHOOL)[1]==0) then
		MsgQuick("", "@L_MEASURE_BUYCANNON_FAILURE_+1", GetID("City"))
		StopMeasure()
	end
	
	local Fame = chr_SimGetImperialFameLevel("")

	local ImperialOfficer = false
	if chr_GetImperialOfficer()==GetID("") then
		ImperialOfficer = true
	elseif Fame < 2 then
		MsgQuick("", "@L_MEASURE_BUYCANNON_FAILURE_+0", GetID(""))
		StopMeasure()
	end

	local items = {}
	local moneymod
	if ImperialOfficer==true then
		items = { "Pistole", "Round", "Sparkingsteel", "Granate", "Cannon", "Cannonball" }
		moneymod = Fame
	else
		if Fame==2 then
			items = { "Pistole", "Round" }
		elseif Fame==3 then
			items = { "Pistole", "Round", "Sparkingsteel", "Granate" }
		elseif Fame>3 then
			items = { "Pistole", "Round", "Sparkingsteel", "Granate", "Cannon", "Cannonball" }
		else
			MsgQuick("", "@L_MEASURE_BUYCANNON_FAILURE_+0", GetID(""))
			StopMeasure()
		end
		moneymod = Fame * 2
	end

	local	itemcount = 1
	while items[itemcount] do
		itemcount = itemcount + 1
	end

	local money = {}
	local	ItemLabel = {}
	local ItemTexture
	local btn = ""
	for x = 1, itemcount-1 do
		ItemLabel[x] = "@L"..ItemGetLabel(items[x],true)
		money[x] = math.floor(ItemGetBasePrice(items[x]) * moneymod)
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
		"@L_MEASURE_BUYCANNON_QUESTION_+0",
		"",
		ItemLabel[1],ItemLabel[2],
		ItemLabel[3],ItemLabel[4],
		ItemLabel[5],ItemLabel[6],
		ItemLabel[7],ItemLabel[8],
		ItemLabel[9],ItemLabel[10],
		ItemLabel[11],ItemLabel[12])
	end

	if Result == "C" then
		StopMeasure()
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
	else
		ItemIndex = 6
	end

	local Object = ItemGetName(items[ItemIndex])
	local ObjectLabel = ItemGetLabel(items[ItemIndex], true)
	local Space = GetRemainingInventorySpace("",Object)

	if Space < 1 then
		MsgQuick("", "@L_MEASURE_BUYRAWMATERIAL_FAILURE_+0", GetID(""), ObjectLabel)
		StopMeasure()
	elseif GetMoney("") < money[ItemIndex] then
		MsgQuick("", "@L_MEASURE_BUYRAWMATERIAL_FAILURE_+1", GetID(""), ObjectLabel)
		StopMeasure()
	end
	
	local amount = 1
	if math.mod(ItemIndex, 2) == 0 then -- ammunition bought
		local buttons = ""
		if Space > 19 then
			buttons = buttons.."@B[20,@L_BUY_CANNON_AMMU_AMOUNT_+2]"
		end
		if Space > 4 then
			buttons = buttons.."@B[5,@L_BUY_CANNON_AMMU_AMOUNT_+1]"
		end
		buttons = buttons.."@B[1,@L_BUY_CANNON_AMMU_AMOUNT_+0]"
		
		local Result = MsgBox("", "", "@P"..
			buttons..
			"@B[0,@L_REPLACEMENTS_BUTTONS_CANCEL_+0]",
			"@L_BUY_CANNON_AMMU_AMOUNT_HEAD+0",
			"@L_BUY_CANNON_AMMU_AMOUNT_BODY+0")
			
		if Result == 0 then
			StopMeasure()
		end
		amount = Result
	end

	if not f_SpendMoney("", amount*money[ItemIndex], "FireArms", false) then
		MsgQuick("", "@L_MEASURE_BUYRAWMATERIAL_FAILURE_+1", GetID(""), ObjectLabel)
		StopMeasure()
	end

	-- CarryObject("MaterialGuard","",false)
	-- CarryObject("","Handheld_Device/ANIM_Smallsack.nif",false)
	-- time2 = PlayAnimationNoWait("","fetch_store_obj_R")
	-- Sleep(1)	
	-- StopAnimation("MaterialGuard")
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	-- CarryObject("","",false)	

	AddItems("",Object,amount)
	chr_SimAddImperialFame("",amount)
	
end

function CleanUp()

end
