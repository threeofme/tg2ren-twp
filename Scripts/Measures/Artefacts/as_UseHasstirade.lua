function Init()
	if not AliasExists("Believer") then
		InitAlias("Believer",MEASUREINIT_SELECTION, "__F( NOT(Object.BelongsToMe())AND(Object.Type == Sim)AND(Object.IsDynastySim()))",
			"@L_ARTEFACTS_184_USEFLOWEROFDISCORD_TARGET2_+0",0)
	end
	MsgMeasure("","")
end

function Run()
	if IsStateDriven() then
		local ItemName = "Hasstirade"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end

	if not AliasExists("Destination") or not AliasExists("Believer") then
	  MsgQuick("","@L_HPFZ_ARTEFAKT_ALLGEMEIN_FEHLER_+0")
		StopMeasure()
	end

	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	if GetID("Believer") == GetID("Destination") then
	  MsgQuick("","@L_HPFZ_ARTEFAKT_ALLGEMEIN_FEHLER_+1")
		StopMeasure()
	end
	
	if not ai_StartInteraction("", "Believer", 800, 120, nil) then
	  MsgQuick("","@L_HPFZ_ARTEFAKT_ALLGEMEIN_FEHLER_+0")
		StopMeasure()
	end
	
	if RemoveItems("","Hasstirade",1) then
		if GetImpactValue("Destination","boozybreathbeer")==1 then	
		GetPosition("Destination", "ParticleSpawnPos")
		StartSingleShotParticle("particles/BoozyBreathBeer.nif", "ParticleSpawnPos",2.7,3)
		PlaySound3DVariation("Destination","measures/boozybreathbeer",1)
		feedback_OverheadComment("",
			"@L_INTRIGUE_055_INSULTCHARACTER_BOOZYBREATHBEER_+0", false, true)
		GetFleePosition("", "Destination", 1000, "Away")
		f_MoveTo("", "Away", GL_MOVESPEED_RUN)
		
		MsgNewsNoWait("","Destination","","intrigue",-1,
			"@L_INTRIGUE_HASSTIRADE_FAILED_ACTOR_HEAD_+0",
			"@L_INTRIGUE_HASSTIRADE_FAILED_ACTOR_BODY_+0", GetID("Destination"))
		
		MsgNewsNoWait("Destination","","","intrigue",-1,
			"@L_INTRIGUE_HASSTIRADE_FAILED_VICTIM_HEAD_+0",
			"@L_INTRIGUE_HASSTIRADE_FAILED_VICTIM_BODY_+0", GetID("Owner"),GetID("Destination"),ItemGetLabel("BoozyBreathBeer", true))			
		StopMeasure()
		end
	
	AlignTo("Owner", "Believer")
	AlignTo("Believer", "Owner")
	Sleep(1)
	
	PlayAnimationNoWait("Owner", "talk")
	Sleep(0.7)
	if SimGetGender("Believer") == 1 then
	  MsgSay("", "@L_HPFZ_ARTEFAKT_TIRADE_SPRUCH_NUTZER_+0")
    Sleep(1)
  else
	  MsgSay("", "@L_HPFZ_ARTEFAKT_TIRADE_SPRUCH_NUTZER_+1")
    Sleep(1)
  end
	PlayAnimationNoWait("Believer", "talk")
	MsgSay("Believer", "@L_HPFZ_ARTEFAKT_TIRADE_SPRUCH_OPFER_+0")
	Sleep(1)
	PlayAnimationNoWait("","use_book_standing")
	Sleep(1)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	CarryObject("","Handheld_Device/Anim_openscroll.nif",false)
	Sleep(2)
	MsgSay("", "@L_HPFZ_ARTEFAKT_TIRADE_SPRUCH_NUTZER_+2")
	PlayAnimationNoWait("Believer", "propel")
	if SimGetGender("Believer") == 1 then
		PlaySound3D("Believer","CharacterFX/male_anger/male_anger+3.ogg", 1.0)	
    Sleep(1)
	else
    PlaySound3D("Believer","CharacterFX/female_anger/female_anger+3.ogg", 1.0)
    Sleep(1)
  end
	if SimGetGender("Destination") == 1 then
		MsgSay("Believer", "@L_HPFZ_ARTEFAKT_TIRADE_SPRUCH_OPFER_+1")
  else
    MsgSay("Believer", "@L_HPFZ_ARTEFAKT_TIRADE_SPRUCH_OPFER_+2")
  end
	Sleep(1)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	CarryObject("","",false)

	MeasureSetNotRestartable()
	SetMeasureRepeat(TimeOut)
	chr_ModifyFavor("Believer","Destination",-100)
	chr_GainXP("",GetData("BaseXP"))
	AddImpact("Destination","BadDay",1,12)
		
		MsgNewsNoWait("","Believer","","intrigue",-1,
				"@L_HPFZ_ARTEFAKT_TIRADE_NUTZER_KOPF_+0",
				"@L_HPFZ_ARTEFAKT_TIRADE_NUTZER_RUMPF_+0",GetID("Believer"),GetID("Destination"))
		MsgNewsNoWait("Destination","Believer","","intrigue",-1,
				"@L_HPFZ_ARTEFAKT_TIRADE_OPFERA_KOPF_+0",
				"@L_HPFZ_ARTEFAKT_TIRADE_OPFERA_RUMPF_+0",GetID("Believer"),GetID(""))
		MsgNewsNoWait("Believer","Destination","","intrigue",-1,
				"@L_HPFZ_ARTEFAKT_TIRADE_OPFERB_KOPF_+0",
				"@L_HPFZ_ARTEFAKT_TIRADE_OPFERB_RUMPF_+0",GetID(""),GetID("Destination"))	
		
	StopMeasure()
	end
end

function CleanUp()
	CarryObject("","",false)
end

function GetOSHData(MeasureID)
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end
