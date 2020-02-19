-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_PreachBible.lua"
----
----	With this measure the player can deliver a flaming speech and influence
----  the peoples favor
----  
----  1. Sim geht zum Zielgebiet und hält die Rede
----  2. Jeder Sim im Aktionsradius jubelt dem König zu
----  3. Die Gunst dieser Sims zu einem steigt dadurch (mögl. auch die der Sims innerhalb von Gebäuden)
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()

	if not f_MoveTo("","Destination") then
		StopMeasure()
	end
	
	if IsStateDriven() then
		local ItemName = "Bible"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end
	
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	if RemoveItems("","Bible",1)>0 then
	
	--do the progress bar stuff
	local Time = GetGametime()
	local EndTime = Time + duration
	SetData("Time",duration)
	SetData("EndTime",EndTime)
	SetProcessMaxProgress("",duration*10)
	SendCommandNoWait("","Progress")
	
	CommitAction("preachbible","","")
	
	SetMeasureRepeat(TimeOut)
	MeasureSetNotRestartable()
	
	while GetGametime() < EndTime do
	PlayAnimationNoWait("","use_book_standing") 
	CarryObject("","Handheld_Device/ANIM_book.nif",false)
	Sleep(1)
	PlayAnimation("","preach")
	local Time = PlayAnimationNoWait("","use_book_standing") 
		MsgSay("","@L_ARTEFACTS_PREACHBIBLE_+0")
		PlayAnimationNoWait("","use_book_standing")
		PlayAnimation("","preach")		
		MsgSay("","@L_ARTEFACTS_PREACHBIBLE_+1")
		PlayAnimationNoWait("","use_book_standing")
		PlayAnimation("","preach")
		MsgSay("","@L_ARTEFACTS_PREACHBIBLE_+2")
		PlayAnimationNoWait("","use_book_standing")
		PlayAnimation("","preach")
		MsgSay("","@L_ARTEFACTS_PREACHBIBLE_+3")
		PlayAnimationNoWait("","use_book_standing") 
		PlayAnimation("","preach")
		MsgSay("","@L_ARTEFACTS_PREACHBIBLE_+4")
		PlayAnimationNoWait("","use_book_standing")
		PlayAnimation("","preach")		
		MsgSay("","@L_ARTEFACTS_PREACHBIBLE_+5")
		PlayAnimationNoWait("","use_book_standing")
		PlayAnimation("","preach")
		MsgSay("","@L_ARTEFACTS_PREACHBIBLE_+6")
		PlayAnimationNoWait("","use_book_standing")
		PlayAnimation("","preach")
		MsgSay("","@L_ARTEFACTS_PREACHBIBLE_+7")
		PlayAnimationNoWait("","use_book_standing")
		PlayAnimation("","preach")
		MsgSay("","@L_ARTEFACTS_PREACHBIBLE_+8")
		PlayAnimationNoWait("","use_book_standing") 
		PlayAnimation("","preach")
	end
	
	chr_GainXP("",GetData("BaseXP"))
	StopMeasure()
	end

end

function Progress()
	while true do
		local Time = GetData("Time")
		local EndTime = GetData("EndTime") 
		local CurrentTime = GetGametime() 
		CurrentTime = EndTime - CurrentTime 
		CurrentTime = Time - CurrentTime 
		SetProcessProgress("",CurrentTime*10)
		Sleep(3)
	end
end

function CleanUp()
	ResetProcessProgress("")
	StopAnimation("")
	StopAction("preachbible", "")
	CarryObject("","",false)
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end

