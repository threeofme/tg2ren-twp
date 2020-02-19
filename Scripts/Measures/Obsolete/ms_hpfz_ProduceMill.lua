function Brunnen()
    SetData("Cleaner","Brunnen")

    while true do
        local platzSim = GetRemainingInventorySpace("",943,INVENTORY_STD)
        local platzGeb = GetRemainingInventorySpace("WorkBuilding",943,INVENTORY_STD)
        if platzSim < 5 then
            MsgQuick("","_HPFZ_PRODUCENEKRO_FEHLER_+0")
		    StopMeasure()
	    end
	    if platzGeb < 5 then
	        MsgQuick("","_HPFZ_PRODUCENEKRO_FEHLER_+1")
		    StopMeasure()
	    end

        GetNearestSettlement("","NaherBrunnen")
        CityGetNearestBuilding("NaherBrunnen","",3,24,-1,-1,FILTER_IGNORE,"Brunnen")
        CarryObject("","Handheld_Device/ANIM_Bucket.nif",false)
        CarryObject("","Handheld_Device/ANIM_Bucket_L.nif",true)
        if not f_MoveTo("","Brunnen",GL_MOVESPEED_RUN,50) then
		    MsgQuick("","_HPFZ_PRODUCEMILL_FEHLER_+0")
		    StopMeasure()
		end
        CarryObject("","",false)
        CarryObject("","",true)
        PlayAnimation("","manipulate_middle_twohand")
        AddItems("",943,5,INVENTORY_STD)
        MoveSetActivity("","sick")
        CarryObject("","Handheld_Device/ANIM_Bucket_full.nif",false)
        CarryObject("","Handheld_Device/ANIM_Bucket_L_full.nif",true)
        if not f_MoveTo("","WorkBuilding",GL_MOVESPEED_WALK,50) then
		    MsgQuick("","_HPFZ_PRODUCEMILL_FEHLER_+1")
			StopMeasure()
		end
        CarryObject("","",false)
        CarryObject("","",true)
        TransferItems("","WorkBuilding")
        MoveSetActivity("","")
		Sleep(2)
    end

end

function Muehle()
    SetData("Cleaner","Muehle")
    local i = 1

    while true do
	    GetPosition("WorkBuilding","GehPunkt")
	    f_MoveTo("","GehPunkt")
        SetState("", STATE_INVISIBLE, true)
		Sleep(1)
		PlaySound3D("WorkBuilding","Cart/CartRumbling_r_01.wav",1.0)
        GfxMoveToPosition("WorkBuilding", 0, -1, 0, 10, false)
		PlaySound3D("WorkBuilding","Cart/CartRumbling_r_01.wav",1.0)
	    GfxMoveToPosition("WorkBuilding", 0, 1, 0, 10, false)
	    SimBeamMeUp("","GehPunkt",false)
        SetState("", STATE_INVISIBLE, false)
        MoveSetActivity("","carry")
		Sleep(2)
        CarryObject("","Handheld_Device/ANIM_Bag.nif",false)
		GetLocatorByName("WorkBuilding","Entry1","Ablage")		
		GetPosition("WorkBuilding","GehPunkt")
		if not f_MoveTo("","Ablage",GL_MOVESPEED_WALK) then
		    MsgQuick("","_HPFZ_PRODUCEMILL_FEHLER_+2")
			StopMeasure()
		end
		local spruch = Rand(4)
		if spruch == 1 then
            MsgSay("","_HPFZ_PRODUCEMILL_SPRUCH_+0")
		elseif spruch == 2 then
		    MsgSay("","_HPFZ_PRODUCEMILL_SPRUCH_+1")
		elseif spruch == 3 then
		    MsgSay("","_HPFZ_PRODUCEMILL_SPRUCH_+2")
		else
		    MsgSay("","_HPFZ_PRODUCEMILL_SPRUCH_+3")
		end
		MoveSetActivity("","")
		Sleep(2)
        CarryObject("","",false)
		MoveSetActivity("","")
		if i < 6 then
		    if i > 1 then
			    GfxDetachObject("mehlsack"..(i-1))
			end
            GfxAttachObject("mehlsack"..i, "Locations/Bakery/FlourPack_closed"..i..".nif")
            GfxSetPositionTo("mehlsack"..i, "Ablage")
			i = i + 1
		elseif i == 6 then
		    GfxDetachObject("mehlsack"..(i-1))
			i = 1
		end
        if not f_MoveTo("","GehPunkt",GL_MOVESPEED_WALK) then
		    MsgQuick("","_HPFZ_PRODUCEMILL_FEHLER_+1")
			StopMeasure()
		end
		RemoveAlias("GehPunkt")
	end
end

function CleanUp()
  local check = GetData("Cleaner")
  if check == "Muehle" then
	GfxDetachAllObjects()
	if GetState("",39) == true then
        SimBeamMeUp("","WorkBuilding",false)
        SetState("", STATE_INVISIBLE, false)
	end
	RemoveAlias("GehPunkt")
  end
  	MoveSetActivity("","")
    CarryObject("","",false)
    CarryObject("","",true)
end

