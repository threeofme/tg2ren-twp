function Run()

	if IsStateDriven() then
		local ItemName = "optigold"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end

	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)

	MeasureSetNotRestartable()
	SetMeasureRepeat(TimeOut)	
	local Time = PlayAnimationNoWait("","use_book_standing")
	Sleep(1)
	CarryObject("","Handheld_Device/ANIM_openscroll.nif",false)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+0.wav", 1.0)
	Sleep(Time-2)
	CarryObject("","",false)
	PlaySound3D("","Effects/coins_to_moneybag+0.wav", 1.0)

	RemoveItems("","optigold",1)
	GetPosition("Owner", "ParticleSpawnPos")
	StartSingleShotParticle("particles/sparkle_talents.nif", "ParticleSpawnPos",1,5)
	local GeheimW = GetSkillValue("",10)
	local Feils = GetSkillValue("",9)
    local Ertrag = math.floor((GeheimW * Feils) / 2)

	if not GetInsideBuilding("", "Lager") then
	    GetHomeBuilding("","Lager")
	end
    AddItems("Lager","Gold",Ertrag)
    local item = "_ITEM_Gold_NAME_+0"
	MsgNewsNoWait("","Lager","","economie",-1,
				"@L_HPFZ_ARTEFAKT_OPTSCH_NUTZER_KOPF_+0",
				"@L_HPFZ_ARTEFAKT_OPTSCH_NUTZER_RUMPF_+0",GetID("Lager"),Ertrag,item)
				
	StopMeasure()
	
end

function CleanUp()
	StopAnimation("")
	CarryObject("","",false)
end

function GetOSHData(MeasureID)
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end
