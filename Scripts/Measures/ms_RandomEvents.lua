function Init()
end

function Run()
	if not DynastyIsPlayer("") then
		StopMeasure()
	end
	GetScenario("scenario")
	if not HasProperty("scenario", "static") then
		if ms_randomevents_CheckMessages()==true then
			local random = Rand(200)
			if random <= 2 then
				ms_randomevents_RandomEventNeutral("")
			elseif random <= 4 then
				ms_randomevents_RandomEventPositiv("")
			elseif random <= 6 then
				ms_randomevents_RandomEventNegativ("")
			end
		end
	end
end

function CheckMessages()
	GetScenario("World")
	if HasProperty("World", "messages") then
		if GetProperty("World", "messages") == 1 then
			return true
		end
	end
	return false
end

function RandomEventNeutral(SimAlias)
	if not SimAlias then
		GetRandomPlayerDynasty("PlayerDyn")
		local BossID = dyn_GetValidMember("PlayerDyn")
		if not GetAliasByID(BossID, "PlayerSim") then
			StopMeasure()
		end
		
		if not IsPartyMember("PlayerSim") then
			StopMeasure()
		end
	else
		GetDynasty(SimAlias, "PlayerDyn")
		if IsType("", "Building") then
			BuildingGetOwner("", "PlayerSim")
		else
			CopyAlias(SimAlias, "PlayerSim")
		end
	end
	
	if GetState("PlayerSim",STATE_DEAD) then
		StopMeasure()
	end
	GetHomeBuilding("PlayerSim","HomeBuilding")
	BuildingGetCity("HomeBuilding","HomeTown")

	local mod = (Rand(5)+1)
	local cash = math.ceil((GetMoney("PlayerDyn")/50)*mod)
--	local RandSkill = (Rand(10)+1)
--	local Skills = {"_TALENTS_constitution_NAME_+0", "_TALENTS_dexterity_NAME_+0", "_TALENTS_charisma_NAME_+0", "_TALENTS_fighting_NAME_+0", "_TALENTS_craftsmanship_NAME_+0", "_TALENTS_shadow_arts_NAME_+0", "_TALENTS_rhetoric_NAME_+0", "_TALENTS_empathy_NAME_+0", "_TALENTS_bargaining_NAME_+0", "_TALENTS_secret_knowledge_NAME_+0"}

	local RandEvent = Rand(8)
  
	if RandEvent == 0 then
		MsgNewsNoWait("PlayerSim","PlayerSim","","default",-1,"@L_RANDOM_EVENT_NEUTRAL_MESSAGE_HEAD_+0",
					"@L_RANDOM_EVENT_NEUTRAL_MESSAGE_BODY_+0")

	elseif RandEvent == 1 then
		MsgNewsNoWait("PlayerSim","PlayerSim","","default",-1,"@L_RANDOM_EVENT_NEUTRAL_MESSAGE_HEAD_+1",
					"@L_RANDOM_EVENT_NEUTRAL_MESSAGE_BODY_+1")

