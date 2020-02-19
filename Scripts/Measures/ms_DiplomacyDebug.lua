function Run()
	local result = MsgBox("","Destination","@P"..
						"@B[1,DynastyCalcStrength]"..
						"@B[2,DynastyCalcThreat]"..
						"@B[3,DynastyCheckForRival]"..
						"@B[4,DynastyGetBestDiplomacyState]",
						"AI Debug Measure",
						"Welche AI Measure soll getestet werden?")
						
	if result == 1 then
		GetDynasty("","MyDyn")
		GetDynasty("Destination","TargetDyn")
		local MyStrength = ai_DynastyCalcStrength("MyDyn")
		local TargetStrength = ai_DynastyCalcStrength("TargetDyn")
		
		MsgBoxNoWait("","Destination","DynastyCalcStrength","Meine Strength ist "..MyStrength.."  $N$NSeine Strength ist: "..TargetStrength.."")

	elseif result == 2 then
		GetDynasty("","MyDyn")
		GetDynasty("Destination","TargetDyn")
		local Threat = ai_DynastyCalcThreat("TargetDyn","MyDyn")
		local Threat2 = ai_DynastyCalcThreat("MyDyn","TargetDyn")
	
		MsgBoxNoWait("","Destination","DynastyCalcThreat","Mein Bedrohungslevel aus seiner Sicht ist "..Threat.."$N$N Sein Bedrohungslevel aus meiner Sicht ist "..Threat2.."")

	elseif result == 3 then
		GetDynasty("","MyDyn")
		GetDynasty("Destination","TargetDyn")
		local Rival = ai_DynastyCheckForRival("TargetDyn","MyDyn")
	
		MsgBoxNoWait("","Destination","DynastyCheckForRival","Rival Wert ist: "..Rival.."")

	elseif result == 4 then
		GetDynasty("","MyDyn")
		GetDynasty("Destination","TargetDyn")
		local State = ai_DynastyGetBestDiplomacyState("TargetDyn","MyDyn")
	
		MsgBoxNoWait("","Destination","DynastyGetBestDiplomacyState","Bester State aus seiner Sicht für mich ist: "..State.."")
	end
end

function CleanUp()

end

