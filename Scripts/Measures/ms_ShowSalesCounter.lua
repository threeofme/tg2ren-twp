------
-- Building measure to view the sales counter of workshops not owned by the player.
-- 
-- Measures.dbt
-- 13084   "ms_ShowSalesCounter.lua"   "-"   "ShowSalesCounter"   40   "Hud/Buttons/Unload.tga"   0   5   0   ""   ""   0   0   0   "none"   0   0   |
-- 
-- MeasuresToObjects.dbt
-- 3097   13084   0   0   2072   2   ""   ()   ""   0   0   |
-- 
-- Filter.dbt
-- 2072   "ShowSalesCounter" "__F((Object.Type==Building)AND(Object.IsClass(2))AND(Object.HasProperty(SalescounterPrice))AND(Object.HasDynasty())AND NOT(Object.BelongsToMe()))" |
-- 
------

function Run()
	CopyAlias("","Workshop")
	LogMessage("TOM::ShowSalesCounter dynasty alias is "..GetName("dynasty"))
  
  CreateScriptcall("ShowCounter", 0, "Measures/ms_ShowSalesCounter.lua", "ShowSalesCounter", "dynasty", "Workshop")
  
--	DynastyGetRandomBuilding("dynasty", GL_BUILDING_CLASS_LIVINGROOM, -1, "MyBld")
--  -- TODO make sure this will not interrupt current SIM measure	
--	MeasureRun("MyBld", "Workshop", "ShowSalesCounterSim", true)
	
end

function ShowSalesCounter()
  LogMessage("TOM::ShowSalesCounterSim starting")
  if not AliasExists("Destination") then
  LogMessage("TOM::ShowSalesCounterSim Destination not given")
    return
  end

  LogMessage("TOM::ShowSalesCounterSim Getting items for sale")
  -- TODO the measure is AI driven, that's probably the reason for InitData not being called
  if IsGUIDriven() then
    LogMessage("IsGUIDriven")
  else
    LogMessage("IsAIDriven")
  end
  
  local Count, Items = economy_GetItemsForSale("Destination")
  LogMessage("TOM::ShowSalesCounterSim Found items: " .. Count)
  economy_ChooseItemFromCounter("Destination", Count, Items)
end