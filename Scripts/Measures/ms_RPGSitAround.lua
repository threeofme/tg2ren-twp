function Run()

	if not HasProperty("","ReadyToDrink") then
		SetState("", STATE_SITAROUND,true)
	else
		if not GetInsideBuilding("","CurrentBuilding") then
			SetState("",STATE_SITAROUND,false)
			StopMeasure()
		end

		--get how long sim can drink based on constitution
		local DrinkHardiness = (GetSkillValue("", 1) * 0.1) --1 = constitution
		local BaseDrinkingTime = 4 * (DrinkHardiness + 1)

		--track time spent drinking and 
		local TimeToGetDrunk = BaseDrinkingTime
		if MoveGetStance("")==GL_STANCE_SIT and HasProperty("","ReadyToDrink") then
			if GetRepeatTimerLeft("", "RecoveryTimer") > 0 then
				TimeToGetDrunk = (BaseDrinkingTime - (GetRepeatTimerLeft("", "RecoveryTimer")) / 2)
			end		
			SetRepeatTimer("", "DrunkenessTimer", TimeToGetDrunk)
		end
		
		--progress bar indicates how close you are to being "totally drunk"
		SetProcessMaxProgress("",BaseDrinkingTime * 5) --multiply by 5 to make progress bar increase more gradually
		SetProcessProgress("", (5 * BaseDrinkingTime) - (5 * TimeToGetDrunk))

		
		local CostToDrink = 30 --as if buying wheat beer at the base price
		
		--animation note: plays the animation with a money cost first, then does 4 random animations (total of 5 including first one),
		--then goes back to the first one (with the money cost), and so on. This way the cost is more consistent (one payment every five cycles).
		--The time for each cycle depends on the randomly chosen animations, so it varies a bit.
		--Each cycle the favor bonus is still appled
		local AnimCount = 0
		while HasProperty("","ReadyToDrink") do
			local AnimTime
			if AnimCount > 4 then --change this number to change the number of cycles before the next payment (currently one payment per 5 cycles)
				AnimCount = 0
			end
			PlaySound3DVariation("","Locations/tavern_people",1)
			if AnimCount == 0 then
				ms_rpgsitaround_PayTavern(CostToDrink, "CurrentBuilding")
				AnimTime = PlayAnimationNoWait("","sit_drink")
				Sleep(1)
				CarryObject("","Handheld_Device/ANIM_beaker_sit_drink.nif",false)
				Sleep(2)
				PlaySound3DVariation("","CharacterFX/drinking",1)
				Sleep(AnimTime-1.5)
				if SimGetGender("")==GL_GENDER_MALE then
					PlaySound3DVariation("","CharacterFX/male_belch",1)
				else
					PlaySound3DVariation("","CharacterFX/female_belch",1)
				end
				CarryObject("","",false)
				Sleep(2.5)
				AnimCount = AnimCount + 1
			else
				local AnimType = Rand(4)
				if AnimType == 0 then
					PlayAnimation("","sit_eat")	
					AnimCount = AnimCount + 1
				elseif AnimType == 1 then
					PlayAnimation("","sit_talk")
					AnimCount = AnimCount + 1
				elseif AnimType == 2 then
					AnimTime = PlayAnimationNoWait("","sit_cheer")
					Sleep(1)
					CarryObject("","Handheld_Device/ANIM_beaker_sit_drink.nif",false)
					PlaySound3D("","Locations/tavern/cheers_01.wav",1)
					Sleep(2)
					PlaySound3DVariation("","CharacterFX/drinking",1)
					Sleep(AnimTime-1.5)
					CarryObject("","",false)
					Sleep(2.5)
					AnimCount = AnimCount + 1
				elseif AnimType == 3 then
					PlayAnimationNoWait("","sit_laugh")
					Sleep(2+Rand(2))
					if Rand(2)==0 then
						PlaySound3D("","Locations/tavern/laugh_01.wav",1)
					else
						PlaySound3D("","Locations/tavern/laugh_02.wav",1)
					end
					Sleep(4+Rand(3))
					AnimCount = AnimCount + 1
				end
			end
				
			--do favor stuff
			local Charisma = GetSkillValue("", 3)
			local favorbonus = math.ceil(Charisma / 3) -- 1 - 4
			BuildingGetInsideSimList("CurrentBuilding", "SimsList")
			for i=0, ListSize("SimsList")-1 do
				ListGetElement("SimsList", i, "Sim")
				if IsDynastySim("Sim") and (GetDynastyID("Sim") ~= GetDynastyID("")) then
					if MoveGetStance("Sim")==GL_STANCE_SIT then
						if not (GetName("") == GetName("Sim")) then
							chr_ModifyFavor("Sim","",favorbonus)
						end
					end
				end
			end
			
			--debug stuff
			--ShowOverheadSymbol("",false,true,0, "Drunk Timer: " .. GetRepeatTimerLeft("", "DrunkenessTimer")) 
			--Sleep(0.5)
			--ShowOverheadSymbol("",false,true,0, "Recovery Timer: " .. GetRepeatTimerLeft("", "RecoveryTimer")) 
			
			--update progress bar
			SetProcessMaxProgress("",BaseDrinkingTime * 5)
			SetProcessProgress("", (5 * BaseDrinkingTime) - (5 * GetRepeatTimerLeft("", "DrunkenessTimer")))
			
			--check if totally drunk yet
			if GetRepeatTimerLeft("", "DrunkenessTimer") <= 0 then
				AddImpact("","totallydrunk",1,8)
				AddImpact("","MoveSpeed",0.7,8)
				SetState("",STATE_SITAROUND,false)
				SetState("",STATE_TOTALLYDRUNK,true)
				StopMeasure()
			end
		end
	end
end

--Spend Cost and give that amount to Tavern owner
function PayTavern(Cost, Tavern)
	BuildingGetOwner(Tavern, "TavernOwner")
	--don't do money exchange if tavern belongs to paying sim's dynasty
	if (GetDynastyID("") ~= GetDynastyID("TavernOwner")) then 
	--if not enough money don't pay, just stop measure by standing up
		if (GetMoney("") >= Cost) then
			f_SpendMoney("",Cost,"Misc")
			f_CreditMoney(Tavern,Cost,"Misc")
			economy_UpdateBalance(Tavern, "Service", Cost)
			feedback_OverheadMoney("", -Cost)
			PlaySound3D("","Effects/coins_to_counter+0.wav", 1.0)
		else
			 MoveSetStance("", GL_STANCE_STAND)
		end
	end
end


function CleanUp()
	if HasProperty("","ReadyToDrink") then
		MoveSetStance("", GL_STANCE_STAND)
		Sleep(1)
		RemoveProperty("","ReadyToDrink")
		ResetProcessProgress("")
		StopMeasure()
	end
end

