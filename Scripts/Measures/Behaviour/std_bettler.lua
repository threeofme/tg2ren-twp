function Init()

	SetState("",STATE_TOWNNPC,true)
	MoveSetActivity("","sick")
	BaseFE("", "sad", 1.0, -1)
	SimSetMortal("", false)
	
end

function Run()

    while true do
	    local offset = math.mod(GetID("Owner"), 30) * 0.1
	    local zielArt
		local zielTyp
		if GetSettlement("","PennerCity") then
		    SetData("CityInfo","PennerCity")
	        local RandVal = Rand(4)
	        if RandVal == 1 then
			    zielArt = 5
				zielTyp = -1
		    elseif RandVal == 2 then
			    zielArt = 2
				zielTyp = -1
		    elseif RandVal == 0 then
			    zielArt = 3
				local suchOrt = Rand(4)
				if suchOrt == 0 then
				    zielTyp = 26
				elseif suchOrt == 1 then
				    zielTyp = 23
				elseif suchOrt == 2 then
				    zielTyp = 25
				elseif suchOrt == 3 then
				    zielTyp = 27
				end
			elseif RandVal == 3 then
			    zielArt = 1
				zielTyp = -1 --2
		    end	
		    if CityGetRandomBuilding("PennerCity", zielArt, zielTyp, -1, -1, FILTER_IGNORE, "ZielHaus") then
			    SetData("HausInfo","ZielHaus")
			    if GetOutdoorMovePosition("", "ZielHaus", "MoveToPosition") then
				    f_MoveTo("","MoveToPosition", GL_MOVESPEED_WALK, 400+offset*15)				
					if RandVal == 1 then
					    std_bettler_marktreaktion()
					elseif RandVal == 2 then
					    std_bettler_betriebreaktion()
					elseif RandVal == 0 then
					    std_bettler_stadtreaktion()
					elseif RandVal == 3 then
					    std_bettler_hausreaktion()
					end
                end
			end
		end
		Sleep(2)
	end
	
end

function marktreaktion()

	local zFall = Rand(4)
	if zFall == 1 then
		local beweg = PlayAnimationNoWait("","propel")
		MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+0")
	elseif zFall == 2 then
		local beweg = PlayAnimationNoWait("","talk")
		MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+1")
		Sleep(4)
		MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+2")
		Sleep(4)
	elseif zFall == 3 then
		local beweg = PlayAnimationNoWait("","talk")
		MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+3")
		Sleep(4)
		MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+4")
		Sleep(4)
		MsgSayNoWait("","@L_HPFZ_BETTLER_SPRUCH_+5")
	else
		MsgSayNoWait("","@L_HPFZ_BETTLER_SPRUCH_+6")
	    PlayAnimation("","knee_work_in")
        LoopAnimation("","knee_work_loop",8)
        PlayAnimation("","knee_work_out")
		local beweg = PlayAnimationNoWait("","eat_standing")
        MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+7")
    end	
    Sleep(beweg)	

end

function betriebreaktion()

    local dasHaus = GetData("HausInfo")
	local zFall = Rand(4)
	if zFall == 1 then
	    local beweg = PlayAnimationNoWait("","propel")
		if not BuildingGetOwner(dasHaus,"Besitzer") then
			MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+8")
		else
			MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+9",GetID("Besitzer"))
		end
	elseif zFall == 2 then
		local beweg = PlayAnimationNoWait("","talk")
		MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+10")
	elseif zFall == 3 then
		local beweg = PlayAnimationNoWait("","talk")
		if not BuildingGetOwner(dasHaus,"Besitzer") then
			MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+11")
		else
			local klasse = SimGetClass("Besitzer")
			local klNam
			if klasse == 1 then
			    klNam = "Patron"
		        MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+12",klNam)
			elseif klasse == 2 then
			    klNam = "Handwerker"
			    MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+12",klNam)
			elseif klasse == 3 then
			    klNam = "Gelehrter"
			    MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+12",klNam)
			elseif klasse == 4 then
			    klNam = "Gauner"
			    MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+12",klNam)
			end
	    end
	else
		local beweg = PlayAnimationNoWait("","propel")
		if not BuildingGetOwner(dasHaus,"Besitzer") then
			MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+13")
	    else
			local seinHaus = SimGetLastname("Besitzer")
		    MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+14",GetID("Besitzer"))
	    end
	end
	Sleep(beweg)

end

