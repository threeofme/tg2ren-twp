function Run()

	local cash = GetMoney("") 	
	
	if cash < 100 then
		MsgQuick("","@L_MEASURE_DRUNKGAME_FAIL_+0")
		StopMeasure()
	end
	
	local vorab, regeln
	
	vorab = MsgBox("",false,"@P"..
		"@B[A,@L_MEASURE_DRUNKGAME_STUFF_+0]"..
		"@B[B,@L_MEASURE_DRUNKGAME_STUFF_+1]"..
		"@B[C,@L_MEASURE_DRUNKGAME_STUFF_+2]",
		"@L_MEASURE_DRUNKGAME_HEAD_+0",
		"@L_MEASURE_DRUNKGAME_BODY_+0")

	if vorab == "B" then
		regeln = MsgBox("",false,"@P"..
		"@B[B,@L_MEASURE_DRUNKGAME_STUFF_+0]"..
		"@B[C,@L_MEASURE_DRUNKGAME_STUFF_+2]",
		"@L_MEASURE_DRUNKGAME_HEAD_+0",
		"@L_MEASURE_DRUNKGAME_STUFF_+3")
	end
		
	if vorab == "C" or regeln == "C" then
		StopMeasure()
	end
		
	local label = ""
	local trunk = {"SmallBeer","WheatBeer","Piratengrog","Schadelbrand"}
	local alctextur
	for h=1, 4 do
		label = label.."@B["..trunk[h]..",@L_ITEM_"..trunk[h].."_NAME_+0]"
	end

	GetInsideBuilding("Owner","Tave")
	GetFreeLocatorByName("Tave","Bar",1,4,"SitPos")
	f_BeginUseLocator("Owner","SitPos",GL_STANCE_STAND,true)

	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	SetMeasureRepeat(TimeOut)
	
	local alcpegel = 0
	local gamepoints = 0
	local kosten
	local punktestand = 0
	local konstiskill = GetSkillValue("",CONSTITUTION)
	local secretkill = GetSkillValue("",SECRET_KNOWLEDGE)
	local alcboni = konstiskill + secretkill
	local alcstand = ""
	local trunkwahl
	
	repeat
	
	    trunkwahl = MsgBox("",false,"@P"..
	    label..
	    "@B[77,@L_MEASURE_DRUNKGAME_STUFF_+5]",
	    "@L_MEASURE_DRUNKGAME_STUFF_+4",
	    "@L_MEASURE_DRUNKGAME_STUFF_+6",20,40,60,80,alcstand)
		
		if trunkwahl == "SmallBeer" then
		    kosten = 5
			gamepoints = 2
			alcpegel = (alcpegel + (Rand(3)+4)) - alcboni
		elseif trunkwahl == "WheatBeer" then
		    kosten = 10
			gamepoints = 5
			alcpegel = (alcpegel + (Rand(5)+11)) - alcboni	
		elseif trunkwahl == "Piratengrog" then
		    kosten = 20
			gamepoints = 10
			alcpegel = (alcpegel + (Rand(10)+21)) - alcboni
		elseif trunkwahl == "Schadelbrand" then
		    kosten = 50
			gamepoints = 20
			alcpegel = (alcpegel + (Rand(20)+41)) - alcboni
		end

	    if cash < kosten then
		    MsgQuick("","@L_MEASURE_DRUNKGAME_FAIL_+0")
		    StopMeasure()
	    end		

		if trunkwahl ~= 77 then
			CreditMoney("Tave",kosten,"Offering")
			economy_UpdateBalance("Tave", "Service", kosten)
			SpendMoney("Owner",kosten,"Offering")
            if alcpegel <= 40 then
			    MsgSayNoWait("","@L_MEASURE_DRUNKGAME_SPRUCHA")
			    local dowas = PlayAnimationNoWait("","use_potion_standing")
		        Sleep(1)
		        CarryObject("","Handheld_Device/ANIM_beaker.nif",false)
				PlaySound3DVariation("","CharacterFX/drinking",1.0)
		        Sleep(dowas-2)
		        CarryObject("","",false)
				alcstand = "@L_MEASURE_DRUNKGAME_STUFF_+7"
			elseif alcpegel > 40 and alcpegel <= 70 then
			    MsgSayNoWait("","@L_MEASURE_DRUNKGAME_SPRUCHB")
			    Sleep(1)
				local dowas = PlayAnimationNoWait("","clink_glasses")
				Sleep(1)
				CarryObject("","Handheld_Device/ANIM_beaker.nif",false)
				Sleep(dowas-2)
	            if SimGetGender("") == 1 then
		            PlaySound3DVariation("","CharacterFX/male_belch",1)
	            else
		            PlaySound3DVariation("","CharacterFX/female_belch",1)
	            end
				CarryObject("","",false)
				alcstand = "@L_MEASURE_DRUNKGAME_STUFF_+8"
			elseif alcpegel > 70 and alcpegel <= 100 then
			    MsgSayNoWait("","@L_MEASURE_DRUNKGAME_SPRUCHC")
			    Sleep(1)
				local dowas = PlayAnimationNoWait("","clink_glasses")
				Sleep(1)
				CarryObject("","Handheld_Device/ANIM_beaker.nif",false)
				Sleep(dowas-2)
	            if SimGetGender("") == 1 then
		            PlaySound3DVariation("","CharacterFX/male_belch",1)
	            else
		            PlaySound3DVariation("","CharacterFX/female_belch",1)
	            end
				CarryObject("","",false)
				alcstand = "@L_MEASURE_DRUNKGAME_STUFF_+9"
			elseif alcpegel > 100 then
			    local dowas = PlayAnimationNoWait("","use_potion_standing")
		        Sleep(1)
		        CarryObject("","Handheld_Device/ANIM_beaker.nif",false)
				PlaySound3DVariation("","CharacterFX/drinking",1.0)
		        Sleep(dowas-2)
		        CarryObject("","",false)
			    RemoveImpact("","littledrunk")
				RemoveImpact("","MoveSpeed")
				SetState("",65,false)
	            local winnername = GetName("")
	            SetProperty("Tave","WorstDrunkPlayer",winnername)
		        AddImpact("","totallydrunk",1,6)
			    AddImpact("","MoveSpeed",0.7,6)
			    SetState("",STATE_TOTALLYDRUNK,true)
			    -- Nachricht
          BuildingGetOwner("Tave","TaveCHef")

					chr_ModifyFavor("TaveCHef","",-10)
          MsgNewsNoWait("","Tave","","default",-1,"@L_MEASURE_DRUNKGAME_FAIL_HEAD_+0",
	                    "@L_MEASURE_DRUNKGAME_FAIL_BODY_+0")

			    StopMeasure()
		    end
			punktestand = punktestand + gamepoints
        end		
				
	until trunkwahl == 77
	
	if punktestand == 0 then
	    local winnername = GetName("")
	    SetProperty("Tave","WorstDrunkPlayer",winnername)
	else
	    if not HasProperty("Tave","BestDrunkPlayer") then
	        local winnername = GetName("")
	        SetProperty("Tave","BestDrunkPlayer",winnername)
		    SetProperty("Tave","BestDrunkPoints",punktestand)
	    else
	        local altwinner = GetProperty("Tave","BestDrunkPoints")
		    if punktestand > altwinner then
	            local winnername = GetName("")
	            SetProperty("Tave","BestDrunkPlayer",winnername)
		        SetProperty("Tave","BestDrunkPoints",punktestand)
		    end
	    end
		chr_GainXP("",GetData("BaseXP"))
	end
	
	StopMeasure()
	
end

function CleanUp()
	f_EndUseLocator("Owner","DicePlayer",GL_STANCE_STAND)
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end