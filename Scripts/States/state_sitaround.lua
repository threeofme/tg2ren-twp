function Init()
	
end

function Run()
	--while GetInsideBuilding("","CurrentBuilding") do
	if not GetInsideBuilding("","CurrentBuilding") then
		return
	end
	if BuildingGetType("CurrentBuilding")==GL_BUILDING_TYPE_RESIDENCE then
		state_sitaround_DoResidenceStuff()	
	elseif BuildingGetType("CurrentBuilding")==GL_BUILDING_TYPE_TAVERN then
		state_sitaround_DoTavernStuff()
	elseif BuildingGetType("CurrentBuilding")==111 then
	    state_sitaround_DoEstateStuff()
	elseif BuildingGetType("CurrentBuilding")==36 then
	    state_sitaround_DoDivehouseStuff()
	else
		return
	end
	
	--end
end

function DoDivehouseStuff()

	if GetFreeLocatorByName("CurrentBuilding","Sit",1,5,"SitPos") then
		f_BeginUseLocator("","SitPos",GL_STANCE_SIT,true)
	else
		GetFreeLocatorByName("CurrentBuilding","Sit",6,11,"SitPos")
		f_BeginUseLocator("","SitPos",GL_STANCE_SIT,true)
	end

	SetProperty("","ReadyToDrink",1)
	while MoveGetStance("")==GL_STANCE_SIT do
		if GetCurrentMeasureName("")=="DoNothing" then
			MeasureRun("","","RPGSitAround",true)
		end
		Sleep(1)
	end
	
	--set recovery timer (how long it takes for the sim to be able to drink more)
	local DrinkHardiness = (GetSkillValue("", 1) * 0.1)
	local BaseDrinkingTime = 4 * (DrinkHardiness + 1)
	SetRepeatTimer("", "RecoveryTimer", (BaseDrinkingTime - GetRepeatTimerLeft("", "DrunkenessTimer")) * 2)
end

function DoEstateStuff()

	if GetLocatorByName("CurrentBuilding","Sit1","SitPos") then
		f_BeginUseLocator("","SitPos",GL_STANCE_SIT,true)
	end
	
	local duration = Rand(2)+1
	local CurrentHP = GetHP("")
	local MaxHP = GetMaxHP("")
	local ToHeal = MaxHP - CurrentHP
	local HealPerTic = ToHeal / (duration * 12)	
					
	while MoveGetStance("")==GL_STANCE_SIT do
		Sleep(2)
		local tuWas = Rand(3)
		if tuWas == 0 then
	    local AnimTime = PlayAnimationNoWait("","sit_drink")
	    Sleep(1)
	    CarryObject("","Handheld_Device/ANIM_beaker_sit_drink.nif",false)
	    Sleep(1)
	    PlaySound3DVariation("","CharacterFX/drinking",1)
	    Sleep(AnimTime-1.5)
	    CarryObject("","",false)
	    PlaySound3DVariation("","CharacterFX/nasty",1)
	    Sleep(1.5)
		elseif tuWas == 1 then
			if SimGetGender("") == 1 then
				PlaySound3DVariation("","CharacterFX/male_neutral",1)
			else
				PlaySound3DVariation("","CharacterFX/female_neutral",1)
	    end	
		  PlayAnimation("","sit_talk")
		else
			if SimGetGender("") == 1 then
				PlaySound3DVariation("","CharacterFX/male_neutral",1)
			else
				PlaySound3DVariation("","CharacterFX/female_neutral",1)
	    end	
		  PlayAnimation("","sit_talk_02")
		end
		if GetHP("") < MaxHP then
			ModifyHP("", HealPerTic,false)
    end
	end
	StopMeasure()
end

function DoResidenceStuff()
	local ResidenceLevel = BuildingGetLevel("CurrentBuilding")
	local MaxLocatorCnt = 5
	if ResidenceLevel > 4 then
		MaxLocatorCnt = 8
	end
	if GetFreeLocatorByName("CurrentBuilding","Chair",1,MaxLocatorCnt,"SitPos") then
		f_BeginUseLocator("","SitPos",GL_STANCE_SIT,true)
	end
	while MoveGetStance("")==GL_STANCE_SIT do
		Sleep(2)
	end
	StopMeasure()
end

function DoTavernStuff()
	if GetFreeLocatorByName("CurrentBuilding","SitRich",1,5,"SitPos") then
		f_BeginUseLocator("","SitPos",GL_STANCE_SIT,true)
	end
	SetProperty("","ReadyToDrink",1)
	while MoveGetStance("")==GL_STANCE_SIT do
		if GetCurrentMeasureName("")~="RPGSitAround" then
			MeasureRun("","","RPGSitAround",true)
		end
		Sleep(3)
	end
	
	--set recovery timer (how long it takes for the sim to be able to drink more)
	--local DrinkHardiness = (GetSkillValue("", 1) * 0.1)
	--local BaseDrinkingTime = 4 * (DrinkHardiness + 1)
	--SetRepeatTimer("", "RecoveryTimer", (BaseDrinkingTime - GetRepeatTimerLeft("", "DrunkenessTimer")) * 2)
end

function CleanUp()
	if HasProperty("","ReadyToDrink") then
		RemoveProperty("","ReadyToDrink")
	end
	if AliasExists("SitPos") then
		ReleaseLocator("","SitPos")
		--MoveSetStance("",GL_STANCE_STAND)
		--f_EndUseLocator("","SitPos",GL_STANCE_STAND)
	end
	CarryObject("","",false)
	SetState("",STATE_SITAROUND,false)
	
	ResetProcessProgress("")
end

