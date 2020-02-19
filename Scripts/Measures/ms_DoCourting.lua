function Run()
	if not AliasExists("MrApplicant") then
		if not GetAliasByID(GetProperty("","MrApplicant"),"MrApplicant") then
			--mr applicant tot
			ms_docourting_Terminate()
		end
	end
	
	if not AliasExists("Destination") then
		if not GetAliasByID(GetProperty("","DestID"),"Destination") then
			--destination tot
			feedback_MessageCharacter("MrApplicant","@L_GENERAL_SENDAPPLICANT_FAILURES_HEAD_+0",
								"@L_GENERAL_SENDAPPLICANT_FAILURES_BODY_+0")
			ms_docourting_Terminate()
		end
	end
		
	while SimGetProgress("MrApplicant")<100 do
		Sleep(5)
		ms_docourting_CheckLover()
	
		if ai_StartInteraction("", "Destination", 1000, 100, "BlockMe") then
			if SimGetGender("")==GL_GENDER_MALE then
				PlaySound3DVariation("","CharacterFX/male_neutral",1)
			else
				PlaySound3DVariation("","CharacterFX/female_neutral",1)
			end
			PlayAnimation("","talk")
			if SimGetGender("Destination")==GL_GENDER_MALE then
				PlaySound3DVariation("Destination","CharacterFX/male_neutral",1)
			else
				PlaySound3DVariation("Destination","CharacterFX/female_neutral",1)
			end
			PlayAnimation("Destination","talk")
			local CurrentProgress = Rand(10)+15+SimGetProgress("MrApplicant")
			SimSetProgress("MrApplicant",CurrentProgress)
			chr_ModifyFavor("Destination","MrApplicant",10)
			SetRepeatTimer("","ApplicantActionRepeat",1.5)
			SetData("Blocked",1)
			f_FollowNoWait("","Destination",GL_MOVESPEED_WALK,500)
			while not ReadyToRepeat("","ApplicantActionRepeat") do
				ms_docourting_CheckLover()
				Sleep(5)
			end				
		else
			Sleep(5)
		end
		Sleep(1)
	end
	
	ms_docourting_Terminate()
	StopMeasure()
end

function CheckLover()
	if SimGetSpouse("Destination","Spouse") then
		feedback_MessageCharacter("MrApplicant","@L_GENERAL_SENDAPPLICANT_FAILURES_HEAD_+0",
							"@L_GENERAL_SENDAPPLICANT_FAILURES_BODY_+1")
		ms_docourting_Terminate()
	end
	
	if not SimIsCourting("MrApplicant") then
		ms_docourting_Terminate()
	end
	
	if SimGetSpouse("MrApplicant","Spouse") then
		ms_docourting_Terminate()
	end
	
	if GetInsideBuilding("Destination","DestBuilding") then
		GetOutdoorMovePosition("","DestBuilding","MovePos")
		f_MoveTo("","MovePos",GL_MOVESPEED_RUN)
	end
end

function BlockMe()
	SetData("Blocked",0)
	while GetData("Blocked")~=1 do
		Sleep(0.76)
	end
end

function Terminate()
	InternalDie("")
	InternalRemove("")
	StopMeasure()
end

function CleanUp()
	
end

