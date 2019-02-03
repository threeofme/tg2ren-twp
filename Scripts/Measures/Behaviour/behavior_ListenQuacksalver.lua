function Run()

	-- etwa Abstand vom Geschehen, und gaffen
	GetFleePosition("Owner", "Actor", Rand(100)+150, "Away")
	f_MoveTo("Owner", "Away", GL_MOVESPEED_WALK)
	AlignTo("Owner", "Actor")
	Sleep(1)

	local ActionName = GetData("Action_Name")
	local Timer = 0
	SetRepeatTimer("Owner", "Listen2Quacksalver", 16)

	--listen
	while true do
	
		if ActionIsStopped("Action") then
			break
		end
		
		if Timer == 3 then
			break
		end
		
		Sleep(4)
			
		local Value = Rand(100)
		if Value < 50 then
			if SimGetGender("")==GL_GENDER_MALE then
				if Rand(2) == 0 then
					PlayAnimationNoWait("Owner", "cheer_01")
				else
					PlayAnimationNoWait("Owner", "cheer_02")
				end
				PlaySound3DVariation("","CharacterFX/male_cheer",0.5)
			else
				if Rand(2) == 0 then
					PlayAnimationNoWait("Owner", "cheer_01")
				else
					PlayAnimationNoWait("Owner", "cheer_02")
				end
				PlaySound3DVariation("","CharacterFX/female_cheer",0.5)
			end
		end
		Timer = Timer +1
	end
	
	--buy stuff or not
	if (GetID("Actor")) and not ActionIsStopped("Action") then
		local RhetoricSkillActor = GetSkillValue("Actor", RHETORIC)
		local MoneyToGet = RhetoricSkillActor * 20
		local RandomTime = 1+Rand(5)
		Sleep(RandomTime)
		if RhetoricSkillActor>=(GetSkillValue("", EMPATHY)+Rand(3)) then
			MsgSayNoWait("","@L_MEASURE_LISTENQUACKSALVER_YES")
			PlayAnimation("","nod")
			if RemoveItems("Actor", "MiracleCure", 1, INVENTORY_STD)==1 then
				MoneyToGet = MoneyToGet + Rand(101)
				f_CreditMoney("Actor",MoneyToGet,"Offering")
				
				-- for the balance
				if ai_GetWorkBuilding("Actor", GL_BUILDING_TYPE_HOSPITAL, "Hospital") then
					economy_UpdateBalance("Hospital", "Salescounter", MoneyToGet)
				end
				
				if dyn_IsLocalPlayer("Actor") then
					ShowOverheadSymbol("Actor",false,true,0,"%1t",MoneyToGet)
				end
			else
				SatisfyNeed("", 6, -0.5)
			end
		else
			MsgSayNoWait("","@L_MEASURE_LISTENQUACKSALVER_NO")
			if SimGetGender("")==GL_GENDER_MALE then
				PlaySound3DVariation("","CharacterFX/male_hoot",1)
			else
				PlaySound3DVariation("","CharacterFX/female_hoot",1)
			end
			PlayAnimation("","shake_head")
		end
	end
end

