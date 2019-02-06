function Init()
	--InitAlias("Destination",GetData("PanelName"),GetData("TargetFilterID"),GetData("TargetMessage"),0)
	
	-- TODO disallow sales on other players workshops
	local Choices = ""
	if GetDynastyID("") == GetDynastyID("Destination") or BuildingGetClass("Destination") == GL_BUILDING_CLASS_MARKET then
		Choices = Choices.."@B[A,,@L_GENERAL_MEASURES_SENDCARTANDUNLOAD_TEXT_+1,Hud/Buttons/Unload.tga]"..
			"@B[B,,@L_GENERAL_MEASURES_SENDCARTANDUNLOAD_TEXT_+2,Hud/Buttons/UnloadAndSendBack.tga]"..
			"@B[D,,@L_GENERAL_MEASURES_SENDCART_TEXT_+0,Hud/Buttons/SendCartAndUnload.tga]"
	end
	Choices = Choices.."@B[S,,@L_TOM_SENDCART_LOADITEMS_+0,hud/buttons/btn_008_TakeCredit.tga]"
	local result = InitData("@P"..Choices,
	ms_sendcartandunload_AIInit,
	"@L_GENERAL_MEASURES_SENDCARTANDUNLOAD_TEXT_+0",
	"")
	
	if result == "C" then
		StopMeasure()
	end
	SetData("Result",result)
	
	if result == 'S' then
		-- ask for item type and amount to load
		local ItemId, AmountToBuy = cart_ChooseItemsToLoad("", "Destination")
		if ItemId and ItemId > 0 and AmountToBuy > 0 then
			SetData("ItemId", ItemId)
			SetData("AmountToBuy", AmountToBuy)
		else
			StopMeasure()
		end
	end
end

function AIInit()
	return "A"
end

function Run()

