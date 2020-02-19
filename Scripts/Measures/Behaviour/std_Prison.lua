function Run()

	if not GetInsideBuilding("Owner","Prison") then
		if not ai_GoInsideBuilding("Owner","Owner", -1, GL_BUILDING_TYPE_PRISON, "Prison") then
			StopMeasure()
			return
		end
	end
		
	local ActionType = 0
	--The Cell Number. 1 or 2
	local CellNumber = (Rand(2))+1
	
	SetData("CellNumber", CellNumber)

	--while sim is in jail
	while GetState("",STATE_IMPRISONED) do
	
		if not HasProperty("","Imprisoned") then
			GetLocatorByName("Prison","Cell1A","Cell1Sound")
			GetLocatorByName("Prison","Cell2A","Cell2Sound")
			SetProperty("","Imprisoned",1)
			if CellNumber == 1 then
				PlaySound3DVariation("Cell1Sound","Effects/door_open",1)
				SetRoomAnimationTime("Prison","","U_CellDoor_A",0)
				StartRoomAnimation("Prison","","U_CellDoor_A")
			else
				PlaySound3DVariation("Cell2Sound","Effects/door_open",1)
				SetRoomAnimationTime("Prison","","U_CellDoor_B",0)
				StartRoomAnimation("Prison","","U_CellDoor_B")
			end
			Sleep(1.2)
			if CellNumber == 1 then
				StopRoomAnimation("Prison","","U_CellDoor_A")
			else
				StopRoomAnimation("Prison","","U_CellDoor_B")
			end
			
			GetLocatorByName("Prison","Entry"..CellNumber.."TeleportPos","CellTeleportPos")
			f_MoveTo("","CellTeleportPos")
			LoopAnimation("","walk",-1)
			GetLocatorByName("Prison","Entry"..CellNumber.."TeleportTargetPos","CellTeleportTargetPos")
			SimBeamMeUp("","CellTeleportTargetPos",false)
			StopAnimation("")
			
			if CellNumber == 1 then
				StartRoomAnimation("Prison","","U_CellDoor_A")
			else
				StartRoomAnimation("Prison","","U_CellDoor_B")
			end
			Sleep(1.1)
			if CellNumber == 1 then
				PlaySound3DVariation("Cell1Sound","Effects/door_close",1)
				StopRoomAnimation("Prison","","U_CellDoor_A")
				SetRoomAnimationTime("Prison","","U_CellDoor_A",0)
			else
				PlaySound3DVariation("Cell1Sound","Effects/door_close",1)
				StopRoomAnimation("Prison","","U_CellDoor_B")
				SetRoomAnimationTime("Prison","","U_CellDoor_B",0)
			end
		end
		--check if prison still exists
		if AliasExists("Prison") then
			if GetHP("Prison") < 1 then
				feedback_MessageCharacter("Owner",
					"@L_PRISON_TRAGICALLY_ACCIDENT_MSG_VICTIM_HEAD_+0",
					"@L_PRISON_TRAGICALLY_ACCIDENT_MSG_VICTIM_BODY_+0",GetID("Owner"))
				log_death(DestAlias, " was killed in prison (std_Prison).")
				ModifyHP("",-GetMaxHP(""),false)
				return
			end
		end
		ActionType = Rand(4)
		if (ActionType == 0) then
			if GetFreeLocatorByName("Prison", "Cell"..CellNumber.."A",-1,-1, "CellPos1"..CellNumber) then
				SetData("BlockedCell","CellPos1"..CellNumber)
				BlockLocator("","CellPos1"..CellNumber)
			 	f_MoveTo("", "CellPos1"..CellNumber)
				Sleep(1)
				MoveSetStance("",GL_STANCE_SITGROUND)
				MsgSayNoWait("","@L_PRISON_1_ARREST_MONOLOGUE")
				Sleep(28)
				MoveSetStance("",GL_STANCE_STAND)
				Sleep(6)
				ReleaseLocator("","CellPos1"..CellNumber)
			end
			if GetFreeLocatorByName("Prison", "Cell"..CellNumber.."B",-1,-1, "CellPos2"..CellNumber) then
				SetData("BlockedCell","CellPos2"..CellNumber)
				BlockLocator("","CellPos2"..CellNumber)
				f_MoveTo("", "CellPos2"..CellNumber)
				Sleep(1)
				MoveSetStance("",GL_STANCE_KNEEL)
				Sleep(8)
				PlayAnimationNoWait("","knee_pray")
				MsgSayNoWait("","@L_PRISON_1_ARREST_PACING")
				Sleep(10)
				MoveSetStance("",GL_STANCE_STAND)
				Sleep(6)
				ReleaseLocator("","CellPos2"..CellNumber)				
			end
			if GetFreeLocatorByName("Prison", "Cell"..CellNumber.."C",-1,-1, "CellPos3"..CellNumber) then
				SetData("BlockedCell","CellPos3"..CellNumber)
				BlockLocator("","CellPos3"..CellNumber)
				f_MoveTo("", "CellPos3"..CellNumber)
				Sleep(1)
				PlayAnimationNoWait("","cheer_01")
				MsgSay("","@L_PRISON_1_ARREST_VERBAL_AGGRO")
				Sleep(5)
				PlayAnimationNoWait("","cheer_01")
				MsgSay("","@L_PRISON_1_ARREST_VERBAL_AGGRO")
				Sleep(1)
				ReleaseLocator("","CellPos3"..CellNumber)
			end
			--when in cell 1 do
			if (GetFreeLocatorByName("Prison", "Cell"..CellNumber.."D",-1,-1, "CellPos4"..CellNumber) and (CellNumber == 1)) then
				SetData("BlockedCell","CellPos4"..CellNumber)
				BlockLocator("","CellPos4"..CellNumber)
				f_MoveTo("", "CellPos4"..CellNumber)
				Sleep(1)
				PlayAnimationNoWait("","threat")
				MoveSetStance("",GL_STANCE_SITGROUND)
				MsgSayNoWait("","@L_PRISON_1_ARREST_VERBAL_AGGRO")
				Sleep(15)
				MoveSetStance("",GL_STANCE_STAND)
				Sleep(6)
				PlayAnimationNoWait("","threat")
				MsgSay("","@L_PRISON_1_ARREST_VERBAL_AGGRO")
				Sleep(4)
				ReleaseLocator("","CellPos4"..CellNumber)
			end
				
		elseif (ActionType == 1) then
			if GetFreeLocatorByName("Prison", "Cell"..CellNumber.."C",-1,-1, "CellPos5"..CellNumber) then
				SetData("BlockedCell","CellPos5"..CellNumber)
				BlockLocator("","CellPos5"..CellNumber)
				f_MoveTo("", "CellPos5"..CellNumber)
				Sleep(1)
				MoveSetStance("",GL_STANCE_CROUCH)
				MsgSayNoWait("","@L_PRISON_1_ARREST_CROUCH")
				Sleep(6)
				MsgSayNoWait("","@L_PRISON_1_ARREST_CROUCH")
				Sleep(15)
				MoveSetStance("",GL_STANCE_STAND)
				Sleep(6)
				ReleaseLocator("","CellPos5"..CellNumber)
			end
			if GetFreeLocatorByName("Prison", "Cell"..CellNumber.."A",-1,-1, "CellPos6"..CellNumber) then
				SetData("BlockedCell","CellPos6"..CellNumber)
				BlockLocator("","CellPos6"..CellNumber)
				f_MoveTo("", "CellPos6"..CellNumber)
				Sleep(1)
				MoveSetStance("",GL_STANCE_SITGROUND)
				MsgSayNoWait("","@L_PRISON_1_ARREST_MONOLOGUE")
				Sleep(28)
				MsgSayNoWait("","@L_PRISON_1_ARREST_MONOLOGUE")
				Sleep(28)
				MoveSetStance("",GL_STANCE_STAND)
				Sleep(6)
				ReleaseLocator("","CellPos6"..CellNumber)
			end
					
		elseif (ActionType == 2) then
			if GetFreeLocatorByName("Prison", "Cell"..CellNumber.."Sleep",-1,-1, "CellPos7"..CellNumber) then
				SetData("BlockedCell","CellPos7"..CellNumber)
				BlockLocator("","CellPos7"..CellNumber)
				f_MoveTo("", "CellPos7"..CellNumber)
				Sleep(1)
				PlayAnimationNoWait("","talk")
				MsgSay("","@L_PRISON_1_ARREST_PACING")
				Sleep(4)
				MoveSetStance("",GL_STANCE_LAY)
				Sleep(20)
				MoveSetStance("",GL_STANCE_STAND)
				Sleep(6)
				ReleaseLocator("","CellPos7"..CellNumber)
			end
					
		elseif (ActionType == 3) then
			if GetFreeLocatorByName("Prison", "Cell"..CellNumber.."B",-1,-1, "CellPos8"..CellNumber) then
				SetData("BlockedCell","CellPos8"..CellNumber)
				BlockLocator("","CellPos8"..CellNumber)
				f_MoveTo("", "CellPos8"..CellNumber)
				PlayAnimationNoWait("","talk")
				MsgSay("","@L_PRISON_1_ARREST_PACING")
				-- Stroll("",200,10)
				Sleep(3)
				PlayAnimationNoWait("","talk")
				MsgSay("","@L_PRISON_1_ARREST_PACING")
				-- Stroll("",200,5)
				Sleep(2)
				PlayAnimation("","cogitate")
				Sleep(1)
				-- Stroll("",200,10)
				ReleaseLocator("","CellPos8"..CellNumber)
			end
				
		elseif (ActionType == 4) then
			if GetFreeLocatorByName("Prison", "Cell"..CellNumber.."B",-1,-1, "CellPos9"..CellNumber) then
				SetData("BlockedCell","CellPos9"..CellNumber)
				BlockLocator("","CellPos9"..CellNumber)
				f_MoveTo("", "CellPos9"..CellNumber)
				Sleep(1)
				MoveSetStance("",GL_STANCE_SITGROUND)
				MsgSayNoWait("","@L_PRISON_1_ARREST_MONOLOGUE")
				Sleep(25)
				MsgSayNoWait("","@L_PRISON_1_ARREST_MONOLOGUE")
				Sleep(25)
				MoveSetStance("",GL_STANCE_STAND)
				Sleep(6)
				ReleaseLocator("","CellPos9"..CellNumber)
			end
			f_Stroll("",200,10)
			if GetFreeLocatorByName("Prison", "Cell"..CellNumber.."C",-1,-1, "CellPos10"..CellNumber) then
				SetData("BlockedCell","CellPos10"..CellNumber)
				BlockLocator("","CellPos10"..CellNumber)
				f_MoveTo("", "CellPos10"..CellNumber)
				Sleep(1)
				MoveSetStance("",GL_STANCE_SITGROUND)
				Sleep(14)
				MoveSetStance("",GL_STANCE_STAND)
				Sleep(6)
				ReleaseLocator("","CellPos10"..CellNumber)
			end
		end
		
		
		Sleep(1)
	end
	
	
	if HasProperty("","Imprisoned") then
		if CellNumber == 1 then
			StartRoomAnimation("Prison","","U_CellDoor_A")
		else
			StartRoomAnimation("Prison","","U_CellDoor_B")
		end
		Sleep(1.2)
		if CellNumber == 1 then
			StopRoomAnimation("Prison","","U_CellDoor_A")
			SetRoomAnimationTime("Prison","","U_CellDoor_A",0)
		else
			StopRoomAnimation("Prison","","U_CellDoor_B")
			SetRoomAnimationTime("Prison","","U_CellDoor_B",0)
		end
		
		GetLocatorByName("Prison","Cell"..CellNumber.."TeleportPos","CellTeleportPos")
		f_MoveTo("","CellTeleportPos")

		GetLocatorByName("Prison","Cell"..CellNumber.."TeleportTargetPos","CellTeleportTargetPos")
		SimBeamMeUp("","CellTeleportTargetPos",false)
		StopAnimation("")
		RemoveProperty("","Imprisoned")
		
		if CellNumber == 1 then
			PlaySound3DVariation("Cell1Sound","Effects/door_open",1)
			StartRoomAnimation("Prison","","U_CellDoor_A")
		else
			PlaySound3DVariation("Cell2Sound","Effects/door_open",1)
			StartRoomAnimation("Prison","","U_CellDoor_B")
		end
		Sleep(1.1)
		if CellNumber == 1 then
			PlaySound3DVariation("Cell1Sound","Effects/door_close",1)
			StopRoomAnimation("Prison","","U_CellDoor_A")
			SetRoomAnimationTime("Prison","","U_CellDoor_A",0)
		else
			PlaySound3DVariation("Cell2Sound","Effects/door_close",1)
			StopRoomAnimation("Prison","","U_CellDoor_B")
			SetRoomAnimationTime("Prison","","U_CellDoor_B",0)
		end
		
		f_ExitCurrentBuilding("")
	end
	
end

function CleanUp()
	if HasProperty("","Imprisoned") then
		local CellNumber = GetData("CellNumber")
		if not CellNumber then
			CellNumber = 1
		end
	
		GetLocatorByName("Prison","Cell"..CellNumber.."TeleportTargetPos","CellTeleportTargetPos")
		SimBeamMeUp("","CellTeleportTargetPos",false)
		StopAnimation("")		
		if not HasProperty("","GettingTortured") then	
			SetState("", STATE_EXPEL, true)
		end
		RemoveProperty("","Imprisoned")
	end
	
	if HasData("BlockedCell") then
		ReleaseLocator("",GetData("BlockedCell"))
	end
	RemoveProperty("", "CellNumber")
	SetState("",STATE_CAPTURED,false)
end

