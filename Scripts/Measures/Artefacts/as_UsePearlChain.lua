-------------------------------------------------------------------------------
----
----	OVERVIEW "as_UsePearlChain"
----
----	with this artifact, the player can increase the favour to other characters
----	in range
----
-------------------------------------------------------------------------------

function Run()

--	-- animal test
--	GetHomeBuilding("", "Residence")
--	GetPosition("","MovePos")
--	SimCreate(999, "Residence", "MovePos", "Dog")
--	--VehicleChangeModel("Dog", "Characters/Dog.nif")
--	SetState("Dog",STATE_TOWNNPC,true)
--	SimSetFirstname("Dog", "Hund")
--	SimSetLastname("Dog", " ")
--	MeasureRun("Dog", "", "FollowSim", true)
--	StopMeasure()
--	-- animal test


	if GetImpactValue("","jewellery")>0 then
		MsgQuick("", "@L_GENERAL_MEASURES_JEWELLERY_FAILURES_+0", GetID(""))
		StopMeasure()
	end

	if (GetState("", STATE_CUTSCENE)) then
		as_usepearlchain_Cutscene()
	else
		as_usepearlchain_Normal()
	end
end


function Normal()

	if IsStateDriven() then
		if (HasProperty("","HaveCutscene") == true) then
			return
		end		
		local ItemName = "Pearlchain"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end

	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)

	--play animation
	local Time
	Time = PlayAnimationNoWait("","use_object_standing")
	Sleep(1)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	Sleep(1)
	
	if RemoveItems("","Pearlchain",1)>0 then	
		SetRepeatTimer("", GetMeasureRepeatName2("UsePearlChain"), TimeOut)
		AddImpact("","jewellery",1,duration)
		SetState("",STATE_JEWELLERY,true)

		SetProperty("","jewellery",3)
		
		chr_GainXP("",GetData("BaseXP"))
	end
	StopMeasure()
end

function Snuffle()
	Sleep(0.5)
	AlignTo("", "Owner")
	Sleep(2)
	PlayAnimation("", "cogitate")
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end

function CleanUp()
	
end



-- -----------------------------
--
-- This Part is for cutscenes 
--
-- -----------------------------

function Cutscene()

	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)

	--show particles
	GetPosition("Owner", "ParticleSpawnPos")
	if RemoveItems("","Pearlchain",1)>0 then
		GetPositionOfSubobject("","Game_Head","ParticleSpawnPos")
		
		SetRepeatTimer("", GetMeasureRepeatName2("UsePearlChain"), TimeOut)
		AddImpact("","jewellery",1,duration)
		SetState("",STATE_JEWELLERY,true)

		SetProperty("","jewellery",3)
		
		chr_GainXP("",GetData("BaseXP"))
	end
	StopMeasure()
end


