function Run()

	if IsStateDriven() then
		local ItemName = "Voodo"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end

	local MaxDistance = 1000
	local ActionDistance = 30
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	if not ai_StartInteraction("", "Destination", MaxDistance, ActionDistance, nil) then
	    MsgQuick("","_HPFZ_ARTEFAKT_ALLGEMEIN_FEHLER_+0")
		StopMeasure()
	end
	
	if RemoveItems("","Voodo",1) > 0 then
	
		MeasureSetNotRestartable()
		SetMeasureRepeat(TimeOut)	
		AlignTo("Owner", "Destination")
		AlignTo("Destination", "Owner")
		Sleep(0.5)

		PlayAnimationNoWait("Owner", "use_object_standing")
		PlayAnimationNoWait("Destination","cogitate")
		Sleep(1)
		PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
		CarryObject("","Handheld_Device/Doll_med_01.nif",false)	
		Sleep(1)
		CarryObject("","",false)
		CarryObject("Destination","Handheld_Device/Doll_med_01.nif",false)
		PlayAnimationNoWait("Destination","fetch_store_obj_R")
		Sleep(1)
		PlaySound3D("Destination","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
		CarryObject("Destination","",false)
		PlayFE("Destination", "smile", 0.5, 2, 0)
		Sleep(1)

		MsgSay("Destination","_HPFZ_ARTEFAKT_VODOO_SPRUCH_+0")
		
		-- Is the victim protected by the amulet?
		if GetImpactValue("Destination","Amulet")>0 then
			PlayAnimation("Destination", "shake_head")
			PlayAnimationNoWait("Destination", "threat")
			MsgSay("Destination", "_HPFZ_ARTEFAKT_FAIL_SPRUCH")
			
			MsgBoxNoWait("","Destination",
						"@L_HPFZ_ARTEFAKT_VODOO_FAILED_NUTZER_KOPF_+0",
						"@L_HPFZ_ARTEFAKT_VODOO_FAILED_NUTZER_AMULET_RUMPF_+0",GetID("Destination"))
			MsgNewsNoWait("Destination","","","intrigue",-1,
						"@L_HPFZ_ARTEFAKT_VODOO_FAILED_OPFER_KOPF_+0",
						"@L_HPFZ_ARTEFAKT_VODOO_FAILED_OPFER_AMULET_RUMPF_+0",GetID(""))
						
			chr_ModifyFavor("Destination","",-10)
			AddEvidence("Destination","Owner","Destination",11)
		else
			if (GetSkillValue("Owner",SHADOW_ARTS) >= GetSkillValue("Destination",EMPATHY)) then
				AddImpact("Destination","BadDay",1,12)
				local DerFluch = Rand(10)
				GetPosition("Destination", "ParticleSpawnPos")
				PlayAnimationNoWait("Destination", "watch_for_guard")
				StartSingleShotParticle("particles/light_smoke.nif", "ParticleSpawnPos",2.7,5)
				Sleep(1)
				PlaySound3D("","Locations/destillery/destillery+1.wav", 1.0)
				MsgSay("Destination", "_HPFZ_ARTEFAKT_VODOO_SPRUCH_+1")
				Sleep(1)
				chr_GainXP("",GetData("BaseXP"))
			
				if DerFluch < 2 then
					AddImpact("Destination","totallydrunk",1,6)
					AddImpact("Destination","MoveSpeed",0.6,6)
					SetState("Destination",STATE_TOTALLYDRUNK,true)
					StopMeasure()
		
				elseif DerFluch < 7 then
					if GetImpactValue("Destination","Sickness")==0 then
						RemoveImpact("Destination", "Resist")
						local SickChoice = Rand(6)+1
						if SickChoice==1 then
							diseases_Sprain("Destination",true,false)
						elseif SickChoice==2 then
							diseases_Cold("Destination",true,false)
						elseif SickChoice==3 then
							diseases_Influenza("Destination",true,false)
						elseif SickChoice==4 then
							diseases_Pox("Destination",true,false)
						elseif SickChoice==5 then
							diseases_Fracture("Destination",true,false)
						elseif SickChoice==6 then
							diseases_Caries("Destination",true,false)
						end
					end
				else
					local FightPartners = Find("Destination", "__F((Object.GetObjectsByRadius(Sim)==3000)AND NOT(Object.HasDynasty())AND NOT(Object.GetState(unconscious))AND NOT(Object.GetState(dead))AND(Object.CompareHP()>30))","FightPartner", -1)
					if FightPartners>0 then
						if not BattleIsFighting("FightPartner0") then
							MsgDebugMeasure("Force a Fight")
							SimStopMeasure("FightPartner0")
							StopAnimation("FightPartner0") 
							MoveStop("FightPartner0")
							AlignTo("Destination","FightPartner0")
							AlignTo("FightPartner0","Destination")
							Sleep(1)
							PlayAnimationNoWait("Destination","threat")
							PlayAnimation("FightPartner0","insult_character")
							SetProperty("FightPartner0","Berserker",1)
							SetProperty("Destination","Berserker",1)
							BattleJoin("Destination","FightPartner0",false,false)
						end
					else
						BattleJoin("Destination","",false,false)
					end
				end
			
				MsgNewsNoWait("","Destination","","intrigue",-1,
					"@L_HPFZ_ARTEFAKT_VODOO_NUTZER_KOPF_+0",
					"@L_HPFZ_ARTEFAKT_VODOO_NUTZER_RUMPF_+0",GetID("Destination"))
				MsgNewsNoWait("Destination","","","intrigue",-1,
					"@L_HPFZ_ARTEFAKT_VODOO_OPFER_KOPF_+0",
					"@L_HPFZ_ARTEFAKT_VODOO_OPFER_RUMPF_+0",GetID(""))
			
			else
				PlayAnimation("Destination", "shake_head")
				PlayAnimationNoWait("Destination", "threat")
				MsgSay("Destination", "_HPFZ_ARTEFAKT_FAIL_SPRUCH")
			
				MsgBoxNoWait("","Destination",
						"@L_HPFZ_ARTEFAKT_VODOO_FAILED_NUTZER_KOPF_+0",
						"@L_HPFZ_ARTEFAKT_VODOO_FAILED_NUTZER_RUMPF_+0",GetID("Destination"))
				MsgNewsNoWait("Destination","","","intrigue",-1,
						"@L_HPFZ_ARTEFAKT_VODOO_FAILED_OPFER_KOPF_+0",
						"@L_HPFZ_ARTEFAKT_VODOO_FAILED_OPFER_RUMPF_+0",GetID(""))
				chr_ModifyFavor("Destination","",-10)
				AddEvidence("Destination","Owner","Destination",11)
			end
		end
	end
end

function CleanUp()
	CarryObject("","",false)
	CarryObject("Destination","",false)
end

function GetOSHData(MeasureID)
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end
