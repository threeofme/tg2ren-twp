function Run()

	if not ai_GetWorkBuilding("", 36, "WorkBuild") then
		StopMeasure() 
		return
	end

	local	TimeOut
	TimeOut = GetData("TimeOut")
	if TimeOut then
		TimeOut = GetGametime() + TimeOut
	end

	if GetMoney("") < 1000 then
		StopMeasure()
	end
	f_SpendMoney("WorkBuild",1000,"CostBribes")
	local MeasureID = GetCurrentMeasureID("")
	local TimeOuti = mdata_GetTimeOut(MeasureID)
  SetMeasureRepeat(TimeOuti)	
--SetRepeatTimer("", GetMeasureRepeatName(), 1)

--while true do	
	if TimeOut then
		if TimeOut < GetGametime() then
			StopMeasure()
		end
	end

	local zielloc = Rand(50)+20
	if not f_MoveTo("","Destination",GL_MOVESPEED_RUN,zielloc) then
		StopMeasure()
	end

  GetPosition("","SetzPos")
  GfxAttachObject("weinfass", "city/Stuff/winecask_02.nif")
	GfxScale("weinfass",0.5)
	GfxSetPositionTo("weinfass", "SetzPos")	

	local duration = mdata_GetDuration(MeasureID)
	local EndTime = GetGametime() + duration		
		
	while GetGametime() < EndTime do
	  local SimFilter = "__F( (Object.GetObjectsByRadius(Sim)==500)AND(Object.HasDynasty())AND NOT(Object.BelongsToMe())AND NOT(Object.HasProperty(GoToBePoisoned))AND NOT(Object.GetState(totallydrunk))AND NOT(Object.GetState(child))AND NOT(Object.GetState(fighting)))"
	  local NumSims = Find("",SimFilter,"Sims",-1)
	  if NumSims > 0 then
	    local DestAlias = "Sims"..Rand(NumSims-1)
	    local empskill = GetSkillValue(DestAlias,EMPATHY)
	    local chakill = GetSkillValue("",CHARISMA)
	    AlignTo("",DestAlias)
	    Sleep(1)
	    local AnimTime = PlayAnimationNoWait("","point_at")
	    MsgSayNoWait("","@L_MEASURE_POISONENEMY_SPRUCH")
	    Sleep(AnimTime)
			if chakill > empskill then
			  SetProperty(DestAlias,"GoToBePoisoned",1)
				CopyAlias("Owner", "Ursupator")
				IncrementXPQuiet("",15)
		    MeasureCreate("PoisonBeer")
		    MeasureStart("PoisonBeer", DestAlias, "Ursupator", "GetPoisonedByBeer")
			end
		end
		Sleep(5)
	end
	GfxDetachAllObjects()
						
--end
	StopMeasure()
end

function CleanUp()

  GfxDetachAllObjects()
	--MoveSetActivity("","")
	StopAnimation("")

end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end
