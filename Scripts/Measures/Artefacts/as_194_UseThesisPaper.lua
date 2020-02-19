-------------------------------------------------------------------------------
----
----	OVERVIEW "as_194_UseThesisPaper"
----
----	with this artifact, the player can try to change the faith of the sims 
----	in range to his own
----
-------------------------------------------------------------------------------


function Run()
	
	if IsStateDriven() then
		local ItemName = "ThesisPaper"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end
	
	--the effect range
	local EffectRange = 1000
	
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)

	--check if the artefact is ready to use
	if GetImpactValue("","thesispaper")==1 then
		StopMeasure()
	end
	
	--take the paper and read it
	local Time
	Time = PlayAnimationNoWait("","use_book_standing")
	Sleep(1)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	CarryObject("","Handheld_Device/Anim_openscroll.nif",false)
	Sleep(2)
	local OwnReligion = SimGetReligion("")
	if OwnReligion == 0 then
		MsgSayNoWait("", "@L_PROCLAIM_THESISPAPER_CATHOLIC")
	else
		MsgSayNoWait("", "@L_PROCLAIM_THESISPAPER_PROTESTANT")
	end
	Sleep(Time-5)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	CarryObject("","",false)
	
	local count = 0
	if RemoveItems("","ThesisPaper",1)>0 then
		--make SkillCheck and convert all sims of different religion in range to own religion
		GetPosition("", "MyPosition")
		--StartMagicalEffect("MyPosition","particles/aimingpoint.nif",1,0.1,0,EffectRange)
		count = Find("Owner", "__F((Object.GetObjectsByRadius(Sim) == "..EffectRange..") AND NOT(Object.HasSameReligion(Owner))","Sim", -1)
		for i=0,count-1 do 
			if GetSkillValue("",RHETORIC)>=GetSkillValue("Sim"..i,EMPATHY) then
				SimSetReligion("Sim"..i,SimGetReligion("Owner"))
				SendCommandNoWait("Sim"..i,"ConvertReligion")
				Sleep(1)
			end			
		end
		
		-- no sims of opposite religion to affect
		if (count==0) then
			feedback_OverheadComment("Owner", "@L_ARTEFACTS_OVERHEAD_+2", false, false)
		end
		SetRepeatTimer("", GetMeasureRepeatName2("UseThesisPaper"), TimeOut)
		chr_GainXP("",GetData("BaseXP"))
		AddImpact("","thesispaper",1,RepeatTime)
		
	end
end

-- -----------------------
-- ConvertReligion
-- -----------------------
function ConvertReligion()
	Sleep(0.5)
	AlignTo("", "Owner")
	Sleep(Rand(3)+1)

	MsgSayNoWait("", "@L_CHURCH_093_WINBELIEVERS_COMMENT_POSITIVE")
	PlayAnimation("","cogitate")
	
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	feedback_OverheadActionName("")
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time immediately
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+1",Gametime2Total(mdata_GetDuration(MeasureID)))
end

