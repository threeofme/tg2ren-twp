function Run()

	if IsStateDriven() then
		local ItemName = "HexerdokumentII"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end

	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	if RemoveItems("","HexerdokumentII", 1) > 0 then
		MeasureSetNotRestartable()
		SetMeasureRepeat(TimeOut)
		-- Is the victim protected?
		if GetImpactValue("Destination","Knochenarmreif")>0 then
			
			-- send a message to the victim	
			MsgNewsNoWait("Destination","Destination","","intrigue",-1,
					"@L_HEXERDOKUMENT_VICTIM_PROTECT_HEAD_+0",
					"@L_HEXERDOKUMENT_VICTIM_PROTECT_BODY_+0",GetID("Destination"),GetID("Owner"))
			-- fail msg to the villain
				MsgBoxNoWait("Owner","Destination",
					"@L_HEXERDOKUMENT_VILLAIN_FAIL_HEAD_+0",
					"@L_HEXERDOKUMENT_VILLAIN_FAIL_BODY_+0",GetID("Destination"))	
		else
			-- create evidence
			while true do
				ScenarioGetRandomObject("cl_Sim","CurrentRandomSim")
				if GetDynasty("CurrentRandomSim","CDynasty") then
					CopyAlias("CurrentRandomSim","EvidenceVictim")
					break
				end
				Sleep(2)
			end
			
			for k=1,2 do
				local Evidence
				local Random = Rand(11)
				if Random == 0 then
					Evidence = 1
				elseif Random == 1 then
					Evidence = 4
				elseif Random == 2 then
					Evidence = 7
				elseif Random == 3 then
					Evidence = 10
				elseif Random == 4 then
					Evidence = 11
				elseif Random == 5 then
					Evidence = 12
				elseif Random == 6 then
					Evidence = 13
				elseif Random == 7 then
					Evidence = 14
				elseif Random == 8 then
					Evidence = 15
				elseif Random == 9 then
					Evidence = 16
				else
					Evidence = 18
				end
				AddEvidence("Owner","Destination","EvidenceVictim",Evidence)
				AddImpact("Destination","BadDay",1,12)
			end
			-- animation	
			GetPosition("", "ParticleSpawnPos")
			PlayAnimation("","watch_for_guard")
			PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
			CarryObject("","Handheld_Device/ANIM_openscroll.nif",false)
			Sleep(1)
			PlayAnimationNoWait("","pray_standing")
			if SimGetGender("") == 1 then
				PlaySound3DVariation("", "CharacterFX/male_neutral")
			else
				PlaySound3DVariation("", "CharacterFX/female_neutral")
			end
			Sleep(5)
			StartSingleShotParticle("particles/rage.nif", "ParticleSpawnPos",1,5)
			PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
			Sleep(1)
			CarryObject("","",false)
			chr_GainXP("Owner",GetData("BaseXP"))
			Sleep(0.5)
			-- send a message to the victim	
			if GetSkillValue("Destination", EMPATHY)>=GetSkillValue("", SHADOW_ARTS) then
				MsgNewsNoWait("Destination","Destination","","intrigue",-1,
					"@L_HEXERDOKUMENT_VICTIM_HEAD_+0",
					"@L_HEXERDOKUMENT_VICTIM_BODY_+0")
			end
			-- success msg to the villain
				MsgBoxNoWait("Owner","Destination",
					"@L_HEXERDOKUMENT_VILLAIN_HEAD_+0",
					"@L_HEXERDOKUMENT_VILLAIN_BODY_+0",GetID("Destination"))	
		end
	end
end

function CleanUp()
	StopAnimation("")
	CarryObject("","",false)
end

function GetOSHData(MeasureID)
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end