--[[	elseif RandEvent == 2 then
		if DynastyGetRandomBuilding("PlayerSim",2,-1,"Business") then
			local SimClass = SimGetClass("PlayerSim")
			local SkillType
			if SimClass == 1 then
				SkillType = 2
			elseif SimClass == 2 then
				SkillType = 5
			elseif SimClass == 3 then
				SkillType = 7
			elseif SimClass == 4 then
				SkillType = 6
			end
			
			local numWorker = BuildingGetWorkerCount("Business")
			local random = Rand(numWorker)
			local RandWorker = BuildingGetWorker("Business",random,"Worker")
			local SkillMod = GetSkillValue("Worker", SkillType)
		  SetSkillValue("Worker", SkillType, (SkillMod+1))
	    MsgNewsNoWait("PlayerSim","Worker","","default",-1,"@L_RANDOM_EVENT_NEUTRAL_MESSAGE_HEAD_+2",
	                        "@L_RANDOM_EVENT_NEUTRAL_MESSAGE_BODY_+2",Skills[SkillType],GetID("Worker"),GetID("Business"))
		end
	]]--
	elseif RandEvent == 3 then
		MsgNewsNoWait("PlayerSim","PlayerSim","","default",-1,"@L_RANDOM_EVENT_NEUTRAL_MESSAGE_HEAD_+0",
					"@L_RANDOM_EVENT_NEUTRAL_MESSAGE_BODY_+3")

	elseif RandEvent == 4 then
		f_SpendMoney("PlayerSim", cash, "CostSocial")
		MsgNewsNoWait("PlayerSim","PlayerSim","","default",-1,"@L_RANDOM_EVENT_NEUTRAL_MESSAGE_HEAD_+2",
					"@L_RANDOM_EVENT_NEUTRAL_MESSAGE_BODY_+4",cash)
		if GetOfficeTypeHolder("HomeTown",8,"OfficeSim") then
			chr_ModifyFavor("OfficeSim","PlayerSim",20)
		end

	elseif RandEvent == 5 then
		MsgNewsNoWait("PlayerSim","PlayerSim","","default",-1,"@L_RANDOM_EVENT_NEUTRAL_MESSAGE_HEAD_+2",
					"@L_RANDOM_EVENT_NEUTRAL_MESSAGE_BODY_+5")

	elseif RandEvent == 6 then
		MsgNewsNoWait("PlayerSim","PlayerSim","","default",-1,"@L_RANDOM_EVENT_NEUTRAL_MESSAGE_HEAD_+2",
					"@L_RANDOM_EVENT_NEUTRAL_MESSAGE_BODY_+6")

	elseif RandEvent == 7 then
		MsgNewsNoWait("PlayerSim","PlayerSim","","default",-1,"@L_RANDOM_EVENT_NEUTRAL_MESSAGE_HEAD_+2",
					"@L_RANDOM_EVENT_NEUTRAL_MESSAGE_BODY_+7")

	end
end

function RandomEventPositiv(SimAlias)
	if not SimAlias then
		GetRandomPlayerDynasty("PlayerDyn")
		local BossID = dyn_GetValidMember("PlayerDyn")
		if not GetAliasByID(BossID, "PlayerSim") then
			StopMeasure()
		end
		
		if not IsPartyMember("PlayerSim") then
			StopMeasure()
		end
	else
		GetDynasty(SimAlias, "PlayerDyn")
		if IsType("", "Building") then
			BuildingGetOwner("", "PlayerSim")
		else
			CopyAlias(SimAlias, "PlayerSim")
		end
	end
	if GetState("PlayerSim",STATE_DEAD) then
		StopMeasure()
	end
	GetHomeBuilding("PlayerSim","HomeBuilding")
	BuildingGetCity("HomeBuilding","HomeTown")

	local mod = (Rand(5)+1)
	local cash = math.ceil((GetMoney("PlayerDyn")/50)*mod)
