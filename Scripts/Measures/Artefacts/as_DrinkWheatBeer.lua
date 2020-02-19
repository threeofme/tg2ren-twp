-------------------------------------------------------------------------------
----
----	OVERVIEW "as_DrinkWheatBeer.lua"
----
----	Drinking gives you XP and can heal you in case of herbtea. Alcoholic drinks give you more XP
----	but will make you drunk, if your constitution is too low. Drink measures have no cooldown
---- 	You need to add entries into filter.dbt, measures.dbt and MeasureToObject.dbt
----
-------------------------------------------------------------------------------

function Run()

	if IsStateDriven() then
		local ItemName = "WheatBeer"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end

	local MeasureID = GetCurrentMeasureID("") 
	--local TimeOut = mdata_GetTimeOut(MeasureID)
	local XP = 20
	
	if RemoveItems("","WheatBeer",1)>0 then
	
		local anym = PlayAnimationNoWait("","use_potion_standing")
		Sleep(1)
		CarryObject("", "Handheld_Device/ANIM_beaker.nif", false)
		PlaySound3D("","CharacterFX/drinking/drinking+2.ogg",1.0)
		Sleep(anym-1)
		CarryObject("","",false)

	--	SetMeasureRepeat(TimeOut)
		if GetSkillValue("",CONSTITUTION) <10 then
		chr_GainXP("",XP)
		else
		MsgNewsNoWait("","","","intrigue",-1,"@L_DRINKALC_ERROR_HEAD_+0", "@L_DRINKALC_ERROR_BODY_+0")
		end
		Sleep(0.5)
		local zufall = Rand(4)
	
		if zufall==0 then
		MsgSay("", "_EATDRINK_SPRUCH_+0")
		elseif zufall==1 then
		MsgSay("", "_EATDRINK_SPRUCH_+1")
		elseif zufall==2 then
		MsgSay("", "_EATDRINK_SPRUCH_+2")
		elseif zufall==3 then
		PlaySound3D("","Locations/tavern_burp/tavern_burp_04.wav",1.0)
		end
		if GetSkillValue("",CONSTITUTION) < Rand(10) and GetImpactValue("","alc")==0 then
			MsgNewsNoWait("","","","intrigue",-1,"@L_DRINKALC_WARNING_HEAD_+0", "@L_DRINKALC_WARNING_BODY_+0")
			AddImpact("","alc",1,6)
		elseif GetSkillValue("",CONSTITUTION) < Rand(10) and GetImpactValue("","alc")==1 then
			MsgNewsNoWait("","","","intrigue",-1,"@L_DRINKALC_FAIL_HEAD_+0", "@L_DRINKALC_FAIL_BODY_+0")
			RemoveImpact("","alc")
			AddImpact("","totallydrunk",1,4)
			AddImpact("","MoveSpeed",0.7,4)
			SetState("",STATE_TOTALLYDRUNK,true)
		end
	
	end
	
	StopMeasure()
end


-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
StopAnimation("")
end

function GetOSHData(MeasureID)
	--can be used again in:
--	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	--OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))

end

