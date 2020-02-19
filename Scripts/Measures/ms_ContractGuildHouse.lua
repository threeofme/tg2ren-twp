-- -----------------------
-- Run
-- -----------------------
function Run()

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

	if BuildingGetType("")==GL_BUILDING_TYPE_BANK then
		CopyAlias("", "Guildhouse")
	else
		if not GetInsideBuilding("", "Guildhouse") then
			StopMeasure()
		end
	end

	GetSettlement("Guildhouse", "City")

	if (gameplayformulas_CheckPublicBuilding("City", GL_BUILDING_TYPE_BANK)[1]==0) then
		MsgQuick("", "@L_MEASURE_CONTRACTGUILDHOUSE_TASK_FAILURE_+1", GetID("City"))
		StopMeasure()
	end

	local ContractCount = GetProperty("Guildhouse", "ContractCount")
	if ContractCount==nil or ContractCount<1 then
		StopMeasure()
	end
	
	local Contract = GetProperty("Guildhouse", "Contract")
	local ContractClass = GetProperty("Guildhouse", "ContractClass")-1
	local ContractItem = GetProperty("Guildhouse", "ContractItem")
	local ContractOrderer = GetProperty("Guildhouse", "ContractOrderer")
	local ContractMoney = GetProperty("Guildhouse", "ContractMoney")
	local ContractFame = GetProperty("Guildhouse", "ContractFame")

	if Contract==1 then
		local ItemLabel	= ItemGetLabel(ContractItem, false)
		local ItemLabel2	= ItemGetLabel(ContractItem, true)
		local choice

		if IsStateDriven() then
			if not (SimGetClass("")==(ContractClass+1)) then
				f_ExitCurrentBuilding("")
				StopMeasure()
			end
			if GetItemCount("",ContractItem)==0 then
				MeasureRun("", nil, "BuyWorkingPlan",true)
			end
			choice = 0
		else
			if GetItemCount("",ContractItem)==0 then
				MsgBox("dynasty", "Guildhouse", "", "@L_GUILDHOUSE_MISSIONS_ITEMS_HEAD_+0",
									"@L_GUILDHOUSE_MISSIONS_ITEMS_TEXT_+2",
									"_GUILDHOUSE_GUILDS_+"..ContractClass, GetID("City"), "_GUILDHOUSE_MISSIONS_ITEMS_ORDERER_TEXT_+"..ContractOrderer, ContractCount, ItemLabel, ContractMoney)
				StopMeasure()
			end
			choice = MsgBox("", "", "@P@B[0,@L_GUILDHOUSE_MISSIONS_ITEMS_OPTION_+0]"..
								"@B[1,@L_GUILDHOUSE_MISSIONS_ITEMS_OPTION_+1]",
								"@L_GUILDHOUSE_MISSIONS_ITEMS_HEAD_+0",
								"@L_GUILDHOUSE_MISSIONS_ITEMS_TEXT_+1",
								"_GUILDHOUSE_GUILDS_+"..ContractClass, GetID("City"), "_GUILDHOUSE_MISSIONS_ITEMS_ORDERER_TEXT_+"..ContractOrderer, ContractCount, ItemLabel, GetID(""), ContractMoney, ItemLabel2)
		end
			
		if (choice==0) then
	
			ContractCount = GetProperty("Guildhouse", "ContractCount")
			if ContractCount<1 then
				MsgQuick("", "@L_MEASURE_CONTRACTGUILDHOUSE_TASK_FAILURE_+0")
				StopMeasure()
			end
			ContractCount = ContractCount - 1
			SetProperty("Guildhouse", "ContractCount", ContractCount)
			RemoveItems("", ContractItem, 1)
			f_CreditMoney("", ContractMoney, "GuildContract")

			if not (SimGetClass("")==(ContractClass+1)) then
				ContractFame = ContractFame - 1
			end
			
			if not GetSettlementID("")==GetID("city") then
				ContractFame = ContractFame - 1
			end
			
			chr_SimAddFame("",ContractFame)
		
		end

	elseif Contract==2 then
		local ContractDuration = GetProperty("Guildhouse", "ContractDuration")
		local eventstring
		if ContractClass==0 then
			eventstring = "@L_GUILDHOUSE_MISSIONS_TASK_PATRON_TEXT_+"..ContractItem
			tmpDuration = (ContractDuration * 60) - (GetSkillValue("",CRAFTSMANSHIP) * (ContractDuration * 2))
		elseif ContractClass==1 then
			eventstring = "@L_GUILDHOUSE_MISSIONS_TASK_ARTISAN_TEXT_+"..ContractItem 
			tmpDuration = (ContractDuration * 60) - (GetSkillValue("",CRAFTSMANSHIP) * (ContractDuration * 2))
		elseif ContractClass==2 then
			eventstring = "@L_GUILDHOUSE_MISSIONS_TASK_SCHOLAR_TEXT_+"..ContractItem 
			tmpDuration = (ContractDuration * 60) - (GetSkillValue("",SECRET_KNOWLEDGE) * (ContractDuration * 2))
		else
			eventstring = "@L_GUILDHOUSE_MISSIONS_TASK_CHISELER_TEXT_+"..ContractItem 
			tmpDuration = (ContractDuration * 60) - (GetSkillValue("",SHADOW_ARTS) * (ContractDuration * 2))
		end

		local choice
		if IsStateDriven() then
			if not (SimGetClass("")==(ContractClass+1)) then
				f_ExitCurrentBuilding("")
				StopMeasure()
			end
			choice = 0
		else
			if (GetID("")==GetID("Guildhouse")) or not(SimGetClass("")==(ContractClass+1)) then
				MsgBox("dynasty", "Guildhouse", "", "@L_GUILDHOUSE_MISSIONS_TASK_HEAD_+0",
									"@L_GUILDHOUSE_MISSIONS_TASK_TEXT_+0",
						      "@L_GUILDHOUSE_GUILDS_+"..ContractClass,GetID("City"),eventstring, "@L_GUILDHOUSE_MISSIONS_TASK_ORDERER_TEXT_+"..ContractOrderer, ContractDuration, ContractMoney)
				StopMeasure()
			end

			choice = MsgBox("", "", "@P@B[0,@L_GUILDHOUSE_MISSIONS_TASK_OPTION_+0]"..
								"@B[1,@L_GUILDHOUSE_MISSIONS_TASK_OPTION_+1]",
								"@L_GUILDHOUSE_MISSIONS_TASK_HEAD_+0",
								"@L_GUILDHOUSE_MISSIONS_TASK_TEXT_+1",
								"@L_GUILDHOUSE_GUILDS_+"..ContractClass,GetID("City"),eventstring, "@L_GUILDHOUSE_MISSIONS_TASK_ORDERER_TEXT_+"..ContractOrderer, tmpDuration, ContractMoney, GetID(""))
		end
	
		if (choice==0) then

			ContractCount = GetProperty("Guildhouse", "ContractCount")
			if ContractCount<1 then
				MsgQuick("", "@L_MEASURE_CONTRACTGUILDHOUSE_TASK_FAILURE_+0")
				StopMeasure()
			end
			ContractCount = ContractCount - 1
			SetProperty("Guildhouse", "ContractCount", ContractCount)
			SetProperty("", "TravellerDuration", tmpDuration)
			SetProperty("", "TravellerMoney", ContractMoney)
			SetProperty("", "TravellerFame", ContractFame)
			SetProperty("", "TravellerOrderer", ContractOrderer)

			ForbidMeasure("", "ToggleInventory", EN_BOTH)
			SetState("",STATE_LOCKED,true)
			SetState("",STATE_GUILDTRAVELLING,true)
		end
	else
		StopMeasure()
	end
	
end

function CleanUp()
end
