function Run() 

	f_WeakMoveTo("","Destination")
	
 	 MoveSetActivity("","drunk") 
Sleep(2)
 	 MoveSetActivity("")
 	 
	--ThrowObject("", "Destination", "Ships/Cannonballs4.nif",0.1, "Object", 1000, 1000, 0)
	--ThrowObject("", "Destination", "Ships/Cannonballs4.nif",0.1, "Object", -1000, 1000, 0)
	--ThrowObject("", "Destination", "Ships/Cannonballs4.nif",0.1, "Object", 500, 1000, 0)
	--ThrowObject("", "Destination", "Ships/Cannonballs4.nif",0.1, "Object", -500, 1000, 0) 
	--ThrowObject("", "Destination", "Ships/Cannonballs4.nif",0.1, "Object", 500, 500, 0)
	--ThrowObject("", "Destination", "Ships/Cannonballs4.nif",0.1, "Object", -500, 500, 0) 
	
	--ThrowObject("", "Destination", "Ships/Cannonballs4.nif",0.1, "Object", 1000, 250, 0)
	--ThrowObject("", "Destination", "Ships/Cannonballs4.nif",0.1, "Object", -1000, 250, 0)
	--ThrowObject("", "Destination", "Ships/Cannonballs4.nif",0.1, "Object", 250, 1000, 0)
	--ThrowObject("", "Destination", "Ships/Cannonballs4.nif",0.1, "Object", -250, 1000, 0) 
	--ThrowObject("", "Destination", "Ships/Cannonballs4.nif",0.1, "Object", 250, 250, 0)
	--ThrowObject("", "Destination", "Ships/Cannonballs4.nif",0.1, "Object", -250, 250, 0) 	

 
 	--GetOutdoorMovePosition("", "Destination", "Pos")
 	 
	--GetFleePosition("", "Destination", 200+Rand(50), "Away")
	--f_MoveTo("", "Away", GL_MOVESPEED_WALK)
	
	--GfxAttachObject("Horst","particles/flammen.nif")
	--AttachModel("", "Horst")
	--GfxSetPosition("Horst", -500, 0, 0, true)
	
	--GfxAttachObject("Trine","particles/flammen.nif")
	--AttachModel("", "Trine")
	--GfxSetPosition("Trine", 0, 0, 0, true)
	--GfxMoveToPosition("Trine", 5000, 0, 0, 5, true) 
	
	--f_Stroll("",3000.0,10.0)
	--Sleep(10)
 
	--local angle = GetRotation("", "Destination") 
	--angle = angle - ObjectGetRotationY("")
	
	--feedback_OverheadFadeText("", "@L%1t", false, angle)
	
	--GfxAttachObject("scheissendreck", "particles/build.nif")
	--GfxSetPosition("scheissendreck", 0, 100, 0, true)
	
	--GetSettlement("", "City")
	--CityGetRandomBuilding("City", -1, GL_BUILDING_TYPE_TOWNHALL, -1, -1, FILTER_IGNORE, "TH1")
	
	--BlockChar("Destination")
	-- Go to the bath
	--ai_Multif_MoveTo(GL_MOVESPEED_RUN, 50, "", "TH1", "Destination", "TH1")
	
	--AlignTo("", "Destination")
	--Sleep(1.0)
	--CarryObject("", "Handheld_Device/ANIM_Tailorbasket.nif", false)
	--PlayAnimationNoWait("", "throw")
	--Sleep(1.8)
	--CarryObject("", "" ,false)
	--local fDuration = ThrowObject("", "Destination", "Handheld_Device/ANIM_Tailorbasket.nif", -0.1)
	--Sleep(fDuration)	
	--ModifyHP("Destination", -10)
	
	--SimSetInvisible("Destination", true)
	--Sleep(10)
	--SimSetInvisible("Destination", false)
	
	--if not GetLocatorByName("Destination", "stroll1", "mypos") then
		--if not GetLocatorByName("Destination", "Stroll1", "mypos") then
			--return
		--end
	--end 
	--f_Follow("", "Destination", GL_MOVESPEED_RUN, 200)
	--Sleep(10)
	
	--local result = Plunder("","Destination", 1)
	--if (result == -2) then
	--	feedback_OverheadFadeText("", "Errör", false)
	--elseif (result == -1) then
	--	feedback_OverheadFadeText("", "Koi Platz me", false)
	--elseif (result == 0) then
	--	feedback_OverheadFadeText("", "Ziel hot koi Zeigs me nid", false)
	--else
	--	feedback_OverheadFadeText("", "Schee, i han was kriagt", false)
	--end		
end




