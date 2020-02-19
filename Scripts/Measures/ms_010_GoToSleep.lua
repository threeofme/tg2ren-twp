-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_010_GoToSleep"
----
----	with this measure the character can go to Sleep in his home building
----
-------------------------------------------------------------------------------

function Run() 
	
	local MeasureID = GetCurrentMeasureID("")
	local duration = 6

	BuildingFound = 1
	if SimGetProfession("")==GL_PROFESSION_MYRMIDON then
		if not SimGetWorkingPlace("","HomeBuilding") then
			MsgQuick("","@L_GENERAL_MEASURES_010_GOTOSLEEP_FAILURES_+0", GetID(""))
			StopMeasure()
		end
	elseif not(GetHomeBuilding("", "HomeBuilding")) then
		MsgDebugMeasure("GoToSleep - No homebuilding found for sleeping")
		if IsDynastySim("Owner") then
			MsgQuick("","@L_GENERAL_MEASURES_010_GOTOSLEEP_FAILURES_+0", GetID(""))
			StopMeasure()
		end
		StopMeasure()
	end

	if not GetInsideBuilding("", "Inside") or GetID("Inside")~=GetID("HomeBuilding") then
		if GetImpactValue("","Sickness")>0 then
			if not f_MoveTo("", "HomeBuilding", GL_MOVESPEED_WALK) then
				StopMeasure()
			end
		else
			if not f_MoveTo("", "HomeBuilding", GL_MOVESPEED_RUN) then
				StopMeasure()
			end
		end
	end
	if GetImpactValue("","SleepRecoverBonus")>0 then
		duration = duration - ((GetImpactValue("","SleepRecoverBonus")*0.01)*duration)
	end
	local CurrentHP = GetHP("")
	local MaxHP = GetMaxHP("")
	local ToHeal = MaxHP - CurrentHP
	local HealPerTic = ToHeal / (duration * 12)
	local UseLocator = false

	if not AliasExists("HomeBuilding") then
		StopMeasure()
	end

	if GetFreeLocatorByName("HomeBuilding", "Bed",1,3, "SleepPosition") then
		if not f_BeginUseLocator("", "SleepPosition", GL_STANCE_LAY, true) then
			MsgQuick("","@L_GENERAL_MEASURES_010_GOTOSLEEP_FAILURES_+1",GetID(""))
			StopMeasure()
		end
	else
		if SimGetProfession("")==GL_PROFESSION_MYRMIDON then
			MsgQuick("","@L_GENERAL_MEASURES_010_GOTOSLEEP_FAILURES_+1",GetID(""))
			StopMeasure()
		end
		if GetDynastyID("")~=-1 and IsDynastySim("Owner") then
			-- member from a dynasty must sleep in the right way
			MsgQuick("","@L_GENERAL_MEASURES_010_GOTOSLEEP_FAILURES_+1",GetID(""))
			return
		end
		RemoveAlias("SleepPosition")
	end
	
	local CurrentTime = GetGametime()
	local WasSick = false
	if GetImpactValue("","Sickness")>0 then
		duration = duration * 2
		WasSick = true
	end
	local EndTime = CurrentTime + duration
	local HealChance = 0 --50%
	
	while GetGametime()<EndTime do
		Sleep(5)
		-- increase the hp due to the recover factor for the residence
		if GetHP("") < MaxHP then
			ModifyHP("", HealPerTic,false)
			PlaySound3DVariation("","measures/gotosleep",1)
		end
	end
	
	if IsDynastySim("Owner") then
		if WasSick == true then
			if GetImpactValue("","Cold")>0 then
				if RemoveItems("HomeBuilding","Blanket",1,INVENTORY_STD)==1 then
					diseases_Cold("",false)
				end
			end
			if GetImpactValue("","Influenza")>0 then
				if RemoveItems("HomeBuilding","Blanket",1,INVENTORY_STD)==1 then
					if RemoveItems("HomeBuilding","HerbTea",1,INVENTORY_STD)==1 then
						HealChance = 1 --100%
					end
					if HealChance >= Rand(2) then
						diseases_Influenza("",false)
					end
				end
			end
			if GetImpactValue("","Pneumonia")>0 then
				if RemoveItems("HomeBuilding","Blanket",1,INVENTORY_STD)==1 then
					if RemoveItems("HomeBuilding","HerbTea",1,INVENTORY_STD)==1 then
						if RemoveItems("HomeBuilding","Honey",1,INVENTORY_STD)==1 then
							if RemoveItems("HomeBuilding","Bandage",1,INVENTORY_STD)==1 then -- you need a lot of stuff
								if Rand(2)>0 then -- but you still need to be lucky (50%)
									diseases_Pneumonia("",false)
								end
							end
						end
					end
				end
			end
		end
		
		if IsPartyMember("") then	
			feedback_MessageCharacter("",
				"@L_GENERAL_MEASURES_010_GOTOSLEEP_WAKEUP_HEAD",
				"@L_GENERAL_MEASURES_010_GOTOSLEEP_WAKEUP_BODY", GetID(""))
		end
		Sleep (1)
		local endtime = math.mod(GetGametime(),24)+duration
		if Rand(5)<3 then
			-- Good dream case 0,1,2 
			AddImpact("","rhetoric",1,12)
			AddImpact("","craftsmanship",1,12)
			AddImpact("","charisma",1,12)
			AddImpact("","constitution",1,12)
			AddImpact("","dexterity",1,12)
			AddImpact("","shadow_arts",1,12)
			AddImpact("","fighting",1,12)
			AddImpact("","secret_knowledge",1,12)
			AddImpact("","bargaining",1,12)
			AddImpact("","empathy",1,12)
			AddImpact("","GoodDream",1,12)
		else 
			-- Bad dreamcase 3,4
			AddImpact("","rhetoric",-1,12)
			AddImpact("","craftsmanship",-1,12)
			AddImpact("","charisma",-1,12)
			AddImpact("","constitution",-1,12)
			AddImpact("","dexterity",-1,12)
			AddImpact("","shadow_arts",-1,12)
			AddImpact("","fighting",-1,12)
			AddImpact("","secret_knowledge",-1,12)
			AddImpact("","bargaining",-1,12)
			AddImpact("","empathy",-1,12)
			AddImpact("","BadDream",1,12)
			SetProperty("","BadDreamTime",endtime)
		end
	end
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	
	if AliasExists("SleepPosition") then
		f_EndUseLocator("", "SleepPosition", GL_STANCE_STAND)
	end
end

function GetOSHData(MeasureID)
	
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end

