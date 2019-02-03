function Run()

	GetFleePosition("Owner", "Actor", Rand(50)+100, "Away")
	f_MoveTo("Owner", "Away", GL_MOVESPEED_WALK)
	AlignTo("Owner", "Actor")
	Sleep(1)

	if GetProperty("Actor","Signal") == "JugglerTarot" then
	
		local ActionName = GetData("Action_Name")

		if Rand(2) == 0 then
			MsgSayNoWait("Owner","_REN_BEHAVIOUR_GETTAROT_SPRUCH_+0")
		else
			MsgSayNoWait("Owner","_REN_BEHAVIOUR_GETTAROT_SPRUCH_+4")
		end

		ai_GetWorkBuilding("Actor", 102, "Juggler")
		local begbonus = math.floor(GetImpactValue("Juggler",394))
		local spender = SimGetRank("")
		local spend
		local charm = GetSkillValue("Actor", CHARISMA)
		
		if spender == 0 or spender == 1 then
			spend = 3+Rand(4)
		elseif spender == 2 then
			spend = 6+Rand(7)
		elseif spender == 3 then
			spend = 12+Rand(13)
		elseif spender == 4 then
			spend = 24+Rand(25)
		elseif spender == 5 then
			spend = 48+Rand(49)
		end

		local getbeg = math.floor(spend + ((spend / 100) * begbonus))+Rand(10)*charm
		f_CreditMoney("Actor",getbeg,"Offering")
		economy_UpdateBalance("Juggler", "Service", getbeg)
		IncrementXPQuiet("Actor",1)
		if dyn_IsLocalPlayer("Actor") then
			ShowOverheadSymbol("Actor",false,true,0,"%1t",getbeg)
		end
		SatisfyNeed("Owner",5,0.25)

		PlayAnimation("Owner", "manipulate_middle_low_r")
		Sleep(1)
		local getit = Rand(3)
		if getit == 0 then
			if SimGetGender("")==GL_GENDER_MALE then
				PlaySound3DVariation("","CharacterFX/male_neutral",1)
			else
				PlaySound3DVariation("","CharacterFX/female_neutral",1)
			end
			MsgSayNoWait("Owner","_REN_BEHAVIOUR_GETTAROT_SPRUCH_+1")
			PlayAnimation("Owner", "talk_short")
		elseif getit == 1 then
			MsgSayNoWait("Owner","_REN_BEHAVIOUR_GETTAROT_SPRUCH_+2")
			PlayAnimation("Owner", "talk_negative")
		else
			MsgSayNoWait("Owner","_REN_BEHAVIOUR_GETTAROT_SPRUCH_+3")
			PlayAnimation("Owner", "talk_positive")
		end
	else
	
		local ActionName = GetData("Action_Name")

		local intro = Rand(3)
		if intro == 0 then
			MsgSayNoWait("Owner","_REN_BEHAVIOUR_GETFORTUNE_SPRUCH_+0")
		elseif intro == 1 then
			MsgSayNoWait("Owner","_REN_BEHAVIOUR_GETFORTUNE_SPRUCH_+1")
		else
			MsgSayNoWait("Owner","_REN_BEHAVIOUR_GETFORTUNE_SPRUCH_+2")
		end

		ai_GetWorkBuilding("Actor", 102, "Juggler")
		local begbonus = math.floor(GetImpactValue("Juggler",394))
		local spender = SimGetRank("")
		local spend
		local charm = GetSkillValue("Actor", CHARISMA)
   
		if spender == 0 or spender == 1 then
			spend = 10+Rand(6)
		elseif spender == 2 then
			spend = 20+Rand(11)
		elseif spender == 3 then
			spend = 40+Rand(21)
		elseif spender == 4 then
			spend = 80+Rand(41)
		elseif spender == 5 then
			spend = 100+Rand(51)
		end
		
		local getbeg = math.floor(spend + ((spend / 100) * begbonus)+Rand(20)*charm)
		local warte = PlayAnimation("Owner", "manipulate_middle_low_r")
		Sleep(1)
		f_CreditMoney("Actor",getbeg,"Offering")
		economy_UpdateBalance("Juggler", "Service", getbeg)
		IncrementXPQuiet("Actor",2)
		if dyn_IsLocalPlayer("Actor") then
			ShowOverheadSymbol("Actor",false,true,0,"%1t",getbeg)
		end
		SatisfyNeed("Owner",5,0.25)
		Sleep(warte-1)
		
		local getit = Rand(6)
		if getit == 0 then
			MsgSayNoWait("Owner","_REN_BEHAVIOUR_GETFORTUNE_SPRUCH_+8")
			PlayAnimation("Owner", "talk_short")
		elseif getit == 1 then
			if SimGetGender("")==GL_GENDER_MALE then
				PlaySound3DVariation("","CharacterFX/male_anger",1)
			else
				PlaySound3DVariation("","CharacterFX/female_anger",1)
			end
			MsgSayNoWait("Owner","_REN_BEHAVIOUR_GETFORTUNE_SPRUCH_+3")
			PlayAnimation("Owner", "talk_negative")
		elseif getit == 2 then
			if SimGetGender("")==GL_GENDER_MALE then
				PlaySound3DVariation("","CharacterFX/male_rejoice",1)
			else
				PlaySound3DVariation("","CharacterFX/female_rejoice",1)
			end
			MsgSayNoWait("Owner","_REN_BEHAVIOUR_GETFORTUNE_SPRUCH_+4")
			PlayAnimation("Owner", "giggle")
		elseif getit == 3 then
			MsgSayNoWait("Owner","_REN_BEHAVIOUR_GETFORTUNE_SPRUCH_+5")
			PlayAnimation("Owner", "shake_head")
		elseif getit == 4 then
			MsgSayNoWait("Owner","_REN_BEHAVIOUR_GETFORTUNE_SPRUCH_+6")
			PlayAnimation("Owner", "talk_short")
		else
			if SimGetGender("")==GL_GENDER_MALE then
				PlaySound3DVariation("","CharacterFX/male_friendly",1)
			else
				PlaySound3DVariation("","CharacterFX/female_friendly",1)
			end
			MsgSayNoWait("Owner","_REN_BEHAVIOUR_GETFORTUNE_SPRUCH_+7")
			PlayAnimation("Owner", "talk_positive")
		end	
		
	end

end