--	local RandSkill = (Rand(10)+1)
--	local Skills = {"_TALENTS_constitution_NAME_+0", "_TALENTS_dexterity_NAME_+0", "_TALENTS_charisma_NAME_+0", "_TALENTS_fighting_NAME_+0", "_TALENTS_craftsmanship_NAME_+0", "_TALENTS_shadow_arts_NAME_+0", "_TALENTS_rhetoric_NAME_+0", "_TALENTS_empathy_NAME_+0", "_TALENTS_bargaining_NAME_+0", "_TALENTS_secret_knowledge_NAME_+0"}

	local RandEvent = Rand(17)
  
	if RandEvent == 0 then
		f_CreditMoney("PlayerSim", cash, "GameStart")
		CityGetRandomBuilding("HomeTown",2,reli,-1,-1,FILTER_IGNORE,"HomeTown")											   
		MsgNewsNoWait("PlayerSim","PlayerSim","","default",-1,"@L_RANDOM_EVENT_POSITIV_MESSAGE_HEAD_+0",
					"@L_RANDOM_EVENT_POSITIV_MESSAGE_BODY_+0",cash)

	elseif RandEvent == 1 then
		f_CreditMoney("PlayerSim", cash, "GameStart")
		MsgNewsNoWait("PlayerSim","PlayerSim","","default",-1,"@L_RANDOM_EVENT_POSITIV_MESSAGE_HEAD_+1",
					"@L_RANDOM_EVENT_POSITIV_MESSAGE_BODY_+1",cash)

	elseif RandEvent == 2 then
		f_CreditMoney("PlayerSim", cash, "GameStart")
		MsgNewsNoWait("PlayerSim","PlayerSim","","default",-1,"@L_RANDOM_EVENT_NEUTRAL_MESSAGE_HEAD_+2",
					"@L_RANDOM_EVENT_POSITIV_MESSAGE_BODY_+2",cash)

	elseif RandEvent == 3 then
		local xpplus = ((mod*10)+50)
		IncrementXP("PlayerSim", xpplus)
		MsgNewsNoWait("PlayerSim","PlayerSim","","default",-1,"@L_RANDOM_EVENT_NEUTRAL_MESSAGE_HEAD_+2",
					"@L_RANDOM_EVENT_POSITIV_MESSAGE_BODY_+3",mod,xpplus)

	elseif RandEvent == 4 then
		f_CreditMoney("PlayerSim", cash, "GameStart")
		MsgNewsNoWait("PlayerSim","PlayerSim","","default",-1,"@L_RANDOM_EVENT_POSITIV_MESSAGE_HEAD_+0",
					"@L_RANDOM_EVENT_POSITIV_MESSAGE_BODY_+4",cash)

	elseif RandEvent == 5 then
		f_CreditMoney("PlayerSim", cash, "GameStart")
		MsgNewsNoWait("PlayerSim","PlayerSim","","default",-1,"@L_RANDOM_EVENT_POSITIV_MESSAGE_HEAD_+0",
					"@L_RANDOM_EVENT_POSITIV_MESSAGE_BODY_+5",cash)

	elseif RandEvent == 6 then
		local OfficeHolder = 5
		while OfficeHolder > 0 do
			local RandOffice = (Rand(OfficeHolder)+1)
			if GetOfficeTypeHolder("HomeTown",RandOffice,"OfficeHolderSim") and 
				(GetDynastyID("PlayerSim") ~= GetDynastyID("OfficeHolderSim")) then
				chr_ModifyFavor("OfficeHolderSim","PlayerSim",5)
				MsgNewsNoWait("PlayerSim","OfficeHolderSim","","default",-1,"@L_RANDOM_EVENT_NEUTRAL_MESSAGE_HEAD_+2",
							"@L_RANDOM_EVENT_POSITIV_MESSAGE_BODY_+6",GetID("OfficeHolderSim"),GetID("PlayerSim"))
				break
			end
			OfficeHolder = OfficeHolder - 1
		end
