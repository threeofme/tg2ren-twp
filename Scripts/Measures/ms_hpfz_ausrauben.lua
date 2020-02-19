function Run()


	local TimeToWait = 16
	local Value
	local	TimeOut
	TimeOut = GetData("TimeOut")
	if TimeOut then
		TimeOut = GetGametime() + TimeOut
	end
	
	if not SimGetWorkingPlace("","MyHome") then
		if IsPartyMember("") then
			local NextBuilding = ai_GetNearestDynastyBuilding("",GL_BUILDING_CLASS_WORKSHOP,GL_BUILDING_TYPE_THIEF)
			if not NextBuilding then
				StopMeasure()
			end
			CopyAlias(NextBuilding,"MyHome")
		else
			StopMeasure()
		end
	end

	if not f_MoveTo("","Destination") then
	    StopMeasure()
	end	

	CarryObject("Owner", "weapons/club_01.nif", false)
    GetPosition("","standPos")
	PlayAnimationNoWait("","crouch_down")
	Sleep(1)
	local filter ="__F((Object.GetObjectsByRadius(Building)==1000))"
	local k = Find("",filter,"Umgebung",15)
	if k > 0 then
	    if Rand(2) == 0 then
	        GfxAttachObject("tarn","Outdoor/Haystack3.nif")
		else
		    GfxAttachObject("tarn","Handheld_Device/barrel_new.nif")
        end
	else
	    if Rand(2) == 0 then
	        GfxAttachObject("tarn","Outdoor/Bushes/bush_09_big.nif")
		else
	        GfxAttachObject("tarn","Outdoor/Bushes/bush_10_big.nif")
		end
	end
	GfxSetPositionTo("tarn","standPos")
	SetState("", STATE_INVISIBLE, true)
	SetData("Getarnt",1)
	
	while true do
		if TimeOut then
			if TimeOut < GetGametime() then
				break
			end
		end
		local NumTreffer = Find("standPos","__F( (Object.GetObjectsByRadius(Sim)==1000) AND NOT(Object.BelongsToMe()) AND NOT(Object.HasImpact(HaveBeenAusraubed)) AND NOT(Object.GetState(cutscene))AND NOT(Object.GetProfession() == 21)AND NOT(Object.GetProfession() == 25)AND NOT(Object.GetState(townnpc))AND(Object.MinAge(16)))","Sims",-1)
		if NumTreffer>0 then
			local DestAlias = "Sims"..Rand(NumTreffer-1)
			local DoIt = 1
			if GetCurrentMeasureName(DestAlias)=="AttendMass" then 
				DoIt = 0	
			end
			if IsPartyMember(DestAlias) then
				DoIt = 0
			end
			local VictimSkill		
			if IsDynastySim(DestAlias) then 
				VictimSkill = GetSkillValue(DestAlias,EMPATHY)
			else
				VictimSkill = Rand(6) + 1
			end
			if DoIt==1 then
				if SendCommandNoWait(DestAlias, "BlockMe") then 
					if CheckSkill("",2,VictimSkill) then
						SetData("Blocked", 1)
						SimBeamMeUp("","standPos",false)
	                    GfxDetachObject("tarn")	
                        SetState("", STATE_INVISIBLE, false)
						SetData("Getarnt",0)
						f_MoveTo("Owner", DestAlias, GL_MOVESPEED_RUN, 130)
						AlignTo("Owner", DestAlias)
						Sleep(0.7)
						PlayAnimationNoWait("Owner", "attack_top")
						Sleep(1)
						PlaySound3DVariation(DestAlias,"Effects/combat_strike_mace",1)
		                if SimGetGender(DestAlias) == GL_GENDER_MALE then
		                   PlaySound3DVariation(DestAlias, "CharacterFX/male_pain_short", 1)
	                    else
		                   PlaySound3DVariation(DestAlias, "CharacterFX/female_pain_short", 1)
	                    end
                        local HpFeind = GetHP(DestAlias)
	                    local HPModify = ((HpFeind / 100) * 20)
	                    ModifyHP(DestAlias, -HPModify,true)
						SetData("Blocked", 0)
	                    SetState(DestAlias,STATE_UNCONSCIOUS,true)
		                local anim = PlayAnimationNoWait("Owner","fight_store_weapon")
						Sleep(2)
		                CarryObject("Owner", "", false)	
                        Sleep(anim-2)						
						PlayAnimationNoWait("Owner", "manipulate_bottom_r")
						if AddImpact(DestAlias,"HaveBeenAusraubed",1,TimeToWait) then
							CommitAction("rob", "", "", DestAlias)
						    Plunder("Owner", "Destination", 8)
						    local PiratLevel = SimGetLevel("")
						    local Beute = Rand(40) + 200 + PiratLevel * 20
						
						    if Rand(100 ) > (100-PiratLevel*2) then
							    Beute = Beute*3
						    end
						
						    chr_RecieveMoney("Owner", Beute, "IncomeThiefs")
						    if dyn_IsLocalPlayer("") then
							    PlaySound3D("","Effects/coins_to_moneybag+0.wav", 1.0)
						    end
						
						    if IsPartyMember(DestAlias) then						
							    local Value = GetMoney(DestAlias) * 0.05
							    if Beute > Value then
								    Beute = Value
							    end
							    f_SpendMoney(DestAlias, Beute)
							
							    if Beute>25 then
								    feedback_MessageCharacter(DestAlias,
									"@L_THIEF_068_PICKPOCKETPEOPLE_MSG_VICTIM_HEAD_+0",
									"@L_THIEF_068_PICKPOCKETPEOPLE_MSG_VICTIM_BODY_+0",GetID(DestAlias), VictimSpendValue)
							    end
						    end
						end
						Sleep(0.75)
						local flucht = (GetSkillValue("",6)+GetSkillValue("",2))
						if flucht == nil then
						    flucht = 0
						end
						if Rand(40-flucht) <= 10 then
						    StopAction("rob","")
						end
						if not f_MoveTo("","MyHome",GL_MOVESPEED_RUN) then
						    StopMeasure()
						end
						StopAction("rob","")

							local	ItemId
	                        local	Found
	                        local RemainingSpace
	                        local Removed
	                        local Count = InventoryGetSlotCount("", INVENTORY_STD)
	                        for i=0,Count-1 do
		                        ItemId, Found = InventoryGetSlotInfo("", i, INVENTORY_STD)
		                        if ItemId and ItemId>0 and Found>0 then
			                        RemainingSpace	= GetRemainingInventorySpace("Workbuilding",ItemId)
			                        Removed		= RemoveItems("", ItemId, RemainingSpace)
			                        if Removed>0 then
				                        AddItems("Workbuilding", ItemId, Removed)
			                        end									
		                        end
	                        end
						Sleep(50)
						if f_MoveTo("","Destination",GL_MOVESPEED_WALK,50) then
                            GetPosition("","standPos")
	                        PlayAnimationNoWait("","crouch_down")
	                        Sleep(1)
	                        k = Find("",filter,"Umgebung",15)
	                        if k > 0 then
	                            if Rand(2) == 0 then
	                                GfxAttachObject("tarn","Outdoor/Haystack3.nif")
		                        else
		                        GfxAttachObject("tarn","Handheld_Device/barrel_new.nif")
                                end
	                        else
	                            if Rand(2) == 0 then
	                                GfxAttachObject("tarn","Outdoor/Haystack3.nif")
		                        else
	                                GfxAttachObject("tarn","Outdoor/Bushes/bush_10_big.nif")
		                        end
	                        end
	                        GfxSetPositionTo("tarn","standPos")
							SetState("", STATE_INVISIBLE, true)
							SetData("Getarnt",1)
						end
					else
						SetData("Blocked", 1)
						SimBeamMeUp("","standPos",false)
	                    GfxDetachObject("tarn")	
                        SetState("", STATE_INVISIBLE, false)
						SetData("Getarnt",0)
						f_MoveTo("", DestAlias, GL_MOVESPEED_RUN, 140)
						AlignTo("Owner", DestAlias)
						AddImpact(DestAlias,"HaveBeenAusraubed",1,TimeToWait)
						AlignTo(DestAlias, "Owner")
						Sleep(1)
							chr_ModifyFavor(DestAlias,"",-20)
							if (GetSkillValue("Owner",SHADOW_ARTS) <= GetSkillValue("Destination",EMPATHY)) then
							    CommitAction("rob", "", "", DestAlias)
							end
							feedback_OverheadComment(DestAlias,
								"@L_THIEF_068_PICKPOCKETPEOPLE_SCREAM_+0", false, true)
						    SetData("Blocked", 0)
						    GetFleePosition(DestAlias,"Owner", 1000, "FluchtPoint")
							CarryObject("Owner", "", false)
							if Rand(40-flucht) <= 10 then
						        StopAction("rob","")
						    end
			                f_MoveTo(DestAlias, "FluchtPoint", GL_MOVESPEED_RUN)
							StopAction("rob","")
							if not f_MoveTo("","MyHome",GL_MOVESPEED_RUN) then
							    StopMeasure()
							end

							local	ItemId
	                        local	Found
	                        local RemainingSpace
	                        local Removed
	                        local Count = InventoryGetSlotCount("", INVENTORY_STD)
	                        for i=0,Count-1 do
		                        ItemId, Found = InventoryGetSlotInfo("", i, INVENTORY_STD)
		                        if ItemId and ItemId>0 and Found>0 then
			                        RemainingSpace	= GetRemainingInventorySpace("Workbuilding",ItemId)
			                        Removed		= RemoveItems("", ItemId, RemainingSpace)
			                        if Removed>0 then
				                        AddItems("Workbuilding", ItemId, Removed)
			                        end									
		                        end
	                        end
							Sleep(50)
							if f_MoveTo("","Destination",GL_MOVESPEED_WALK,50) then
                                GetPosition("","standPos")
	                            PlayAnimationNoWait("","crouch_down")
	                            Sleep(1)
	                            k = Find("",filter,"Umgebung",15)
	                            if k > 0 then
	                                if Rand(2) == 0 then
	                                    GfxAttachObject("tarn","Outdoor/Haystack3.nif")
		                            else
		                                GfxAttachObject("tarn","Handheld_Device/barrel_new.nif")
                                    end
	                            else
	                                if Rand(2) == 0 then
	                                    GfxAttachObject("tarn","Outdoor/Haystack3.nif")
		                            else
	                                    GfxAttachObject("tarn","Outdoor/Bushes/bush_10_big.nif")
		                            end
	                            end
	                            GfxSetPositionTo("tarn","standPos")
								SetState("", STATE_INVISIBLE, true)
								SetData("Getarnt",1)
							end
					end
				end
			end	
        end
		Sleep(3)
	end
end

function BlockMe()
	while GetData("Blocked")==1 do
		Sleep(Rand(10)*0.1+0.5)
	end
end


function CleanUp()
    CarryObject("", "", false)	
    GfxDetachAllObjects()	
	if GetData("Getarnt") == 1 then
	    SimBeamMeUp("","standPos",false)
        SetState("", STATE_INVISIBLE, false)
	end
	StopAction("rob","")
	MoveStop("")
end

