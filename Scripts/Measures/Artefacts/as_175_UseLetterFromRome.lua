-------------------------------------------------------------------------------
----
----	OVERVIEW "as_175_UseLetterFromRome"
----
----	with this artifact, the player can decrease the favour of all persons in
----	range which have the same religion as the destination
----	
----
-------------------------------------------------------------------------------

function Run()
	if (GetState("", STATE_CUTSCENE)) then
		as_175_useletterfromrome_Cutscene()
	else
		as_175_useletterfromrome_Normal()
	end
end

function Normal()

	if IsStateDriven() then
		local ItemName = "LetterFromRome"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end
	
	--how much the favor of the listeners to the destination is decreased
	local favormodify = 20
	--how much the favor from the victim to the owner is decreased
	local favorloss = 20
	--how far the destination can be to start this action
	local MaxDistance = 1000
	--how far from the destination, the owner should stand while reading the letter from rome
	local ActionDistance = 350
	--the listening range. 
	local ListeningRange = 1200
	--time before artefact can be used again, in hours

	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	if not ai_StartInteraction("", "Destination", MaxDistance, ActionDistance, nil) then
		StopMeasure()
	end
	
	Sleep(0.5)
	
	-- check inside building
	if GetInsideBuilding("Destination","Inside") then
 		MsgBoxNoWait("","Destination","@L_GENERAL_ERROR_HEAD","@L_MEASURE_USE_LETTER_FROM_ROME_ERROR_INSIDE",GetID("Destination"),GetID("Inside"))
		StopMeasure()
	end
	
	--look at each other
	feedback_OverheadActionName("Destination")
	AlignTo("Owner", "Destination")
	AlignTo("Destination", "Owner")
	Sleep(0.5)
	
	--Read the letter
	local Time
	Time = PlayAnimationNoWait("","use_book_standing")
	Sleep(1)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	CarryObject("","Handheld_Device/Anim_openscroll.nif",false)
	Sleep(2)
	local OwnReligion = SimGetReligion("")
	if OwnReligion == 0 then
		MsgSayNoWait("", "@L_PROCLAIM_LETTERFROMROME_CATHOLIC",GetID("Destination"))
	else
		MsgSayNoWait("", "@L_PROCLAIM_LETTERFROMROME_PROTESTANT",GetID("Destination"))
	end
	Sleep(Time+4)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	CarryObject("","",false)
	if RemoveItems("","LetterFromRome",1)>0 then
	
		if GetImpactValue("Destination","boozybreathbeer")==1 then	
			GetPosition("Destination", "ParticleSpawnPos")
			StartSingleShotParticle("particles/BoozyBreathBeer.nif", "ParticleSpawnPos",2.7,3)
			PlaySound3DVariation("Destination","measures/boozybreathbeer",1)
			feedback_OverheadComment("",
				"@L_INTRIGUE_055_INSULTCHARACTER_BOOZYBREATHBEER_+0", false, true)
			GetFleePosition("", "Destination", 1000, "Away")
			f_MoveTo("", "Away", GL_MOVESPEED_RUN)
			
			MsgNewsNoWait("","Destination","","intrigue",-1,
				"@L_INTRIGUE_LETTERFROMROME_FAILED_ACTOR_HEAD_+0",
				"@L_INTRIGUE_LETTERFROMROME_FAILED_ACTOR_BODY_+0", GetID("Destination"))
			
			MsgNewsNoWait("Destination","","","intrigue",-1,
				"@L_INTRIGUE_LETTERFROMROME_FAILED_VICTIM_HEAD_+0",
				"@L_INTRIGUE_LETTERFROMROME_FAILED_VICTIM_BODY_+0", GetID("Owner"),GetID("Destination"),ItemGetLabel("BoozyBreathBeer", true))			
			StopMeasure()
		end
		
		PlayAnimationNoWait("Destination","appal")
		
		GetPosition("", "MyPosition")
		--StartMagicalEffect("MyPosition","particles/aimingpoint.nif",1,0.1,0,ListeningRange)	
		
		--get the religion of the destination
		local i
		local count = Find("Destination","__F((Object.GetObjectsByRadius(Sim) == "..ListeningRange..") AND (Object.HasSameReligion(Destination)))","Listener", -1)
		for i=0,count-1 do 
			if(IsDynastySim("Listener"..i)) then
				feedback_MessageCharacter("Listener"..i,
					"@L_ARTEFACTS_175_USELETTERFROMROME_MSG_LISTENER_HEAD_+0",
					"@L_ARTEFACTS_175_USELETTERFROMROME_MSG_LISTENER_BODY_+0", GetID("Destination"), GetID(""), GetID("Listener"..i))
			end
			if GetSkillValue("Listener"..i, EMPATHY)<=GetSkillValue("", SHADOW_ARTS) then
				chr_ModifyFavor("Listener"..i,"Destination",-favormodify)
				PlayAnimationNoWait("Listener"..i,"nod")
			else
				AddEvidence("Listener"..i,"","Destination",10)
				PlayAnimationNoWait("Listener"..i,"shake_head")
			end
			Sleep(0.5)
			SendCommandNoWait("Listener"..i,"Listen")	
		end
			
		Sleep(Time-7)
	--	Sleep(1)
	
		
		--remove the item, add impact and decrease favor to owner
		
		SetRepeatTimer("", GetMeasureRepeatName2("UseLetterFromRome"), TimeOut)
		
		chr_ModifyFavor("Destination","",-favorloss)
		AddImpact("Destination","BadDay",1,12)
		Sleep(1)
		chr_GainXP("",GetData("BaseXP"))
		
		if GetSkillValue("", SHADOW_ARTS)>=GetSkillValue("Destination", EMPATHY) then
			MsgNewsNoWait("Destination","","","intrigue",-1,
			"@L_ARTEFACTS_175_USELETTERFROMROME_MSG_VICTIM_HEAD_+0",
			"@L_ARTEFACTS_175_USELETTERFROMROME_MSG_VICTIM_BODY_+0", GetID(""), GetID("Destination"))
		else 
		
			MsgNewsNoWait("Destination","","","intrigue",-1,
			"@L_ARTEFACTS_175_USELETTERFROMROME_MSG_VICTIM_HEAD_+0",
			"@L_ARTEFACTS_175_USELETTERFROMROME_MSG_VICTIM_BODY_+1", GetID(""), GetID("Destination"))
			AddEvidence("Destination","","Destination",10)
		end
		Sleep(5)
	end
	StopMeasure()
