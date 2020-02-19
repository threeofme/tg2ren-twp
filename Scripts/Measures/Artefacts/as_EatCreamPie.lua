-------------------------------------------------------------------------------
----
----	OVERVIEW "as_CreamPie.lua"
----
----	eating food gives the player small amounts of XP, heals and sometimes other boni. Beware: Some food have a chance of caries, but they give a sugar-speedboost by 25%! Default Cooldown: 6 hours.
---- 	You need to add entries into filter.dbt, measures.dbt and MeasureToObject.dbt

----	entries may look like this:
----	measures.dbt:
----	12104        "Artefacts\as_EatCreamPie.lua" ""                       "EatCreamPie"     55                       "hud/items/Item_CreamPie.tga" 0                 12             0                ""                 ""                      0                  6                    6                  "none"                   0                     0                        | 
----
----	filter.dbt:
----	1572         "CanEatCreamPie"    "__F((Object.CanBeControlled())AND(Object.GetItemCnt(CreamPie)>0)AND NOT(Object.GetState(fighting)))" |
----
----	MeasureToObjects.dbt:
----	3254         12104               0                       0                      1572                   6                ""                     ()                 ""                      0                           0                              |
-------------------------------------------------------------------------------

function Run()

	if IsStateDriven() then
		local ItemName = "CreamPie"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end

	local MeasureID = GetCurrentMeasureID("") 
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	local XP = 100
	local caries, heal, HPPlus
	
	if RemoveItems("","CreamPie",1)>0 then
		local anym = PlayAnimationNoWait("","eat_standing")
		Sleep(1)
		CarryObject("", "Handheld_Device/ANIM_cake.nif", false)
		PlaySound3D("","CharacterFX/eating/eating+2.ogg",1.0)
		Sleep(anym-1)
		CarryObject("","",false)
		caries = 2
		HPPlus = Rand(15) + 20
		SetMeasureRepeat(TimeOut)
		Sleep(1)
		IncrementXP("",XP)
		Sleep(1)
		ModifyHP("",HPPlus,false)
		if GetImpactValue("","Sugar")==0 then
			AddImpact("","MoveSpeed",1.25,duration)
			AddImpact("","Sugar",1,duration)
		end
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

		if caries>0 then
			local ill = 1+Rand(10)
			-- get sick if you are unlucky and have no protection.
			if caries>=ill then
				if GetImpactValue("","Sickness")==0 and GetImpactValue("","Resist")==0 then
					diseases_Caries("",true)
					MsgSay("", "_EATDRINK_SPRUCH_+3")
				end
			end
		end
	end
end


-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
StopAnimation("")
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))

end

