function onEnter() 
	--LogText("ms_DiseasedBuilding::onEnter")
	if CheckSkill("",1,4) then
		if IsDynastySim("") then
			if not (GetImpactValue("","Cold")==1) then
				diseases_Cold("",true)
				feedback_MessageCharacter("","@L_ARTEFACTS_178_USETOADSLIME_MSG_VICTIM_DYNSIM_HEAD_+0",
							"@L_ARTEFACTS_178_USETOADSLIME_MSG_VICTIM_DYNSIM_BODY_+0",GetID(""))
			end
		else
			if not GetState("",STATE_BLACKDEATH) then
				diseases_Fever("",true)
				feedback_MessageCharacter("","@L_ARTEFACTS_178_USETOADSLIME_MSG_VICTIM_WORKER_HEAD_+0",
							"@L_ARTEFACTS_178_USETOADSLIME_MSG_VICTIM_WORKER_BODY_+0",GetID(""))
				--SimStopMeasure("")
			end
		end			
	end
end

function onExit()
	--LogText("ms_DiseasedBuilding::onExit")
	if CheckSkill("",1,4) then
		if IsDynastySim("") then
			if not (GetImpactValue("","Cold")==1) then
				diseases_Cold("",true)
				feedback_MessageCharacter("","@L_ARTEFACTS_178_USETOADSLIME_MSG_VICTIM_DYNSIM_HEAD_+0",
							"@L_ARTEFACTS_178_USETOADSLIME_MSG_VICTIM_DYNSIM_BODY_+0",GetID(""))
			end
		else
			if not GetState("",STATE_BLACKDEATH) then
				diseases_Fever("",true)
				feedback_MessageCharacter("","@L_ARTEFACTS_178_USETOADSLIME_MSG_VICTIM_WORKER_HEAD_+0",
							"@L_ARTEFACTS_178_USETOADSLIME_MSG_VICTIM_WORKER_BODY_+0",GetID(""))
				--SimStopMeasure("")
			end
		end			
	end
end
