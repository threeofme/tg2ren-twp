-------------------------------------------------------------------------------
----
----	Überblick "Weinessigessenz"
----
----	damit könnt ihr euch ein vorzeitiges Ende bereiten
----	Original by the Back To The Roots-Team, 2007
-------------------------------------------------------------------------------

function Run()

	if IsStateDriven() then
		local ItemName = "Weingeist"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end

-- Initialisierung der lokalen Variablen
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)

	local Time = PlayAnimationNoWait("","use_potion_standing")
	Sleep(1)
	PlaySound3D("","measures/usemead+0.wav", 1.0)
	CarryObject("","Handheld_Device/ANIM_perfumebottle.nif",false)
	Sleep(Time-2)
	CarryObject("","",false)
        Sleep(1)
								

	if RemoveItems("","Weingeist",1)>0 then
           PlayAnimationNoWait("", "cough")
	   PlaySound3DVariation("","CharacterFX/disease_seriously_cough", 1.0)
           Sleep(3)

        -- das Opfer nimmt erheblichen Schaden (100%)
        local HpMich = GetHP("")
        log_death("", "is committing suicide through spirit of wine (as_UseWeingeist)")
        ModifyHP("", -HpMich,true)
    end

	StopMeasure()

end