--[[	elseif RandEvent == 7 then
	  local SkillVal = GetSkillValue("PlayerSim", RandSkill)
		SetSkillValue("PlayerSim", RandSkill, (SkillVal+1))
	  MsgNewsNoWait("PlayerSim","PlayerSim","","default",-1,"@L_RANDOM_EVENT_POSITIV_MESSAGE_HEAD_+2",
	                    "@L_RANDOM_EVENT_POSITIV_MESSAGE_BODY_+7",Skills[RandSkill])
]]--
	elseif RandEvent == 8 then
		f_CreditMoney("PlayerSim", cash, "GameStart")
		MsgNewsNoWait("PlayerSim","PlayerSim","","default",-1,"@L_RANDOM_EVENT_NEUTRAL_MESSAGE_HEAD_+2",
					"@L_RANDOM_EVENT_POSITIV_MESSAGE_BODY_+8",cash)

	elseif RandEvent == 9 then
		local OfficeHolder = 6
		while OfficeHolder > 0 do
			local RandOffice = (Rand(OfficeHolder)+1)
			if GetOfficeTypeHolder("HomeTown",RandOffice,"OfficeHolderSim") then
				chr_ModifyFavor("OfficeHolderSim","PlayerSim",10)
				MsgNewsNoWait("PlayerSim","PlayerSim","","default",-1,"@L_RANDOM_EVENT_POSITIV_MESSAGE_HEAD_+0",
				"@L_RANDOM_EVENT_POSITIV_MESSAGE_BODY_+9",GetID("OfficeHolderSim"))
				break
			end
			OfficeHolder = OfficeHolder - 1
		end  

	elseif RandEvent == 10 then
		local OfficeHolder = 6
		while OfficeHolder > 0 do
			local RandOffice = (Rand(OfficeHolder)+1)
			if GetOfficeTypeHolder("HomeTown",RandOffice,"OfficeHolderSim") then
				chr_ModifyFavor("OfficeHolderSim","PlayerSim",10)
				MsgNewsNoWait("PlayerSim","OfficeHolderSim","","default",-1,"@L_RANDOM_EVENT_NEUTRAL_MESSAGE_HEAD_+2",
							"@L_RANDOM_EVENT_POSITIV_MESSAGE_BODY_+10",GetID("OfficeHolderSim"))
				break
			end
			OfficeHolder = OfficeHolder - 1
		end  
  
	elseif RandEvent == 11 then
		f_CreditMoney("PlayerSim", cash, "GameStart")
		MsgNewsNoWait("PlayerSim","PlayerSim","","default",-1,"@L_RANDOM_EVENT_POSITIV_MESSAGE_HEAD_+0",
					"@L_RANDOM_EVENT_POSITIV_MESSAGE_BODY_+11",cash)	

	elseif RandEvent == 12 then
		f_CreditMoney("PlayerSim", cash, "GameStart")
		MsgNewsNoWait("PlayerSim","PlayerSim","","default",-1,"@L_RANDOM_EVENT_POSITIV_MESSAGE_HEAD_+0",
					"@L_RANDOM_EVENT_POSITIV_MESSAGE_BODY_+12",cash)	

	elseif RandEvent == 13 then
		f_CreditMoney("PlayerSim", cash, "GameStart")
		MsgNewsNoWait("PlayerSim","PlayerSim","","default",-1,"@L_RANDOM_EVENT_NEUTRAL_MESSAGE_HEAD_+2",
					"@L_RANDOM_EVENT_POSITIV_MESSAGE_BODY_+13",cash)

	elseif RandEvent == 14 then
		f_CreditMoney("PlayerSim", cash, "GameStart")
		MsgNewsNoWait("PlayerSim","PlayerSim","","default",-1,"@L_RANDOM_EVENT_POSITIV_MESSAGE_HEAD_+0",
					"@L_RANDOM_EVENT_POSITIV_MESSAGE_BODY_+14",cash)

	elseif RandEvent == 15 then
		chr_SimAddFame("PlayerSim",mod)
		MsgNewsNoWait("PlayerSim","PlayerSim","","default",-1,"@L_RANDOM_EVENT_POSITIV_MESSAGE_HEAD_+0",
					"@L_RANDOM_EVENT_POSITIV_MESSAGE_BODY_+15")

	elseif RandEvent == 16 then
		chr_SimAddImperialFame("PlayerSim",mod)
		MsgNewsNoWait("PlayerSim","PlayerSim","","default",-1,"@L_RANDOM_EVENT_POSITIV_MESSAGE_HEAD_+0",
					"@L_RANDOM_EVENT_POSITIV_MESSAGE_BODY_+16")

	end
end

