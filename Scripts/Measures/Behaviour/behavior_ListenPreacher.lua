function Run()

	-- etwa Abstand vom Geschehen, und gaffen
	GetFleePosition("Owner", "Actor", Rand(50)+200, "Away")
	f_MoveTo("Owner", "Away", GL_MOVESPEED_WALK)
	AlignTo("Owner", "Actor")
	Sleep(1)

	local ActionName = GetData("Action_Name")
	
	local Gender = SimGetGender("Owner")
	local TimeLeft = -1
	local	TimeOut = GetGametime()+1
	local	Religion
	
	if SimGetWorkingPlace("Actor", "WorkingPlace") then
		Religion = BuildingGetReligion("WorkingPlace")
	else
		Religion = SimGetReligion("Actor")
	end
	
	if Religion==RELIGION_NONE or Religion==RELIGION_PAGAN then
		return
	end

	while not ActionIsStopped("Action") do

		if GetGametime() > TimeOut then
			break
		end
			
		if TimeLeft < 0 then

			local Value = Rand(100)
			if Value < 50 then
				TimeLeft = PlayAnimation("Owner", "cheer_01")
			elseif Value < 95 then
				TimeLeft = PlayAnimation("Owner", "cheer_02")
			else
				if Religion == SimGetReligion("Owner") then
					MsgSayNoWait("Owner","@L_CHURCH_091_PREPAREWORSHIP_WORSHIPPING_COMMENT")
				end
				TimeLeft = PlayAnimation("Owner", "cheer_02")
			end
		end
		Sleep(1)
		TimeLeft = TimeLeft - 1
	end
	
	if (GetID("Actor")) then
	
		local faithmodifier = 10
		local faith = SimGetFaith("Owner")
		
		if (SimGetReligion("Owner")==Religion) then
			if (Religion==0) then
				chr_SimModifyFaith("Owner",faithmodifier,0)
				Sleep(1)
				chr_ModifyFavor("Owner","Actor",5)
			else
				chr_SimModifyFaith("Owner",faithmodifier,1)
				Sleep(1)
				chr_ModifyFavor("Owner","Actor",5)
			end
			SetRepeatTimer("Owner", "Listen2Preacher", 8)
		else
			if CheckSkill("Actor",RHETORIC, faith/10) then
				if SimGetGender("")==GL_GENDER_MALE then
					PlaySound3DVariation("","CharacterFX/male_cheer",1)
				else
					PlaySound3DVariation("","CharacterFX/female_cheer",1)
				end
				SetRepeatTimer("Owner", "Listen2Preacher", 24)
				SimSetReligion("Owner", Religion)
				SimSetFaith("Owner", 20)
				GetPosition("Owner","ParticleSpawnPos")
				--ShowOverheadSymbol("Owner",false,true,0,"@L_CHURCH_093_WINBELIEVERS_COMMENT_POSITIVE")
				Sleep(1)
				if (Religion==0) then
					ShowOverheadSymbol("Owner",false,true,0,"@L$S[2015]")
					StartSingleShotParticle("particles/pray_glow.nif","ParticleSpawnPos",1,4)
				else
					ShowOverheadSymbol("Owner",false,true,0,"@L$S[2014]")
					StartSingleShotParticle("particles/pray_glow.nif","ParticleSpawnPos",1,4)
				end
				--raise need
				SatisfyNeed("",2,(-0.3))
				-- some XP for actor
				if SimGetWorkingPlace("Actor","WorkBuilding") then
					BuildingGetOwner("WorkBuilding","MrChurch")
					IncrementXP("MrChurch",5)
				end
				
				IncrementXP("Actor",5)
			else
				if SimGetGender("")==GL_GENDER_MALE then
					PlaySound3DVariation("","CharacterFX/male_hoot",1)
				else
					PlaySound3DVariation("","CharacterFX/female_hoot",1)
				end
				if Rand(10) == 1 then
					MsgSayNoWait("Owner","@L_CHURCH_093_WINBELIEVERS_COMMENT_NEGATIVE")
				end
				SetRepeatTimer("Owner", "Listen2Preacher", 12)
			end
		end
	end
	
	Sleep(4.0)
end

