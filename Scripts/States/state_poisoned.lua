function Init()
end

function Run()
	log_death("", " has been poisoned (state_poisoned)")
	if IsType("","Sim") then
		if GetImpactValue("","poisoned")==1 then
			while GetImpactValue("","poisoned")>0 do
				if GetProperty("", "poisoned") == 3 then
					GetPosition("", "ParticleSpawnPos")
					StartSingleShotParticle("particles/bloodsplash.nif", "ParticleSpawnPos", 1, 3.0)
					ModifyHP("",-5,true)
					Sleep(20)
				else
					Sleep(5)
				end
			end
			StopAction("poisoned", "")
			SetState("",STATE_POISONED,false)
			return
		end
	end
end

function CleanUp()
	SetState("Owner", STATE_POISONED, false)
	if GetProperty("Owner", "poisoned") == 2 then
		RemoveImpact("Owner", "MoveSpeed")
	end
	RemoveProperty("Owner","poisoned")
end

