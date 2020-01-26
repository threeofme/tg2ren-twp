---
-- TODO 
-- * Localization for error messages
-- DONE Localization for amount selection
-- DONE Show prices in amount selection
-- * Combine with move action on buildings
--

function Init()
end
 
function Run()
  if not AliasExists("Destination") then
    return
  end
	
	local ChosenItemId, AvailableAmount = economy_ChooseItemFromInventory("Destination", "")
	if (not ChosenItemId) or (not AvailableAmount) then
		StopMeasure()
	end
	
	if AvailableAmount <= 0 then
		-- TODO Message to player that item is not available
		MsgQuick("","@L_MEASURE_ShowSalesCounterSim_ErrorMsg_+0")
		StopMeasure()
	end
	
	local DesiredAmount = ms_showsalescountersim_SelectItemAmountForSim("Destination", "", ChosenItemId, AvailableAmount)
	if DesiredAmount and DesiredAmount > 0 then
		if not f_MoveTo("","Destination", GL_MOVESPEED_RUN, 50) then
			StopMeasure()
		end 
		if BuildingGetClass("Destination") == GL_BUILDING_CLASS_MARKET then
			Transfer("","",INVENTORY_STD,"Destination",INVENTORY_STD, ChosenItemId, DesiredAmount)
			-- TODO msg if items could not be bought
			MsgQuick("","@L_MEASURE_ShowSalesCounterSim_ErrorMsg_+1")
		else
			local ItemCount, TotalPrice = economy_BuyItems("Destination", "", ChosenItemId, DesiredAmount)
			if ItemCount == 0 then -- TODO msg if items could not be bought
				MsgQuick("","@L_MEASURE_ShowSalesCounterSim_ErrorMsg_+1")
			end
			AddItems("", ChosenItemId, ItemCount, INVENTORY_STD)
		end 
	end
end

function SelectItemAmountForSim(BldAlias, SimAlias, ChosenItemId, AvailableAmount)
	local Option = {1, 3, 5, 10}
	local ItemLabel
	local mengenWahl = ""
	for i=1, 4 do
		if Option[i] <= AvailableAmount and CanAddItems(SimAlias, ChosenItemId, Option[i], INVENTORY_STD) then
			ItemLabel = ItemGetLabel(ChosenItemId, Option[i] == 1)
			mengenWahl = mengenWahl.."@B["..Option[i]..","..Option[i]..",]"
		end
	end
	mengenWahl = mengenWahl.."@B[C,@LBack_+0,]"
	local Price
	if BuildingGetClass("Destination") == GL_BUILDING_CLASS_MARKET then
		GetSettlement("Destination", "MyCity")
		CityGetLocalMarket("MyCity", "MyMarket")
		Price = ItemGetPriceBuy(ChosenItemId, "MyMarket")
	else
		Price = economy_GetPrice(BldAlias, ChosenItemId, SimAlias)
	end
	local Amount = MsgBox(SimAlias, SimAlias, "@P"..mengenWahl,"@L_TWP_ShowSalesCounterSim_AmountSelect_HEAD_+0","@L_TWP_ShowSalesCounterSim_AmountSelect_BODY_+0", GetID(SimAlias), GetID(BldAlias), ItemGetLabel(ChosenItemId,false), Price)
	if Amount and Amount ~= "C" then
		return Amount
	end
	return 0 
end