function Run()

    local check = 0
	local diceliste, dicewinner, dicepott, flagshow, diceloselist, dicelooser, dicepottlos, flagshowlos,drunkliste, drunkwinner,flagdrunk,drunkloseliste,drunklooser,flagpuke = "","","","","","","","","","","","","",""
 
    -- dice winner
    if HasProperty("","BestDicePlayer") then
        dicewinner = GetProperty("","BestDicePlayer")
	    dicepott = GetProperty("","BestDicePott")
	    flagshow = ""
	    ScenarioGetObjectByName("cl_Sim",dicewinner,"DiceChamp")
	    if GetDynasty("DiceChamp", "Dyn") and not DynastyIsShadow("Dyn") then
				local tmpflag = DynastyGetFlagNumber("Dyn") + 29
				flagshow = "@L$S[20"..tmpflag.."]"
	    end
		check = 1
		diceliste = "@L_DIVEHOUSE_CHAMPIONLIST_BODY_+1"
	end
	
	-- dice looser
	if HasProperty("","WorstDicePlayer") then
        dicelooser = GetProperty("","WorstDicePlayer")
	    dicepottlos = GetProperty("","WorstDicePott")
	    flagshowlos = ""
	    ScenarioGetObjectByName("cl_Sim",dicelooser,"DiceChamp")
	    if GetDynasty("DiceChamp", "Dyn") and not DynastyIsShadow("Dyn") then
				local tmpflag = DynastyGetFlagNumber("Dyn") + 29
				flagshowlos = "@L$S[20"..tmpflag.."]"
	    end
		check = 1
		diceloselist = "@L_DIVEHOUSE_CHAMPIONLIST_BODY_+2"
	end

	-- drunk winner
    if HasProperty("","BestDrunkPlayer") then
        drunkwinner = GetProperty("","BestDrunkPlayer")
	    flagdrunk = ""
	    ScenarioGetObjectByName("cl_Sim",drunkwinner,"DrunkChamp")
	    if GetDynasty("DrunkChamp", "Dyn") and not DynastyIsShadow("Dyn") then
				local tmpflag = DynastyGetFlagNumber("Dyn") + 29
				flagdrunk = "@L$S[20"..tmpflag.."]"
	    end
		check = 1
		drunkliste = "@L_DIVEHOUSE_CHAMPIONLIST_BODY_+3"
	end
	
	-- drunk looser
	if HasProperty("","WorstDrunkPlayer") then
        drunklooser = GetProperty("","WorstDrunkPlayer")
	    flagpuke = ""
	    ScenarioGetObjectByName("cl_Sim",drunklooser,"DrunkChamp")
	    if GetDynasty("DrunkChamp", "Dyn") and not DynastyIsShadow("Dyn") then
				local tmpflag = DynastyGetFlagNumber("Dyn") + 29
				flagpuke = "@L$S[20"..tmpflag.."]"
	    end
		check = 1
		drunkloseliste = "@L_DIVEHOUSE_CHAMPIONLIST_BODY_+4"
	end
	
	if check > 0 then	
	    MsgBoxNoWait("dynasty",false,
			"@L_DIVEHOUSE_CHAMPIONLIST_HEAD_+0",
			"@L_DIVEHOUSE_CHAMPIONLIST_BODY_+5",
			GetID("Owner"),diceliste,dicewinner,dicepott,flagshow,diceloselist,dicelooser,dicepottlos,flagshowlos,drunkliste,drunkwinner,flagdrunk,drunkloseliste,drunklooser,flagpuke)
	else
	    MsgBoxNoWait("dynasty",false,
			"@L_DIVEHOUSE_CHAMPIONLIST_HEAD_+0",
			"@L_DIVEHOUSE_CHAMPIONLIST_BODY_+0",
			GetID("Owner"))
	end
end
