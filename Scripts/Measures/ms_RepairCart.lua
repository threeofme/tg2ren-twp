-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_RepairCart"
----
----	With this measure the player can repair one of his carts
----
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()
	
	if not CartGetOperator("", "operator") then
		StopMeasure()
		return
	else
		
			
		SetState("operator", STATE_LOCKED, true)
		if not IsType("","Ship") then
			if not ExitCurrentVehicle("") then
				MsgQuick("", "@L_GENERAL_MEASURES_REPAIRCART_FAILURES_+0")
				StopMeasure()
				return
			end
		end
		
			
			local DirX = 0
			local DirY = 0
			local DirZ = 0
			DirX, DirY, DirZ = GetRotationTo("operator", "")
			GfxSetRotation("operator", 0, DirY, 0, true)
			
			local CartType = CartGetType("")
			GetDynasty("", "CartDynasty")
			if IsType("","Ship") then
				--SetContext("operator","rangerhut")
				--CarryObject("operator","Handheld_Device/Anim_Hammer.nif", false)
				--PlayAnimation("operator","chop_in")
				--LoopAnimation("operator","chop_loop",-1)
			else
				LoopAnimation("operator", "crank_front_loop", -1)
			end
			
			local RepairPrice = gameplayformulas_CalcCartRepairPrice(CartType, GetHPRelative(""))
			if AliasExists("CartDynasty") then 
				if not f_SpendMoney("CartDynasty", RepairPrice, "CartRepair") then
					MsgQuick("","@L_GENERAL_MEASURES_REPAIRCART_FAILURES_+1")
					StopMeasure()
					return
				end
			end
			
			local SleepTime = 1
			if IsType("","Ship") then
				SleepTime = SleepTime * 2
			end
			
			SetProcessMaxProgress("",GetMaxHP(""))
			
			local ToRepair = 0.01 * GetMaxHP("")
			
			local TimeToRepair = Realtime2Gametime(((GetMaxHP("") - GetHP(""))/ToRepair)*2)
			SetRepeatTimer("", GetMeasureRepeatName(), TimeToRepair)
			
			while (GetHPRelative("") < 1.0) do
				Sleep(SleepTime)
				ModifyHP("", ToRepair, false)
				SetProcessProgress("", GetHP(""))
			end
			if IsType("","Ship") then
				PlayAnimation("operator","chop_out")
			else
				PlayAnimation("operator", "crank_front_out")
			end
			StopAnimation("operator") 
			
		
	end
	
	StopMeasure()
	return
	
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	SetRepeatTimer("", GetMeasureRepeatName(), 0)
	StopAnimation("operator")
	EnterVehicle("operator", "")
	SetState("operator", STATE_LOCKED, false)
	RemoveProperty("operator", "NoControlSim")
	ResetProcessProgress("")
	
end

-- -----------------------
-- GetOSHData
-- -----------------------
function GetOSHData(MeasureID)
	local CartType = CartGetType("Owner")
	local RepairPrice = gameplayformulas_CalcCartRepairPrice(CartType, GetHPRelative("Owner"))
	OSHSetMeasureCost("@L_INTERFACE_HEADER_+6",RepairPrice)
end

