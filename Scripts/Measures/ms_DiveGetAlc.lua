function AIDecide()

    if BuildingHasUpgrade("",6124) and Rand(2) == 0 then
	    return "B"
	else
	    return "A"
	end

end

function Run()
	local Money = GetMoney("") 
	
	if Money < 700 then
		MsgQuick("","@L_MEASURES_DIVEGETALC_FAIL_+2")
		StopMeasure()
	end	

	local cashskill = 0
	local secretskill = 0
	if BuildingGetOwner("","Besitzer") then
		cashskill = GetSkillValue("Besitzer", BARGAINING)
		secretskill = GetSkillValue("Besitzer", SECRET_KNOWLEDGE)
	else
		StopMeasure()
 	end

	local menge = secretskill * 10
	-- reduce by 2% per point in Bargaining
	local kostengrog = 700 - (14 * cashskill)
	local kostenbrand = 1200 - (24 * cashskill)
	local wahltext = ""
	local bodytext = ""
  if BuildingHasUpgrade("",6124) == true then
	  bodytext = bodytext.."@L_MEASURES_DIVEGETALC_BODY_+4"
	  wahltext = wahltext.."@B[A,@L_MEASURES_DIVEGETALC_BODY_+2]@B[B,@L_MEASURES_DIVEGETALC_BODY_+3]"
	else
	  bodytext = bodytext.."@L_MEASURES_DIVEGETALC_BODY_+0"
	  wahltext = wahltext.."@B[A,@L_MEASURES_DIVEGETALC_BODY_+2]"
	end
  wahltext = wahltext.."@B[C,@L_MEASURES_DIVEGETALC_BODY_+1]"
	
	local sauf
  if IsGUIDriven() then
    sauf = MsgBox("",false,"@P"..
    wahltext,
    "@L_MEASURES_DIVEGETALC_HEAD_+0",
    bodytext,kostengrog,kostenbrand)
	else
    sauf = ms_divegetalc_AIDecide()
	end
	
	local preis
	local alcId
		
	if sauf == "B" then
		alcId = "Schadelbrand"
		preis = kostenbrand
	elseif sauf == "A" then
		alcId = "PiratenGrog"
		preis = kostengrog
	else
	  StopMeasure()
	end

	if not CanAddItems("",alcId,menge,INVENTORY_STD) then
		MsgQuick("","@L_MEASURES_DIVEGETALC_FAIL_+3")
		StopMeasure()
	end
	
	if not f_SpendMoney("",preis,"CostBribes") then
		MsgQuick("","@L_MEASURES_DIVEGETALC_FAIL_+2")
		StopMeasure()
	end
	
	AddItems("",alcId,menge,INVENTORY_STD)
	MsgQuick("","@L_MEASURES_DIVEGETALC_SUCCESS_+0")

  local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
  SetMeasureRepeat(TimeOut)
	
end

function CleanUp()

end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end
