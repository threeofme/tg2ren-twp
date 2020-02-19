function Init()
end

function Say(character, samplename)

	TempFilename = "speech/"..samplename
	
	gender = GetValueString(character, "Gender")
	id = GetValueInt(character, "Object3D")
	
	-- check if it is a hero character
	kindofsim = GetValueString(character, "SimStatus")
	
	if(kindofsim == "PartySim") then
	
		-- voicevariation = math.mod(id, 3)
		-- voicevariation = voicevariation + 1
		-- Filename = TempFilename.."_H"..voicevariation.."_0"..Rand(2)..".wav"
		
		if(samplename == "Measures/Measure_PropelEmployees") then		
			Filename = TempFilename.."_H1".."_0"..Rand(2)..".wav"
		else
			Filename = TempFilename.."_H1".."_0"..Rand(7)..".wav"
		end
		
	else
	
		-- its a non-hero character		
		if(gender == "Male") then
		
			voicevariation = math.mod(id, 3)
			voicevariation = voicevariation + 1
			
			Filename = TempFilename.."_M"..voicevariation.."_0"..Rand(7)..".wav"
			
		else
		
			voicevariation = math.mod(id, 2)
			voicevariation = voicevariation + 1
			Filename = TempFilename.."_F"..voicevariation.."_0"..Rand(7)..".wav"
			
		end
		
	end
	
	-- LogText(Filename)
	PlaySound(Filename, 1.0, 1, "c3")

end