--CART TRADE MENU
	
	local result = GetData("Result")
	
	if not AliasExists("Destination") then
		StopMeasure()
	end
	CopyAlias("Destination","EndPos")
	GetPosition("","StartPos")
	
	if DynastyIsPlayer("") then
		SetProperty("", "AutoRoute")
	end
		
	if not f_MoveTo("","EndPos", GL_MOVESPEED_RUN) then
		StopMeasure()
	end
	
	if result == "D" then
		MsgQuick("","@L_GENERAL_MEASURES_SENDCART_MSG_+1")
		StopMeasure()
	end
	
	local	Amount = 0
	local	Found = false
	if result == "S" then
		Sleep(1)
		-- buy items from other workshop, don't sell
		local ItemId = GetData("ItemId")
		local AmountToBuy = GetData("AmountToBuy")
		local RemainingSpace = GetRemainingInventorySpace("", ItemId)
		if GetDynastyID("") ~= GetDynastyID("Destination") and BuildingGetClass("Destination") ~= GL_BUILDING_CLASS_MARKET then
			local ItemCount, TotalPrice = economy_BuyItems("Destination", "", ItemId, math.min(AmountToBuy, RemainingSpace))
			AddItems("", ItemId, ItemCount)
			GetHomeBuilding("","homeBuilding")
			economy_UpdateBalance("homeBuilding", "Autoroute", (0-TotalPrice))
			Found = true
			Amount = Amount + ItemCount
		else
			-- load from own shop or market
			local Error, ItemTransfered = Transfer("","",INVENTORY_STD,"Destination",INVENTORY_STD, ItemId, AmountToBuy)
			if GetSettlement("Destination", "MyCity") then
				GetHomeBuilding("","homeBuilding")
				CityGetLocalMarket("MyCity","MyMarket")
				-- TODO add bargaining bonus for markets 
				local EstimatedMoney = (0-ItemGetPriceBuy(ItemId,"MyMarket")) * ItemTransfered
				economy_UpdateBalance("homeBuilding", "Autoroute", EstimatedMoney)
			end
			Found = true
			Amount = Amount + ItemTransfered
		end
		Sleep(1)
	else
		Sleep(1) -- unload
		--do the transfer
		local	Slots = InventoryGetSlotCount("", INVENTORY_STD)
		local	ItemId
		local	ItemCount
		local	Error, ItemTransfered
		local BargainMoney = 0
		local EstimatedMoney = 0
		local	CurrentSlot = Slots-1
		for Number = 0, Slots-1 do
			ItemId, ItemCount = InventoryGetSlotInfo("", CurrentSlot, InventoryType)
			
			if ItemId and ItemCount then
				-- Add some bargain-bonus on market sells
				if BuildingGetClass("Destination") == 5 then
					if GetHomeBuilding("","Buisness") then
						if BuildingGetOwner("Buisness","MyBoss") then
							if GetSettlement("", "MyCity") then
								CityGetLocalMarket("MyCity","MyMarket")
								EstimatedMoney = ItemGetPriceSell(ItemId,"MyMarket")*ItemCount
								BargainMoney = math.floor(EstimatedMoney*((GetSkillValue("MyBoss",BARGAINING)*2)/100))
								economy_UpdateBalance("Buisness", "Autoroute", math.abs(EstimatedMoney + BargainMoney))
							end
						end
					end
				end
				Error, ItemTransfered = Transfer("","Destination",INVENTORY_STD,"",INVENTORY_STD,ItemId,ItemCount)
				Amount = Amount + ItemTransfered
				Found = true
			end
			CurrentSlot = CurrentSlot - 1
			Sleep(0.5)
			if BargainMoney > 0 then
				f_CreditMoney("",BargainMoney,"Bargaining")
				ShowOverheadSymbol("", false, false, 0, "@L(+ %1t)",BargainMoney)
			end
			Sleep(0.4)
		end
	end
	
	if not HasData("IsShip") then
		if Amount <= 0 and Found then
			MsgQuick("","@L_GENERAL_MEASURES_SENDCART_MSG_+0")
			StopMeasure()
		end
		
		if result == "A" and Found then
			MsgQuick("","@L_GENERAL_MEASURES_SENDCARTANDUNLOAD_MSG_+0")
			StopMeasure()
		elseif result == "A" then
			MsgQuick("","@L_GENERAL_MEASURES_SENDCART_MSG_+1")
			StopMeasure()
		end
		
		if not f_MoveTo("","StartPos", GL_MOVESPEED_RUN) then
			StopMeasure()
		end
		
		-- if loading measure, unload at starting point if that is my own workshop
		if result == "S" then
			-- check for own workshop
			if GetHomeBuilding("","MyHome") and GetOutdoorMovePosition("", "MyHome", "RetPos") 
					and CalcDistance("", "RetPos") < 300 then
				-- TODO local	Slots = InventoryGetSlotCount("", INVENTORY_STD)
				local Slots = InventoryGetSlotCount("", INVENTORY_STD)
				local ItemId, ItemCount
				for i = 0, Slots - 1 do
					ItemId, ItemCount = InventoryGetSlotInfo("", i, INVENTORY_STD)
					if ItemId and ItemCount and CanAddItems("MyHome", ItemId, ItemCount, INVENTORY_STD)  then
						RemoveItems("", ItemId, ItemCount, INVENTORY_STD)
						AddItems("MyHome", ItemId, ItemCount, INVENTORY_STD)
					end
				end
			end
		end
		-- _GENERAL_MEASURES_SENDCARTANDUNLOAD_MSG_+0 -- abgeladen und ist zurück
		MsgQuick("","@L_GENERAL_MEASURES_SENDCARTANDUNLOAD_MSG_+1")
	end
	
	StopMeasure()
end

function CleanUp()

	if HasProperty("", "AutoRoute") then
		RemoveProperty("", "AutoRoute")
	end
	
end

--- unused
function ChooseAmountToLoad()
	-- offer up to ten buttons (10% -- 100%)
	local LastAmount = 0
	local CurrentAmount
	local Buttons = ""
	-- TODO maximum depends on cart size
	for i=1, 10 do
		CurrentAmount = math.floor(Count * i/10)
		if CurrentAmount > LastAmount then
			Buttons = Buttons.."@B["..CurrentAmount..","..CurrentAmount..",]"
			LastAmount = CurrentAmount
		end
	end
	local Price = economy_GetPrice("Destination", ItemId, "")
	local AmountToBuy = MsgBox("","",
		"@P"..Buttons, -- 
		"@L_TOM_SENDCART_LOADITEMS_HEAD_+0", 
		"@L_TOM_SENDCART_LOADITEMS_BODY_+0", 
		ItemGetLabel(ItemId, false), Price)
	if AmountToBuy == "C" then
		StopMeasure()
	end 
end
