function Run()

	local Filter = "__F((Object.GetObjectsByRadius(Sim)==250)AND(Object.GetProfession()==42)AND(Object.HasProperty(Signal)))"
	local result = Find("", Filter,"Destination", -1)

	local spender = SimGetRank("")
	local spend
	if spender == 0 or spender == 1 then
	    spend = 10
	elseif spender == 2 then
	    spend = 25
	elseif spender == 3 then
	    spend = 35
	elseif spender == 4 then
	    spend = 50
	elseif spender == 5 then
	    spend = 100
	end

	local cash = GetMoney("") 	
	
	if cash < spend then
		MsgQuick("","@L_REN_MEASURE_PLAYTAROT_+0")
		StopMeasure()
	end	
	
	local destiny = MsgBox("Owner","Destination","@P"..
    "@B[A,@L_REN_MEASURE_PLAYTAROT_+1]"..
    "@B[B,@L_REN_MEASURE_PLAYTAROT_+2]",
    "@L_REN_MEASURE_PLAYTAROT_+3",
    "@L_REN_MEASURE_PLAYTAROT_+4",spend)	

	if destiny == "B" then
	    StopMeasure()
	else
	    GetDynasty("Destination","kasse")
	    f_CreditMoney("kasse",spend,"Offering")
	    --economy_UpdateBalance("kasse", "Service", spend)
        ShowOverheadSymbol("Destination",false,true,0,"%1t",spend)
        f_SpendMoney("Owner",spend,"Offering")
		
		local card = Rand(21)
		
	    MsgNewsNoWait("Owner","Destination","","intrigue",-1,"@L_REN_MEASURE_PLAYTAROT_HEAD_+"..card,
	                    "@L_REN_MEASURE_PLAYTAROT_BODY_+"..card)		
		
		ms_playtarot_TheDestiny(card)
		
	end

    local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	SetMeasureRepeat(TimeOut)
	
end

function TheDestiny(x)

	if x == 0 then
	    local g = Rand(3)+1
		local money = GetMoney("")
		local pay = (money / 100) * g
			if pay > 25 then
				pay = 25
			end
		f_SpendMoney("Owner",pay,"Offering")
		return
	
	elseif x == 1 then
	    local oneskill = Rand(10)+1
        local haveskill = GetSkillValue("Owner",oneskill)
        local getskill = haveskill + 1
        SetSkillValue("Owner",4,getskill)
		return
		
	elseif x == 8 then
	    local g = Rand(3)+1
		local money = GetMoney("")
		local pay = (money / 100) * g
			if pay > 25 then
				pay = 25
			end
		f_CreditMoney("Owner",pay,"Offering")
		return
		
	elseif x == 12 then
	    local oneskill = Rand(10)+1
        local haveskill = GetSkillValue("Owner",oneskill)
        local getskill = haveskill - 1
        SetSkillValue("Owner",4,getskill)
		return
		
	elseif x == 13 then
	    local Filter = "__F((Object.GetObjectsByRadius(Building)==20000)AND NOT(Object.BelongsToMe())AND(Object.HasDynasty()))"
	    Find("", Filter,"Opfer", -1)
		DynastyGetRandomVictim("Opfer",100,"Pest")
		diseases_Blackdeath("Pest",true,true)
		return
		
	elseif x == 15 then
	    GetDynasty("","Opfer")
		DynastyGetRandomBuilding("Opfer",-1,-1,"Brenne")
		SetState("Brenne",STATE_BURNING,true)
		return
		
	elseif x == 16 then
		DynastyGetRandomBuilding("Owner",-1,-1,"Brenne")
		SetState("Brenne",STATE_BURNING,true)
		return
		
	elseif x == 20 then
		DynastyGetRandomVictim("Owner",100,"Pest")
		diseases_Blackdeath("Pest",true,true)
		return
		
	else
	    return
	end
	
	return

end
	
function CleanUp()
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end