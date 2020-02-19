-------------------------------------------------------------------------------
----
----	OVERVIEW "as_UsePastry.lua"
----
-------------------------------------------------------------------------------

function Run()

	if IsStateDriven() then
		local ItemName = "Pastry"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end

	local MeasureID = GetCurrentMeasureID("") 
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	local XP = 200
	
	if RemoveItems("","Pastry",1)>0 then
	
		local anym = PlayAnimationNoWait("","eat_standing")
		Sleep(1)
		CarryObject("", "Handheld_Device/ANIM_cake.nif", false)
		PlaySound3D("","CharacterFX/eating/eating+2.ogg",1.0)
		Sleep(anym-1)
		CarryObject("","",false)
		SetMeasureRepeat(TimeOut)
		Sleep(1)
		chr_GainXP("",XP)
		Sleep(1)
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
		
		Sleep(1)
		
		if DynastyIsPlayer("") then
			GetPosition("","ParticleSpawnPos")
			StartSingleShotParticle("particles/pray_glow.nif","ParticleSpawnPos",1,4)
			PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
		end
		
		if Rand(10) == 0 then
			local YearsToLive = 1 + Rand(3)
			AddImpact("","LifeExpanding",YearsToLive,-1)
			ShowOverheadSymbol("", false, true,"OverheadSymbolID","@L_LIFE_EXPANDING_OVERHEAD",YearsToLive)
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
end

