function Init()
	SetStateImpact("no_idle")
	SetStateImpact("no_control")
	SetStateImpact("no_hire")
	SetStateImpact("no_enter")
	SetStateImpact("no_measure_attach")
	SetStateImpact("no_measure_start")
	SetStateImpact("NoCameraJump")
end

function Run()
	if GetHomeBuilding("","myhome") then
		BuildingGetCity("myhome","city")
		if (gameplayformulas_CheckPublicBuilding("city", GL_BUILDING_TYPE_BANK)[1]==0) then
			SetState("",STATE_GUILDTRAVELLING,false)
			StopMeasure()
		end
	else
		StopMeasure()
	end

	if not HasProperty("","TravellerDuration") then
		SetState("",STATE_GUILDTRAVELLING,false)
	end

	if not GetInsideBuilding("", "Guildhouse") then
		if not FindNearestBuilding("", -1, GL_BUILDING_TYPE_BANK, -1, false, "Guildhouse") then
			SetState("",STATE_GUILDTRAVELLING,false)
		end
	end
	GetSettlement("Guildhouse", "City")

	if GetLocatorByName("Guildhouse","TravelStart","destpos") then
		while true do
			if f_MoveTo("","destpos",GL_MOVESPEED_WALK) then
				break
			end
			Sleep(5)
		end
	end

	local ContractDuration = GetProperty("", "TravellerDuration")
	local ContractMoney = GetProperty("", "TravellerMoney")
	local ContractFame = GetProperty("", "TravellerFame")
	local ContractOrderer = GetProperty("", "TravellerOrderer")

	SetInvisible("", true)
	AddImpact("", "Hidden", 1 , -1)

	--beam me to mapexit1
	if not GetOutdoorLocator("MapExit1",1,"FarFarAway") then
		if not GetOutdoorLocator("MapExit2",1,"FarFarAway") then
			SetState("",STATE_GUILDTRAVELLING,false)
		end
	end

	if AliasExists("FarFarAway") then
		SimBeamMeUp("","FarFarAway",false)
	end

	for i=1,ContractDuration,2 do
		Sleep(2)
	end

	if AliasExists("FarFarAway") then
		SimBeamMeUp("","destpos",false)
	end


	if GetLocatorByName("Guildhouse","TravelEnd","endpos") then
		while true do
			if f_MoveTo("","endpos",GL_MOVESPEED_WALK) then
				break
			end
			Sleep(5)
		end
	end

	f_CreditMoney("", ContractMoney, "GuildContract")

	if not GetSettlementID("")==GetID("city") then
		ContractFame = ContractFame - 2
	end
	chr_SimAddFame("",ContractFame)
	chr_GainXP("",ContractFame*10)

	MsgBoxNoWait("", "",
						"@L_GUILDHOUSE_MISSIONS_TASK_FINISH_HEAD_+0",
						"@L_GUILDHOUSE_MISSIONS_TASK_FINISH_TEXT_+0",
						GetID(""), "_GUILDHOUSE_MISSIONS_TASK_ORDERER_TEXT_+"..ContractOrderer, ContractMoney)

	SetState("",STATE_GUILDTRAVELLING,false)

end

function CleanUp()
	RemoveProperty("", "TravellerDuration")
	RemoveProperty("", "TravellerMoney")
	RemoveProperty("", "TravellerFame")
	RemoveProperty("", "TravellerOrderer")
	if AliasExists("FarFarAway") then
		SimBeamMeUp("","destpos",false)
	end
	RemoveImpact("", "Hidden")
	SetInvisible("", false)
	SetState("",STATE_LOCKED,false)
	AllowMeasure("", "ToggleInventory", EN_BOTH)
	SetState("",STATE_GUILDTRAVELLING,false)
end

