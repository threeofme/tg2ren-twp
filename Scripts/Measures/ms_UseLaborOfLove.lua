function Run()
	
	if not AliasExists("Destination") then
		StopMeasure()
	end
	
	SetProperty("Destination","CocotteHasClient",1)

	MeasureSetNotRestartable()

	if not AliasExists("Destination") then
		return
	end	

	if not ai_StartInteraction("", "Destination", 500, 66) then
		StopMeasure("")
	end

	chr_AlignExact("","Destination",50,1)
	if (GetDynastyID("") == GetDynastyID("Destination")) then
		MsgSay("","@L_PIRATE_LABOROFLOVE_VISIT_EMPLOYER")
		MsgSay("Destination","@L_PIRATE_LABOROFLOVE_VISIT_COCOTTE")
	else	
		-- Todo Cutscene Speech and Animation
		MsgSay("","@L_PIRATE_LABOROFLOVE_TALK_VICTIM")
		MsgSay("Destination","@L_PIRATE_LABOROFLOVE_TALK_AGREED")
	
		-- calc price depending on the charisma of the cocotte and pay it
		local charskill = 2
		charskill = GetSkillValue("Destination",CHARISMA)
		local MoneyToPay = 25 + 25*charskill
		if IsDynastySim("") then
			if not SpendMoney("",500 ,"LaborOfLove") then
				PlayAnimationNoWait("Destination","threat")
				MsgSay("Destination","@L_PIRATE_LABOROFLOVE_TALK_DISAGREE")
				StopMeasure()
			end
			ShowOverheadSymbol("",false,false,0,"%1t",-500)
		end
		CreditMoney("Destination", MoneyToPay , "LaborOfLove")
		SimGetWorkingPlace("Destination", "WorkingPlace")
		economy_UpdateBalance("WorkingPlace", "Service", MoneyToPay)
		
	end
	
	if IsDynastySim("") then
		local MeasureID = GetCurrentMeasureID("")
		local TimeOut = mdata_GetTimeOut(MeasureID)
		SetMeasureRepeat(TimeOut)
	end
	
	MsgSay("","@L_PIRATE_LABOROFLOVE_TALK_START")
	
	-- Do some animation
	PlayAnimationNoWait("","seduce_m_in")
	PlayAnimation("Destination","seduce_f_in")
	PlaySound3DVariation("Destination","CharacterFX/female_jolly",1)
	LoopAnimation("","seduce_m_idle_01",0)
	PlaySound3DVariation("","CharacterFX/male_jolly",1)
	LoopAnimation("Destination","seduce_f_idle_03",10)
	PlayAnimationNoWait("","seduce_m_out")
	PlayAnimation("destination","seduce_f_out")
	
	if HasProperty("Destination","ThiefOfLove") then
	
		local empskill = GetSkillValue("","EMPATHY")
		local chakill = GetSkillValue("Destination","CHARISMA")
		local spender = SimGetRank("")
		local spend
		
		if spender == 0 or spender == 1 then
			spend = 25 * chakill
		elseif spender == 2 then
			spend = 30 * chakill
		elseif spender == 3 then
			spend = 35 * chakill
		elseif spender == 4 then
			spend = 40 * chakill
		elseif spender >= 5 then
			spend = 50 * chakill
		end
	
		CreditMoney("Destination",spend,"LaborOfLove")
		SimGetWorkingPlace("Destination", "WorkingPlace")
		economy_UpdateBalance("WorkingPlace", "Service", MoneyToPay)
		IncrementXPQuiet("Destination",10)
	end
	
	-- process the boost Fajeth_Mod: Better Boosts
	local HeaderLabel = "@L_PIRATE_LABOROFLOVE_MSG_HEAD_+0"
	local Idx = Rand(8)
	if(Idx == 0) then
    -- + 50 Hitpoints
		ModifyHP("",50)
		if IsPartyMember("") then
			feedback_MessageCharacter("",HeaderLabel,"@L_PIRATE_LABOROFLOVE_MSG_BODY_+0")
		end
		IncrementXP("",100)
	elseif(Idx == 1) then
    -- - 50 Hitpoints
		ModifyHP("",-50,true,10)
		IncrementXP("",100)
		if IsPartyMember("") then
			feedback_MessageCharacter("",HeaderLabel,"@L_PIRATE_LABOROFLOVE_MSG_BODY_+1")
		end
	elseif(Idx == 2) then
    -- + 2 Random Skill
		IncrementXP("",100)
		local Skill = Rand(10) + 20
		AddImpact("",Skill,2,2)
		if IsPartyMember("") then
			feedback_MessageCharacter("",HeaderLabel,"@L_PIRATE_LABOROFLOVE_MSG_BODY_+2")
		end
	elseif(Idx == 3) then
	  -- - 2 Random Skill
		IncrementXP("",100)
		local Skill = Rand(10) + 20
		AddImpact("",Skill,-2,2)
		if IsPartyMember("") then
			feedback_MessageCharacter("",HeaderLabel,"@L_PIRATE_LABOROFLOVE_MSG_BODY_+3")
		end
	elseif(Idx == 4) then
	  -- Influenza infection
		IncrementXP("",100)
		diseases_Influenza("",true,true)
	elseif(Idx == 5)  then
	  -- decreaset movespeed
		IncrementXP("",100)
		AddImpact("","MoveSpeed",0.8,2)
		if IsPartyMember("") then
			feedback_MessageCharacter("",HeaderLabel,"@L_PIRATE_LABOROFLOVE_MSG_BODY_+4")
		end
	elseif(Idx == 6) then
	  -- increase movespeed
		AddImpact("","MoveSpeed",1.25,6)
		IncrementXP("",100)
		if IsPartyMember("") then
			feedback_MessageCharacter("",HeaderLabel,"@L_PIRATE_LABOROFLOVE_MSG_BODY_+5")
		end
	elseif(Idx == 7) then
	  -- increase XP
		IncrementXP("",500)
		if IsPartyMember("") then
			feedback_MessageCharacter("",HeaderLabel,"@L_PIRATE_LABOROFLOVE_MSG_BODY_+6")
		end
	end
	-- satisfy the pleasure need
	SatisfyNeed("", 2, 0.5)

	MsgSay("Destination","@L_PIRATE_LABOROFLOVE_TALK_END")
	AddImpact("","FullOfLove",1,4)
	--DestroyCutscene("cutscene")
	StopMeasure()
end

function CleanUp()
	StopAnimation("")
	--DestroyCutscene("cutscene")
	if AliasExists("Destination") then
		--MoveSetStance("Destination",GL_STANCE_STAND)
		StopAnimation("Destination")
	  	SetProperty("Destination","CocotteHasClient",0)
	end	
end

function GetOSHData(MeasureID)
	OSHSetMeasureCost("@L_INTERFACE_HEADER_+6",500)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end


