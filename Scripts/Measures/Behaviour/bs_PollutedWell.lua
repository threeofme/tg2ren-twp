function Run()
	
	if GetProperty("Actor", "PollutedWell") == 1 then
		-- mod by Fajeth: Poisoned Well makes sick! Illness based on Difficulty
			if IsType("","Sim") then
				if GetImpactValue("", "Sickness")==0 and GetItemCount("","Soap")==0 then -- check if they are already ill or have soap in their inventory
					local zuf = Rand(100) +1
				
					if zuf>90 then
						diseases_Influenza("",true)
					else
						diseases_Cold("",true)
					end
				end
			end
		-- Mod end
			
	end

	return ""
end

function CleanUp()
	
end
