-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_001_MakeEvocation"
----
----	with this measure the alchimist is able to make an evocation
----
-------------------------------------------------------------------------------


function Run()
	if not GetInsideBuilding("", "Building") then
		StopMeasure()
	end

	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)

	local	Slots = InventoryGetSlotCount("", INVENTORY_STD)
	local	Number
	local	ItemId
	local	ItemCount
	local	NumItems = 0
	local	ItemName = {}
	local	ItemLabel = {}
	local 	btn = ""
	local	added = {}
	local	ItemTexture
	
	--count all items, remove duplicates
	for Number = 0, Slots-1 do
		ItemId, ItemCount = InventoryGetSlotInfo("", Number, InventoryType)
		if ItemId and ItemId>0 and ItemCount then
			if ItemGetType(ItemId) == 8 then	--gathering item
				if not added[ItemId] then
					
					added[ItemId] = true
				
					--create labels for replacements
					ItemName[NumItems] = ItemId 
					local ItemTextureName = ItemGetName(ItemId)
					ItemTexture = "Hud/Items/Item_"..ItemTextureName..".tga"
					btn = btn.."@B[A"..NumItems..",,%"..1+NumItems.."l,"..ItemTexture.."]"
					ItemLabel[NumItems] = ""..ItemGetLabel(ItemName[NumItems],true)
					NumItems = NumItems + 1
	
				end
			end
		end
	end
	SetData("NumItems",NumItems)
	
	local Result
	if Slots > 0 and NumItems > 0 then				
		Result = InitData("@P"..btn,
				ms_001_makeevocation_AIDecide,  --AIFunc
				"@L_MEASURE_MakeEvocation_NAME_+0",
				"",
				ItemLabel[0],ItemLabel[1],
				ItemLabel[2],ItemLabel[3],
				ItemLabel[4],ItemLabel[5])
				
		
	else
		MsgQuick("","@L_ALCHEMIST_001_MAKEEVOCATION_FAILURES_+0")
		StopMeasure()
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
	else
		ItemIndex = 5
	end

	--make sure there's room in inventory with item removed. If not, put item back and end measure.
	RemoveItems("",ItemName[ItemIndex],1,INVENTORY_STD)
	local HasRoom = 0
	Slots = InventoryGetSlotCount("", INVENTORY_STD)
	for Number = 0, Slots-1 do
		ItemId, ItemCount = InventoryGetSlotInfo("", Number, InventoryType)
		if ItemId and ItemId>0 and ItemCount then
			--nothing
		else
			HasRoom = 1
		end
	end
	
	if HasRoom == 0 then
		MsgQuick("","@L_GENERAL_INFORMATION_INVENTORY_INVENTORY_FULL_SPEECH_+3")
		AddItems("",ItemName[ItemIndex],1,INVENTORY_STD)
		StopMeasure()
	end

	SetData("ItemUsed",ItemName[ItemIndex])
	SetData("SummonComplete",0)
	
	-- do the visual stuff here
	GetLocatorByName("Building", "Ritual1", "Evocation1")
	f_MoveTo("","Evocation1")
	PlayAnimation("", "cogitate")
	GetLocatorByName("Building", "Ritual2", "Evocation2")
	f_MoveTo("","Evocation2")
	PlayAnimation("", "manipulate_middle_twohand")
	GetLocatorByName("Building", "Ritual3", "Evocation3")
	GetLocatorByName("Building", "ParticleSpawnPos","SpawnPos")
	f_MoveTo("","Evocation3")
	local AnimTime = PlayAnimationNoWait("", "make_evocation")
	Sleep(AnimTime-2)

	--do the evocation stuff
	SetMeasureRepeat(1)	
	SetData("SummonComplete",1)
	
	local SumGold
	local EvocationSkill = GetSkillValue("",SECRET_KNOWLEDGE) * 10 --secret knowledge
	local EvocationChance = Rand(110)
	local Success = false

	if EvocationSkill > EvocationChance then
		if ItemGetName(ItemName[ItemIndex]) == "Gold" then		--gold
			ms_001_makeevocation_Success("Gold","Iron")

		elseif ItemGetName(ItemName[ItemIndex]) == "Spiderleg" then	--spiderleg
			ms_001_makeevocation_Success("Spiderleg","PoisonedCake", ItemLabel)

		elseif ItemGetName(ItemName[ItemIndex]) == "Charcoal" then	--oakwood
			ms_001_makeevocation_Success("Charcoal","Holzpferd")

		elseif ItemGetName(ItemName[ItemIndex]) == "Frogeye" then	--frogeye
			ms_001_makeevocation_Success("Frogeye","PoisonedCake")

		elseif ItemGetName(ItemName[ItemIndex]) == "Silver" then	--silver
			SumGold = Rand(300)+300
			ms_001_makeevocation_SuccessGold("Silver",SumGold)

		elseif ItemGetName(ItemName[ItemIndex]) == "Iron" then	--iron
			SumGold = Rand(300)+100
			ms_001_makeevocation_SuccessGold("Iron",SumGold)

		else
			StartSingleShotParticle("particles/change_effect.nif", "SpawnPos", 0.7,2)
			PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
--			PlayAnimation("","cogitate")
			ms_001_makeevocation_Nothing()
		end
	else
		StartSingleShotParticle("particles/change_effect.nif", "SpawnPos", 0.7,2)
		PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
--		PlayAnimation("","cogitate")
		ms_001_makeevocation_Nothing()
	end
end

function Success(item1,item2)
	StartSingleShotParticle("particles/change_effect.nif", "SpawnPos", 0.7,2)
	PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
	AddItems("",item2,1)
	if IsGUIDriven() then
		MsgNewsNoWait("", "Building", "", "intrigue", -1, "@L_ALCHEMIST_001_MAKEEVOCATION_GOLDSUCCESS_HEAD_+0", "@L_ALCHEMIST_001_MAKEEVOCATION_GOLDSUCCESS_BODY_+1", ItemGetLabel(item1, 1), ItemGetLabel(item2, 1))
	end
	chr_GainXP("",GetData("BaseXP"))
	StopMeasure()
end

function SuccessGold(item1,gold)
	StartSingleShotParticle("particles/change_effect.nif", "SpawnPos", 0.7,2)
	PlaySound3D("","Effects/coins_to_moneybag+0.wav", 1.0)
	chr_RecieveMoney("",gold,"Evocation")
	Sleep(0.3)
	if IsGUIDriven() then
		MsgNewsNoWait("", "Building", "", "intrigue", -1, "@L_ALCHEMIST_001_MAKEEVOCATION_GOLDSUCCESS_HEAD_+0", "@L_ALCHEMIST_001_MAKEEVOCATION_GOLDSUCCESS_BODY_+0", ItemGetLabel(item1, 1), gold)
	end
	chr_GainXP("",GetData("BaseXP"))
	StopMeasure()
end

function Nothing()
	StartSingleShotParticle("particles/toadexcrements_hit.nif", "SpawnPos", 1.3,5)
	if IsGUIDriven() then
		MsgNewsNoWait("", "Building", "", "intrigue", -1, "@L_ALCHEMIST_001_MAKEEVOCATION_FAILED_HEAD_+0", "@L_ALCHEMIST_001_MAKEEVOCATION_FAILED_BODY_+0")
	end
	StopMeasure()
end

function AIDecide()
	local NumItems = GetData("NumItems")
	return "A"..NumItems
end

function CleanUp()
	MsgMeasure("","")
	if GetData("SummonComplete") == 0 then
  	AddItems("",GetData("ItemUsed"),1,INVENTORY_STD)
	end
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end


