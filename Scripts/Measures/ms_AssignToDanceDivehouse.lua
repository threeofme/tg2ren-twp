-- -----------------------
-- Run
-- -----------------------
-- ******** THANKS TO KINVER ********
function Run()

	


	if not SimGetWorkingPlace("","Divehouse") then
		if IsPartyMember("") then
			--if not SimGetGender("") == GENDER_MALE then
				

					if not GetInsideBuilding("", "CurrentBuilding") then
						StopMeasure()
					end
					if BuildingGetType("CurrentBuilding")==36 then
						CopyAlias("CurrentBuilding", "Divehouse")
					else
						StopMeasure()
					end
				
			--else
			--	MsgQuick("","@L_DANCE_FAILURE_+0")
			--	StopMeasure()
			--end
		else
			
			StopMeasure()
			
		end
	else
		if not f_MoveTo("", "Divehouse", GL_MOVESPEED_RUN, 0, "AIDance") then
			StopMeasure()
		end

		if not GetInsideBuilding("","CurrentBuilding") then
			StopMeasure()
		end

		if BuildingGetType("CurrentBuilding")==36 then
			CopyAlias("CurrentBuilding","Divehouse")
		else
			StopMeasure()
		end
		
		
	end


	local Filter = "__F((Object.GetObjectsByRadius(Sim) == 2000) AND (Object.Property.DanceSim==1))"
	local count = Find("", Filter, "Alias", -1)

	if count ~= 0 then
		StopMeasure()
	else
		SetProperty("Divehouse", "DanceShow",1)
		SetProperty("Divehouse", "DanceStartTime",GetGametime())
		SetProperty("", "DanceSim",1)
	end
	
	local MeasureID = GetCurrentMeasureID("")
	local cooldown = mdata_GetTimeOut(MeasureID)
	SetMeasureRepeat(cooldown)

	local	TimeOut
	TimeOut = GetData("TimeOut")
	if TimeOut then
		TimeOut = GetGametime() + TimeOut
	end		

	--while true do
	local CurrentTime = GetGametime()
	local EndTime = CurrentTime + mdata_GetDuration(MeasureID)
	while CurrentTime < EndTime or IsGUIDriven() do
		SetProperty("Divehouse", "DanceShow", 1)
		local SearchSimFilter = "__F((Object.GetObjectsByRadius(Sim) == 10000) AND NOT(Object.BelongsToMe()))"
		local NumGuests = Find("", SearchSimFilter,"Guests", -1)

		if TimeOut then
			if TimeOut < GetGametime() then
				break
			end
		end
	
		if NumGuests == 0 then
			ms_assigntodancedivehouse_Waiting()
		else
			ms_assigntodancedivehouse_Dance()
		end

		IncrementXPQuiet("",15)
		CurrentTime = GetGametime()
		Sleep(1)
	end
	f_EndUseLocator("","MovePos",GL_STANCE_STAND)
end

function Waiting()
	SetProperty("Divehouse", "DanceShow", 1)
	GetFreeLocatorByName("Divehouse","Dance",1,4,"MovePos")
	if not f_BeginUseLocator("","MovePos",GL_STANCE_STAND,true) then
	    GetFreeLocatorByName("Divehouse","Dance"..(Rand(4)+1),-1,-1,"MovePos2")
		if not f_BeginUseLocator("","MovePos2",GL_STANCE_STAND,true) then
		    return
		end
	end
		
	PlayAnimation("","cogitate")

	Sleep(10)
	--f_EndUseLocator("","MovePos",GL_STANCE_STAND)
	return
	
end

function Dance()
	SetProperty("Divehouse", "DanceShow", 1)
	GetFreeLocatorByName("Divehouse","Dance",1,4,"MovePos")
	if not f_BeginUseLocator("","MovePos",GL_STANCE_STAND,true) then
	    GetFreeLocatorByName("Divehouse","Dance"..(Rand(4)+1),-1,-1,"MovePos2")
		if not f_BeginUseLocator("","MovePos2",GL_STANCE_STAND,true) then
		    return
		end
	end
	
	--while true do
	
	    if Gender == 0 then
		    PlaySound3DVariation("","CharacterFX/female_joy_loop",1)
		    letsdance = PlayAnimationNoWait("","dance_female_"..Rand(2)+1)
		else
		   PlaySound3DVariation("","CharacterFX/male_joy_loop",1)
		   letsdance = PlayAnimationNoWait("","dance_male_"..Rand(2)+1)
								
		end
		
		local SimFilter = "__F( (Object.GetObjectsByRadius(Sim)==500)AND(Object.HasDifferentSex())AND(Object.GetState(idle))AND NOT(Object.GetState(townnpc))AND NOT(Object.HasImpact(FullOfLove)))"
		local NumSims = Find("",SimFilter,"Sims",-1)
		if NumSims > 0 then
			local DestAlias = "Sims"..Rand(NumSims-1)
	        local spender = SimGetRank(DestAlias)
			local chakill = GetSkillValue("",CHARISMA)
	        local spend
	        if spender == 0 or spender == 1 then
	            spend = 2
	        elseif spender == 2 then
	            spend = 5
	        elseif spender == 3 then
	            spend = 10 * chakill
	        elseif spender == 4 then
	            spend = 20 * chakill
	        elseif spender == 5 then
	            spend = 30 * chakill
	        end
		    if IsDynastySim(DestAlias) then
			    f_SpendMoney(DestAlias,spend,"LaborOfLove")
		    end
		    SimGetWorkingPlace("","Divehouse")
		    f_CreditMoney("Divehouse",spend,"LaborOfLove")
		    economy_UpdateBalance("Divehouse", "Service", spend)
			AddImpact(DestAlias,"FullOfLove",1,2)
		end
	    Sleep(letsdance+2)
    --end
	--f_EndUseLocator("","MovePos",GL_STANCE_STAND)
	return
		
end

function CleanUp()
	if HasProperty("", "DanceSim") then
		RemoveProperty("", "DanceSim")
		if HasProperty("Divehouse", "GoToDance") then
			RemoveProperty("Divehouse", "GoToDance")
		end
		if HasProperty("Divehouse", "DanceShow") then
			RemoveProperty("Divehouse", "DanceShow")
		end
	end
	CarryObject("","",false)
	StopAnimation("")
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end