function RandomEventNegativ(SimAlias)
	if not SimAlias then
		GetRandomPlayerDynasty("PlayerDyn")
		local BossID = dyn_GetValidMember("PlayerDyn")
		if not GetAliasByID(BossID, "PlayerSim") then
			StopMeasure()
		end
		
		if not IsPartyMember("PlayerSim") then
			StopMeasure()
		end
	else
		GetDynasty(SimAlias, "PlayerDyn")
		if IsType("", "Building") then
			BuildingGetOwner("", "PlayerSim")
		else
			CopyAlias(SimAlias, "PlayerSim")
		end
	end
	if GetState("PlayerSim",STATE_DEAD) then
		StopMeasure()
	end
	GetHomeBuilding("PlayerSim","HomeBuilding")
	BuildingGetCity("HomeBuilding","HomeTown")

	local mod = (Rand(5)+1)
	local cash = math.ceil((GetMoney("PlayerDyn")/50)*mod)
--	local RandSkill = (Rand(10)+1)
--	local Skills = {"_TALENTS_constitution_NAME_+0", "_TALENTS_dexterity_NAME_+0", "_TALENTS_charisma_NAME_+0", "_TALENTS_fighting_NAME_+0", "_TALENTS_craftsmanship_NAME_+0", "_TALENTS_shadow_arts_NAME_+0", "_TALENTS_rhetoric_NAME_+0", "_TALENTS_empathy_NAME_+0", "_TALENTS_bargaining_NAME_+0", "_TALENTS_secret_knowledge_NAME_+0"}

	local RandEvent = Rand(14)

	if RandEvent == 0 then
		CityGetRandomBuilding("HomeTown",2,4,-1,-1,FILTER_IGNORE,"Tavern")
		f_SpendMoney("PlayerSim", cash, "CostSocial")		
		MsgNewsNoWait("PlayerSim","Tavern","","default",-1,"@L_RANDOM_EVENT_NEGATIV_MESSAGE_HEAD_+0",
	                    "		@L_RANDOM_EVENT_NEGATIV_MESSAGE_BODY_+0",GetID("Tavern"),cash)

	elseif RandEvent == 1 then
		f_SpendMoney("PlayerSim", cash, "CostSocial")
		MsgNewsNoWait("PlayerSim","PlayerSim","","default",-1,"@L_RANDOM_EVENT_POSITIV_MESSAGE_HEAD_+2",
					"@L_RANDOM_EVENT_NEGATIV_MESSAGE_BODY_+1",cash)

	elseif RandEvent == 2 then
		local OfficeHolder = 6
		while OfficeHolder > 0 do
			local RandOffice = (Rand(OfficeHolder)+1)
			if GetOfficeTypeHolder("HomeTown",RandOffice,"OfficeHolderSim") then
				chr_ModifyFavor("OfficeHolderSim","PlayerSim",-10)
				MsgNewsNoWait("PlayerSim","OfficeHolderSim","","default",-1,"@L_RANDOM_EVENT_NEUTRAL_MESSAGE_HEAD_+2",
							"@L_RANDOM_EVENT_NEGATIV_MESSAGE_BODY_+2",GetID("OfficeHolderSim"))
				break
		end
		OfficeHolder = OfficeHolder - 1
	end    

