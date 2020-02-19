function Run()
	if not BuildingGetOwner("Destination","BuildingOwner") then
		return
	end

	if GetImpactValue("Destination",391) == 0 then
		local wahl
		if chr_DynastyGetFameLevel("BuildingOwner") <= 1 then
		    wahl = "S0"
		elseif chr_DynastyGetFameLevel("BuildingOwner") <= 3 then
		    wahl = "S1"
		elseif chr_DynastyGetFameLevel("BuildingOwner") <= 4 then
		    wahl = "S2"
		elseif chr_DynastyGetFameLevel("BuildingOwner") <= 5 then
		    wahl = "S3"
		end

		if DynastyIsPlayer("BuildingOwner") then
			SetProperty("Destination","ArbeiterOrder",1)
	    ms_bauzusatz_ArbeiterGen(wahl)
		else
			local robobau = ms_bauzusatz_AIWahl()
			ms_bauzusatz_ArbeiterGen(robobau)
		end
	else
		MsgQuick("BuildingOwner","@L_HPFZ_STATE_GEBBAU_FEHLER_+0")
	end
	
	return
						  
end

function AIWahl()
	if not BuildingGetOwner("Destination","BuildingOwner") then
		return
	end

	if chr_DynastyGetFameLevel("BuildingOwner") <= 1 then
		return "S0"
	elseif chr_DynastyGetFameLevel("BuildingOwner") <= 3 then
		return "S1"
	elseif chr_DynastyGetFameLevel("BuildingOwner") <= 4 then
		return "S2"
	elseif chr_DynastyGetFameLevel("BuildingOwner") <= 5 then
		return "S3"
	else
	    return "S"..Rand(2)
	end

end	

function ArbeiterGen(wahl)
	
	local manstuff = {}
	if wahl == "S0" then
	    manstuff = { 0, 2, 675, 675 }
	elseif wahl == "S1" then
	    manstuff = { 1, 2, 780, 780 }
	elseif wahl == "S2" then
	    manstuff = { 1, 3, 780, 780, 924 }
	elseif wahl == "S3" then
	    manstuff = { 1, 4, 713, 713, 803, 925 }
	end

	-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	local baufast = manstuff[1] + manstuff[2]
	SetProperty("Destination","baufast",baufast)
	
	FindNearestBuilding("Destination",1,1,-1,false,"ArbeiterHeim")
	local check = 3
	local nerv = manstuff[2]
	for l=1, nerv do
	  SimCreate(manstuff[check],"Destination","Destination","BauArbeiter"..l)
		SetHomeBuilding("BauArbeiter"..l,"ArbeiterHeim")
		local name = GetName("BauArbeiter"..l)
		local y,z = string.find(name, " ")
		local newlastname = string.sub(name, 1 , y)
		local wtitle = manstuff[1]
		if check == 5 and manstuff[2] == 3 then
		    wtitle = wtitle + 1
		elseif check == 6 then
		    wtitle = wtitle + 2
		end
		SimSetFirstname("BauArbeiter"..l, "@L_NPC_PEON_NAME_+"..wtitle)
		SimSetLastname("BauArbeiter"..l, newlastname)	
	    SetState("BauArbeiter"..l,STATE_TOWNNPC,true)
		-- if l == manstuff[2] then
			-- if not f_MoveTo("BauArbeiter"..l,"Destination",GL_MOVESPEED_RUN,100) then
				-- SimBeamMeUp("BauArbeiter"..l,"Destination",false)
				-- Sleep(20)
			-- end
			-- --[[AddImpact("Destination",391,baufast,-1)
			-- MeasureRun("BauArbeiter"..l, "Destination", "BauArbeitMeasure", true)]]
		-- else
	        -- if not f_MoveToNoWait("BauArbeiter"..l,"Destination",GL_MOVESPEED_RUN,100) then
				-- SimBeamMeUp("BauArbeiter"..l,"Destination",false)
				-- Sleep(20)
			-- end
            -- Sleep(2)
			-- --[[AddImpact("Destination",391,baufast,-1)
			-- MeasureRun("BauArbeiter"..l, "Destination", "BauArbeitMeasure", true)]]
		-- end
		MeasureCreate("Measure"..l)
		if not MeasureStart("Measure"..l, "BauArbeiter"..l, "Destination", "BauArbeitMeasure", true) then

		end
		check = check + 1
	end
end