function stadtreaktion()

    local dieStadt = GetData("CityInfo")
	local beweg = PlayAnimationNoWait("","propel")
	local zFall = Rand(4)
	if zFall == 1 then
	    MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+15")
		Sleep(4)
		MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+16")
		Sleep(4)
		MsgSayNoWait("","@L_HPFZ_BETTLER_SPRUCH_+17")
	elseif zFall == 2 then
	    MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+18")
		Sleep(4)
		MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+19")
		Sleep(4)
		MsgSayNoWait("","@L_HPFZ_BETTLER_SPRUCH_+20")
	elseif zFall == 3 then
	
		local citylvl = CityGetLevel(dieStadt)
		if citylvl == 2 then
			if GetOfficeTypeHolder(dieStadt,1,"Amtsmann") then
			    local dingens = SimGetGender("Amtsmann")
			    if dingens == 1 then
					MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+21",GetID("Amtsmann"))
				else
					MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+22",GetID("Amtsmann"))
				end
			else
	            MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+23")
			end
		elseif citylvl == 3 then
			if GetOfficeTypeHolder(dieStadt,1,"Amtsmann") then
				local dingens = SimGetGender("Amtsmann")
				if dingens == 1 then
					MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+24",GetID("Amtsmann"))
				else
					MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+25",GetID("Amtsmann"))
				end
			else
				MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+26")
			end
		elseif citylvl == 4 then
			if GetOfficeTypeHolder(dieStadt,1,"Amtsmann") then
				local dingens = SimGetGender("Amtsmann")
				if dingens == 1 then
					MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+27",GetID("Amtsmann"))
				else
					MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+28",GetID("Amtsmann"))
				end
			else
				MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+29")
			end
		elseif citylvl == 5 then
			if GetOfficeTypeHolder(dieStadt,1,"Amtsmann") then
				local dingens = SimGetGender("Amtsmann")
				if dingens == 1 then
					MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+30",GetID("Amtsmann"))
				else
					MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+31",GetID("Amtsmann"))
				end
			else
				MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+32")
			end
		elseif citylvl == 6 then
			if GetOfficeTypeHolder(dieStadt,1,"Amtsmann") then
				local dingens = SimGetGender("Amtsmann")
				if dingens == 1 then
					MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+33",GetID("Amtsmann"))
				else
					MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+34",GetID("Amtsmann"))
				end
			else
				MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+35")
			end	
        end		    
	else
	    MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+36")
	end
	Sleep(beweg)

end

function hausreaktion()

    local dasHaus = GetData("HausInfo")
	local zFall = Rand(4)
	if zFall == 0 then
		local beweg = PlayAnimationNoWait("","propel")
        if not BuildingGetOwner(dasHaus,"Besitzer") then
			MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+37")
		else
			local dingens = SimGetGender("Besitzer")
			if dingens == 1 then
			    MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+38",GetID("Besitzer"))
			else
			    MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+39",GetID("Besitzer"))
			end
		end
	elseif zFall == 1 then
	    local hausLvl = BuildingGetLevel(dasHaus)
		if hausLvl == 1 then
		    local beweg = PlayAnimationNoWait("","cheer_01")
		    MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+40")
		elseif hausLvl == 2 then
			local beweg = PlayAnimationNoWait("","cheer_01")
			MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+41")
		elseif hausLvl == 3 then
			local beweg = PlayAnimationNoWait("","talk")
			MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+42")
		elseif hausLvl == 4 then
			local beweg = PlayAnimationNoWait("","talk")
			MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+43")
		elseif hausLvl == 5 then
			local beweg = PlayAnimationNoWait("","propel")
			MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+44")
		end
	elseif zFall == 2 then
        local dasHaus = GetData("HausInfo")
		local spende = 0
        if BuildingGetOwner(dasHaus,"Besitzer") then
		    if DynastyIsPlayer("Besitzer") then
			    local begchances = Rand(10)
				if BuildingHasUpgrade(dasHaus,593) then
				    begchances = Rand(40)
				end
				if BuildingHasUpgrade(dasHaus,598) then
				    begchances = Rand(80)
				end
				if begchances < 8 then
				    PlayAnimationNoWait("","talk")
				    MsgSay("","@L_HPFZ_BETTLER_BETTELT_+0")
			        local betrag = Rand(50)+5
			        f_SpendMoney("Besitzer", betrag, "CostBribes")
				    MsgNewsNoWait("Besitzer","","","default",-1,"@L_HPFZ_BETTLER_ANFRAGE_+3","@L_HPFZ_BETTLER_ANFRAGE_+6",betrag)
				end
			end
				local beweg = PlayAnimationNoWait("","cheer_01") 
				MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+45")
        end	
	else
		MsgSayNoWait("","@L_HPFZ_BETTLER_SPRUCH_+48")
		PlayAnimation("","sit_down_ground")
		MoveSetStance("",GL_STANCE_LAYGROUND)
		local pennen = 1
		while pennen < 15 do
			Sleep(2)
			pennen = pennen + 1
		end
		local beweg = MoveSetStance("",GL_STANCE_STAND)
        MsgSay("","@L_HPFZ_BETTLER_SPRUCH_+49")
	end
    Sleep(beweg)
	
end

function CleanUp()
	MoveSetActivity("","")
	FadeOutFE("","sad",1.0,-1)
end