--[[	elseif RandEvent == 3 then
		local SkillVal = GetSkillValue("PlayerSim", RandSkill)
		SetSkillValue("PlayerSim", RandSkill, (SkillVal-1))
	  MsgNewsNoWait("PlayerSim","PlayerSim","","default",-1,"@L_RANDOM_EVENT_NEGATIV_MESSAGE_HEAD_+1",
	                    "@L_RANDOM_EVENT_NEGATIV_MESSAGE_BODY_+3",Skills[RandSkill])
]]--
	elseif RandEvent == 4 then
		f_SpendMoney("PlayerSim", cash, "CostSocial")
		MsgNewsNoWait("PlayerSim","PlayerSim","","default",-1,"@L_RANDOM_EVENT_NEGATIV_MESSAGE_HEAD_+2",
					"@L_RANDOM_EVENT_NEGATIV_MESSAGE_BODY_+4",cash)

	--[[elseif RandEvent == 5 then
		local xpminus = (0-((mod*10)+100))
		IncrementXP("PlayerSim", xpminus)
	  MsgNewsNoWait("PlayerSim","PlayerSim","","default",-1,"@L_RANDOM_EVENT_NEUTRAL_MESSAGE_HEAD_+2",
	                    "@L_RANDOM_EVENT_NEGATIV_MESSAGE_BODY_+5",xpminus)
]]--
	elseif RandEvent == 6 then
		f_SpendMoney("PlayerSim", cash, "GameStart")
		MsgNewsNoWait("PlayerSim","PlayerSim","","default",-1,"@L_RANDOM_EVENT_NEGATIV_MESSAGE_HEAD_+2",
					"@L_RANDOM_EVENT_NEGATIV_MESSAGE_BODY_+6",cash)	

	elseif RandEvent == 7 then
		f_SpendMoney("PlayerSim", cash, "CostSocial")
		MsgNewsNoWait("PlayerSim","PlayerSim","","default",-1,"@L_RANDOM_EVENT_NEGATIV_MESSAGE_HEAD_+2",
					"@L_RANDOM_EVENT_NEGATIV_MESSAGE_BODY_+7",cash)

	elseif RandEvent == 8 then
		f_SpendMoney("PlayerSim", cash, "CostSocial")
		MsgNewsNoWait("PlayerSim","PlayerSim","","default",-1,"@L_RANDOM_EVENT_NEGATIV_MESSAGE_HEAD_+2",
					"@L_RANDOM_EVENT_NEGATIV_MESSAGE_BODY_+8",cash)

	elseif RandEvent == 9 then
		f_SpendMoney("PlayerSim", cash, "CostSocial")
		MsgNewsNoWait("PlayerSim","PlayerSim","","default",-1,"@L_RANDOM_EVENT_NEGATIV_MESSAGE_HEAD_+2",
					"@L_RANDOM_EVENT_NEGATIV_MESSAGE_BODY_+9",cash)

	elseif RandEvent == 10 then
		if DynastyGetRandomBuilding("PlayerSim",2,-1,"Business") then
			local numWorker = BuildingGetWorkerCount("Business")
			local random = Rand(numWorker)
			local RandWorker = BuildingGetWorker("Business",random,"Worker")
			SetSkillValue("Worker", SkillType, (SkillMod+1))
			MsgNewsNoWait("PlayerSim","Worker","","default",-1,"@L_RANDOM_EVENT_NEGATIV_MESSAGE_HEAD_+1",
						"@L_RANDOM_EVENT_NEGATIV_MESSAGE_BODY_+10",GetID("Worker"),GetID("Business"))
			local HpWorker = GetHP("Worker")
			ModifyHP("Worker", -HpWorker,true)
		end

--[[  elseif RandEvent == 11 then
	  local xpminus = (0-((mod*10)+100))
		IncrementXP("PlayerSim", xpminus)
  	MsgNewsNoWait("PlayerSim","PlayerSim","","default",-1,"@L_RANDOM_EVENT_NEGATIV_MESSAGE_HEAD_+1",
                  "@L_RANDOM_EVENT_NEGATIV_MESSAGE_BODY_+11")
]]--
	elseif RandEvent == 12 then
		chr_SimRemoveFame("PlayerSim",mod)
		MsgNewsNoWait("PlayerSim","PlayerSim","","default",-1,"@L_RANDOM_EVENT_NEGATIV_MESSAGE_HEAD_+1",
					"@L_RANDOM_EVENT_NEGATIV_MESSAGE_BODY_+12")

	elseif RandEvent == 13 then
		chr_SimRemoveImperialFame("PlayerSim",mod)
		MsgNewsNoWait("PlayerSim","PlayerSim","","default",-1,"@L_RANDOM_EVENT_NEGATIV_MESSAGE_HEAD_+1",
					"@L_RANDOM_EVENT_NEGATIV_MESSAGE_BODY_+13")
	end
end

function CleanUp()
end