end

-- -----------------------
-- Listen
-- -----------------------
function Listen()
	Sleep(0.5)
	AlignTo("", "Destination")
	Sleep(Rand(3)+1)
		MsgSayNoWait("", "@L_PROCLAMATION_NEGATIVE")
	PlayAnimation("", "threat")
end





function Cutscene()

	--how much the favor of the listeners to the destination is decreased
	local favormodify = 10
	--how much the favor from the victim to the owner is decreased
	local favorloss = 10
	--how far the destination can be to start this action
	local MaxDistance = 2000
	--how far from the destination, the owner should stand while reading the letter from rome
	local ActionDistance = 350
	--the listening range.
	local ListeningRange = 1000
	--time before artefact can be used again, in hours
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)

--	if not ai_StartInteraction("", "Destination", MaxDistance, ActionDistance, nil) then
--		StopMeasure()
--	end

	Sleep(0.5)


	--get the religion of the destination
	if RemoveItems("","LetterFromRome",1)>0 then
		if GetImpactValue("Destination","boozybreathbeer")==1 then	
		GetPosition("Destination", "ParticleSpawnPos")
		StartSingleShotParticle("particles/BoozyBreathBeer.nif", "ParticleSpawnPos",2.7,3)
		PlaySound3DVariation("Destination","measures/boozybreathbeer",1)
		feedback_OverheadComment("",
			"@L_INTRIGUE_055_INSULTCHARACTER_BOOZYBREATHBEER_+0", false, true)
		GetFleePosition("", "Destination", 1000, "Away")
		f_MoveTo("", "Away", GL_MOVESPEED_RUN)
		
		MsgNewsNoWait("","Destination","","intrigue",-1,
			"@L_INTRIGUE_LETTERFROMROME_FAILED_ACTOR_HEAD_+0",
			"@L_INTRIGUE_LETTERFROMROME_FAILED_ACTOR_BODY_+0", GetID("Destination"))
		
		MsgNewsNoWait("Destination","","","intrigue",-1,
			"@L_INTRIGUE_LETTERFROMROME_FAILED_VICTIM_HEAD_+0",
			"@L_INTRIGUE_LETTERFROMROME_FAILED_VICTIM_BODY_+0", GetID("Owner"),GetID("Destination"),ItemGetLabel("BoozyBreathBeer", true))			
		StopMeasure()
		end
		
		local i
		local count = Find("Destination","__F((Object.GetObjectsByRadius(Sim) == "..ListeningRange..") AND (Object.HasSameReligion(Destination)))","Listener", -1)
		for i=0,count-1 do
			if(IsDynastySim("Listener"..i)) then
				feedback_MessageCharacter("Listener"..i,
					"@L_ARTEFACTS_175_USELETTERFROMROME_MSG_LISTENER_HEAD_+0",
					"@L_ARTEFACTS_175_USELETTERFROMROME_MSG_LISTENER_BODY_+0", GetID("Destination"), GetID(""), GetID("Listener"..i))
			end
			chr_ModifyFavor("Listener"..i,"Destination",-favormodify)
		end
	
	
		--remove the item, add impact and decrease favor to owner
		
		SetRepeatTimer("", GetMeasureRepeatName2("UseLetterFromRome"), TimeOut)
		chr_ModifyFavor("Destination","Owner",-favorloss)
	
		if SimGetCutscene("","cutscene") then
			CutsceneCallUnscheduled("cutscene", "UpdatePanel")
			Sleep(0.1)
		else
			return
		end	
	end	
	StopMeasure()
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	Sleep(1)
	feedback_OverheadActionName("")
	feedback_OverheadActionName("Destination")
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time: immediately
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+1")
end

