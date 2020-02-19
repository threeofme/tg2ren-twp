function Run()

	local CM = false
	local stage = GetData("#MusicStage")
	if GetAliasByID(stage,"stageobj") then
		if GetInsideBuildingID("")==GetID("stageobj") and HasProperty("stageobj","Versengold") then
			local result = InitData("@P"..
			"@B[1,@L%1l,@L%1l,Hud/Buttons/btn_Versengold.tga]"..
			"@B[2,@L%2l,@L%2l,Hud/Buttons/btn_EatDrink.tga]",
			-1,
			"@L_MESSAGES_UPCOMING_CONCERT_HEADER_+0",
			"@L_MEASURE_CheerMusicians_TOOLTIP_+0",
			"@L_MEASURE_CheerMusicians_NAME_+0",
			"@L_MEASURE_EatDrink_NAME_+0")
		
			if result==1 then
				CM = true
			end
		end
	end

	if CM==true then
		MeasureRun("", nil, "CheerMusicians")
	else

		local	laenge = InventoryGetSlotCount("", INVENTORY_STD)
		local	a, itemId, itemName, itemTexture, itemZahl
		local control = 0
		local 	btn = ""
		for a = 0, laenge-1 do
			itemId, itemZahl = InventoryGetSlotInfo("", a, InventoryType)
			if itemId and itemZahl > 0 then
		    SetData("Item",itemId)			
	      local j = 1
	      local Item = GetData("Item")
	      local eatList = { 20, 21, 22, 23, 25, 26, 27, 41, 42, 43, 44, 46, 123, 312, 314, 315, 403, 940, 941 }
	
	      repeat
		      if Item == eatList[j] then
		          j = 21
		      else
		        j = j + 1
				    if j == 19 then
				        j = 20
				    end
		      end
	      until j > 19
	      
	      if j == 20 then
	          SetData("Item",0)
	      end	
				if GetData("Item") ~= 0 then
			    itemId = GetData("Item")
					itemName = ItemGetName(itemId)
					itemTexture = "Hud/Items/Item_"..itemName..".tga"
					btn = btn.."@B["..itemId..",,@L_ITEM_"..itemName.."_NAME_+0,"..itemTexture.."]"
					control = 1
				end
			end
		end	
		if control > 0 then
	    local initLabel
	    initLabel = InitData("@P"..btn,"","@L_EATDRINK_TEXT_+0")
			SetData("Wahl",initLabel)
		else
			MsgQuick("","@L_EATDRINK_FEHLER_+0")
			StopMeasure()
		end
	
	  local caries, heal, HPPlus
		local eat = GetData("Wahl")
	
		--low chance for caries
	  if eat==20 or eat==22 or eat==941 then
	     local anym = PlayAnimationNoWait("","eat_standing")
	     Sleep(1)
	     CarryObject("", "Handheld_Device/ANIM_cake.nif", false)
	     PlaySound3D("","CharacterFX/eating/eating+2.ogg",1.0)
		   Sleep(anym-1)
		   CarryObject("","",false)
	     heal = 0
	     caries = 0
	     HPPlus = Rand(2) + 3
	     RemoveItems("",eat,1,INVENTORY_STD)
	
		--medium chance for caries
	  elseif eat==25 or eat==41 or eat==43 or eat==46 or eat==312 or eat==314 or eat==315 then
	     local anym = PlayAnimationNoWait("","eat_standing")
	     Sleep(1)
	     CarryObject("", "Handheld_Device/ANIM_cake.nif", false)
	     PlaySound3D("","CharacterFX/eating/eating+2.ogg",1.0)
		   Sleep(anym-1)
		   CarryObject("","",false)
	     heal = 0
	     caries = 3
	     HPPlus = Rand(5) + 3
	     RemoveItems("",eat,1,INVENTORY_STD)
	
		--highest chance for caries
	  elseif eat==21 or eat==23 or eat==26 or eat==27 or eat==940 then
	     local anym = PlayAnimationNoWait("","eat_standing")
	     Sleep(1)
	     CarryObject("", "Handheld_Device/ANIM_cake.nif", false)
	     PlaySound3D("","CharacterFX/eating/eating+2.ogg",1.0)
		   Sleep(anym-1)
		   CarryObject("","",false)
	     heal = 0
	     caries = 6
	     HPPlus = Rand(5) + 5
	     RemoveItems("",eat,1,INVENTORY_STD)
	
		--non alcoholic drink
	  elseif eat==123 then
	     local anym = PlayAnimationNoWait("","use_potion_standing")
	     Sleep(1)
		   CarryObject("", "Handheld_Device/ANIM_beaker.nif", false)
	     PlaySound3D("","CharacterFX/drinking/drinking+2.ogg",1.0)
		   Sleep(anym-1)
		   CarryObject("","",false)
	     heal = 1
	     caries = 0
	     HPPlus = Rand(3) + 3
	     RemoveItems("",eat,1,INVENTORY_STD)
	
		--alcoholic drink
	  elseif eat==42 or eat==44 or eat==403 then
	     local anym = PlayAnimationNoWait("","use_potion_standing")
	     Sleep(1)
		   CarryObject("", "Handheld_Device/ANIM_beaker.nif", false)
	     PlaySound3D("","CharacterFX/drinking/drinking+2.ogg",1.0)
		   Sleep(anym-1)
		   CarryObject("","",false)
	     heal = 0
	     caries = 0
	     HPPlus = Rand(3) + 3
	     RemoveItems("",eat,1,INVENTORY_STD)
	
	  end
	
	  ModifyHP("",HPPlus,true)
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
	     local ill = Rand(10)
	     if caries>=ill then
	        diseases_Caries("",true,true)
	        SetState("",STATE_SICK,true)
	        MsgSay("", "_EATDRINK_SPRUCH_+3")
	     end
	  elseif heal>0 then
	  	if GetImpactValue("","Caries")==1 then
		    local rnd = Rand(10)
		    if rnd<=heal then
					RemoveImpact("","Caries")
					RemoveImpact("","Sickness")
		      SetState("",STATE_SICK,false)
		      PlayAnimationNoWait("", "cheer_01")
		      MsgSay("", "_EATDRINK_SPRUCH_+4")
		    end
		  end
	  end
	end
end	

function CleanUp()
	StopAnimation("")
  StopMeasure()
end
