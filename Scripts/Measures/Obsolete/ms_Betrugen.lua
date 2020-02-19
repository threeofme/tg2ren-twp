function Run()

	if not ai_GetWorkBuilding("", 43, "Bank") then
		StopMeasure() 
		return
	end
	if GetItemCount("", "Urkunde")<1 then
		MsgSay("","_HPFZ_BETRUGEN_FEHLER_+1")
        StopMeasure() 
	end
    MeasureSetStopMode(STOP_NOMOVE)
	if IsStateDriven() then

		if not GetSettlement("Bank", "City") then
			return
		end

		if CityFindCrowdedPlace("City", "", "Destination")==0 then
			return
		end
	end	

	SetData("IsProductionMeasure", 0)
	SimSetProduceItemID("", -GetCurrentMeasureID(""), -1)
	SetData("IsProductionMeasure", 1)
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	SetMeasureRepeat(TimeOut)
	
	while GetItemCount("", "Urkunde")>0 do
		
		if not f_MoveTo("","Destination") then
			StopMeasure()
		end

		local EndTime = GetGametime() + duration
		
	    GetPosition("","MovePos")
	    GfxAttachObject("betrugtisch", "city/Stuff/betraytable.nif")
	    GfxSetPositionTo("betrugtisch", "MovePos")	
		CommitAction("betrugen", "", "")
		while GetGametime() < EndTime do
		
			if GetItemCount("", "Urkunde")<1 then
		    MsgSay("","_HPFZ_BETRUGEN_FEHLER_+1")
				break
			end
			if SimGetGender("")==GL_GENDER_MALE then
				PlaySound3DVariation("","CharacterFX/male_jolly",1)
			else
				PlaySound3DVariation("","CharacterFX/female_jolly",1)
			end
            CarryObject("", "Handheld_Device/ANIM_openscroll.nif", false)
			PlayAnimation("","use_book_standing")
            Sleep(1)
			PlayAnimation("","preach")
	        CarryObject("", "", false)
			Sleep( 1 + 0.1*Rand(20) )
		end
		GfxDetachAllObjects()
		StopAction("betrugen", "")
	end
	
	StopMeasure()
end

function CleanUp()
	CarryObject("", "", false)
	GfxDetachAllObjects()
	StopAnimation("")
	StopAction("betrugen", "")
end

function GetOSHData(MeasureID)
	--can be used again in:
	--OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end


