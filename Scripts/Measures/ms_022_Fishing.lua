Include("Measures/ms_022_gather.lua")

function Run()

	if not GetHomeBuilding("", "WorkBuilding") then
		return
	end
	
	if not BuildingGetWaterPos("WorkBuilding", true, "WaterPos") then
		return
	end
	
	local ItemID = ResourceGetItemId("Destination")
	if ItemID==-1 then
		return false
	end
	
	local Label = ItemGetLabel(ItemID, true)
	local Time = ItemGetProductionTime(ItemID) - 0.5
	local Count = ItemGetProductionAmount(ItemID)
	local PropName = "Gather_"..ItemID
	
	if not HasProperty("", PropName) then
		SetProperty("", PropName, 0)
	end

	while true do
	
		while GetRemainingInventorySpace("", ItemID) < 1 do
			if not f_MoveTo("", "WaterPos", GL_MOVESPEED_RUN) then
				return
			end
			Sleep(2)
			if not ms_022_gather_ReturnItems("", "WorkBuilding") then
				MsgQuick("","@L_GENERAL_MEASURES_SENDCART_MSG_+0")
				return
			end
			Sleep(2)
			if BuildingGetAISetting("WorkBuilding", "Produce_Selection")>0 then
				return
			end
		end
	
		if not gather_GotoResource("", "Destination", Label) then
			break
		end

		while GetRemainingInventorySpace("",ItemID) >= 1 do

			local	Diff
			local	StartTime
			local	CurrentTime = GetGametime()
			StartTime = CurrentTime
			
			while true do
				Sleep(2)
				CurrentTime = GetGametime()
				Diff = (CurrentTime - StartTime)
				StartTime = CurrentTime
				local Total = GetProperty("", PropName)
				if not Total then
					Total = 0
				end
				local ProdValue = GetImpactValue("", 4)
				Total = Total + ProdValue*Diff
				SetProperty("", PropName, Total)
				if Total > Time then
					RemoveProperty("", PropName)
					break
				end
			end
			
			--Removed = RemoveItems("Destination", ItemID, Count)
			--if Removed>0 then
			local RemainingSpace = GetRemainingInventorySpace("", ItemID)
			if RemainingSpace >= 5 then
				AddItems("", ItemID, (Rand(4))+2)
			else
				AddItems("", ItemID, RemainingSpace)
			end
			--end
		end
	end
end

function CleanUp()
end

