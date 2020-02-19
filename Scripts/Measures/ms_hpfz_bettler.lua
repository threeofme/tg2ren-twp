function Run()

    while GetState("",56)==true do
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
					    ms_hpfz_bettler_marktreaktion()
					elseif RandVal == 2 then
					    ms_hpfz_bettler_betriebreaktion()
					elseif RandVal == 0 then
					    ms_hpfz_bettler_stadtreaktion()
					elseif RandVal == 3 then
					    ms_hpfz_bettler_hausreaktion()
					end
                end
			end
		end
	end
	
end

function marktreaktion()

	local zFall = Rand(4)
	if zFall == 1 then
		local beweg = PlayAnimationNoWait("","propel")
		MsgSay("","_HPFZ_BETTLER_SPRUCH_+0")
	elseif zFall == 2 then
		local beweg = PlayAnimationNoWait("","talk")
		MsgSay("","_HPFZ_BETTLER_SPRUCH_+1")
		Sleep(4)
		MsgSay("","_HPFZ_BETTLER_SPRUCH_+2")
		Sleep(4)
	elseif zFall == 3 then
		local beweg = PlayAnimationNoWait("","talk")
		MsgSay("","_HPFZ_BETTLER_SPRUCH_+3")
		Sleep(4)
		MsgSay("","_HPFZ_BETTLER_SPRUCH_+4")
		Sleep(4)
		MsgSayNoWait("","_HPFZ_BETTLER_SPRUCH_+5")
	else
		MsgSayNoWait("","_HPFZ_BETTLER_SPRUCH_+6")
	    PlayAnimation("","knee_work_in")
        LoopAnimation("","knee_work_loop",8)
        PlayAnimation("","knee_work_out")
		local beweg = PlayAnimationNoWait("","eat_standing")
        MsgSay("","_HPFZ_BETTLER_SPRUCH_+7")
    end	
    Sleep(beweg)	

end

function betriebreaktion()

    local dasHaus = GetData("HausInfo")
	local zFall = Rand(4)
	if zFall == 1 then
	    local beweg = PlayAnimationNoWait("","propel")
		if not BuildingGetOwner(dasHaus,"Besitzer") then
			MsgSay("","_HPFZ_BETTLER_SPRUCH_+8")
		else
			MsgSay("","_HPFZ_BETTLER_SPRUCH_+9",GetID("Besitzer"))
		end
	elseif zFall == 2 then
		local beweg = PlayAnimationNoWait("","talk")
		MsgSay("","_HPFZ_BETTLER_SPRUCH_+10")
	elseif zFall == 3 then
		local beweg = PlayAnimationNoWait("","talk")
		if not BuildingGetOwner(dasHaus,"Besitzer") then
			MsgSay("","_HPFZ_BETTLER_SPRUCH_+11")
		else
			local klasse = SimGetClass("Besitzer")
			local klNam
			if klasse == 1 then
			    klNam = "Patron"
		        MsgSay("","_HPFZ_BETTLER_SPRUCH_+12",klNam)
			elseif klasse == 2 then
			    klNam = "Handwerker"
			    MsgSay("","_HPFZ_BETTLER_SPRUCH_+12",klNam)
			elseif klasse == 3 then
			    klNam = "Gelehrter"
			    MsgSay("","_HPFZ_BETTLER_SPRUCH_+12",klNam)
			elseif klasse == 4 then
			    klNam = "Gauner"
			    MsgSay("","_HPFZ_BETTLER_SPRUCH_+12",klNam)
			end
	    end
	else
		local beweg = PlayAnimationNoWait("","propel")
		if not BuildingGetOwner(dasHaus,"Besitzer") then
			MsgSay("","_HPFZ_BETTLER_SPRUCH_+13")
	    else
			local seinHaus = SimGetLastname("Besitzer")
		    MsgSay("","_HPFZ_BETTLER_SPRUCH_+14",GetID("Besitzer"))
	    end
	end
	Sleep(beweg)

end

function stadtreaktion()

    local dieStadt = GetData("CityInfo")
	local beweg = PlayAnimationNoWait("","propel")
	local zFall = Rand(4)
	if zFall == 1 then
	    MsgSay("","_HPFZ_BETTLER_SPRUCH_+15")
		Sleep(4)
		MsgSay("","_HPFZ_BETTLER_SPRUCH_+16")
		Sleep(4)
		MsgSayNoWait("","_HPFZ_BETTLER_SPRUCH_+17")
	elseif zFall == 2 then
	    MsgSay("","_HPFZ_BETTLER_SPRUCH_+18")
		Sleep(4)
		MsgSay("","_HPFZ_BETTLER_SPRUCH_+19")
		Sleep(4)
		MsgSayNoWait("","_HPFZ_BETTLER_SPRUCH_+20")
	elseif zFall == 3 then
	
		local citylvl = CityGetLevel(dieStadt)
		if citylvl == 2 then
			if GetOfficeTypeHolder(dieStadt,1,"Amtsmann") then
			    local dingens = SimGetGender("Amtsmann")
			    if dingens == 1 then
					MsgSay("","_HPFZ_BETTLER_SPRUCH_+21",GetID("Amtsmann"))
				else
					MsgSay("","_HPFZ_BETTLER_SPRUCH_+22",GetID("Amtsmann"))
				end
			else
	            MsgSay("","_HPFZ_BETTLER_SPRUCH_+23")
			end
		elseif citylvl == 3 then
			if GetOfficeTypeHolder(dieStadt,1,"Amtsmann") then
				local dingens = SimGetGender("Amtsmann")
				if dingens == 1 then
					MsgSay("","_HPFZ_BETTLER_SPRUCH_+24",GetID("Amtsmann"))
				else
					MsgSay("","_HPFZ_BETTLER_SPRUCH_+25",GetID("Amtsmann"))
				end
			else
				MsgSay("","_HPFZ_BETTLER_SPRUCH_+26")
			end
		elseif citylvl == 4 then
			if GetOfficeTypeHolder(dieStadt,1,"Amtsmann") then
				local dingens = SimGetGender("Amtsmann")
				if dingens == 1 then
					MsgSay("","_HPFZ_BETTLER_SPRUCH_+27",GetID("Amtsmann"))
				else
					MsgSay("","_HPFZ_BETTLER_SPRUCH_+28",GetID("Amtsmann"))
				end
			else
				MsgSay("","_HPFZ_BETTLER_SPRUCH_+29")
			end
		elseif citylvl == 5 then
			if GetOfficeTypeHolder(dieStadt,1,"Amtsmann") then
				local dingens = SimGetGender("Amtsmann")
				if dingens == 1 then
					MsgSay("","_HPFZ_BETTLER_SPRUCH_+30",GetID("Amtsmann"))
				else
					MsgSay("","_HPFZ_BETTLER_SPRUCH_+31",GetID("Amtsmann"))
				end
			else
				MsgSay("","_HPFZ_BETTLER_SPRUCH_+32")
			end
		elseif citylvl == 6 then
			if GetOfficeTypeHolder(dieStadt,1,"Amtsmann") then
				local dingens = SimGetGender("Amtsmann")
				if dingens == 1 then
					MsgSay("","D_HPFZ_BETTLER_SPRUCH_+33",GetID("Amtsmann"))
				else
					MsgSay("","_HPFZ_BETTLER_SPRUCH_+34",GetID("Amtsmann"))
				end
			else
				MsgSay("","_HPFZ_BETTLER_SPRUCH_+35")
			end	
        end		    
	else
	    MsgSay("","_HPFZ_BETTLER_SPRUCH_+36")
	end
	Sleep(beweg)

end

function hausreaktion()

    local dasHaus = GetData("HausInfo")
	local zFall = Rand(4)
	if zFall == 0 then
		local beweg = PlayAnimationNoWait("","propel")
        if not BuildingGetOwner(dasHaus,"Besitzer") then
			MsgSay("","_HPFZ_BETTLER_SPRUCH_+37")
		else
			local dingens = SimGetGender("Besitzer")
			if dingens == 1 then
			    MsgSay("","_HPFZ_BETTLER_SPRUCH_+38",GetID("Besitzer"))
			else
			    MsgSay("","_HPFZ_BETTLER_SPRUCH_+39",GetID("Besitzer"))
			end
		end
	elseif zFall == 1 then
	    local hausLvl = BuildingGetLevel(dasHaus)
		if hausLvl == 1 then
		    local beweg = PlayAnimationNoWait("","cheer_01")
		    MsgSay("","_HPFZ_BETTLER_SPRUCH_+40")
		elseif hausLvl == 2 then
			local beweg = PlayAnimationNoWait("","cheer_01")
			MsgSay("","_HPFZ_BETTLER_SPRUCH_+41")
		elseif hausLvl == 3 then
			local beweg = PlayAnimationNoWait("","talk")
			MsgSay("","_HPFZ_BETTLER_SPRUCH_+42")
		elseif hausLvl == 4 then
			local beweg = PlayAnimationNoWait("","talk")
			MsgSay("","_HPFZ_BETTLER_SPRUCH_+43")
		elseif hausLvl == 5 then
			local beweg = PlayAnimationNoWait("","propel")
			MsgSay("","_HPFZ_BETTLER_SPRUCH_+44")
		end
	elseif zFall == 2 then
        local dasHaus = GetData("HausInfo")
		local spende = 0
        if BuildingGetOwner(dasHaus,"Besitzer") then
		    if DynastyIsPlayer("Besitzer") then
			    local geldumgang = GetSkillValue("Besitzer",BARGAINING)
		        local geb = Rand(3)
				if geldumgang < 6 then
					if geb == 0 then
					    spende = 1
					elseif geb == 1 then
					    spende = 0
					elseif geb == 2 then
					    spende = 1
					end
				else
				    if geb == 0 then
					    spende = 0
					elseif geb == 1 then
					    spende = 1
					elseif geb == 2 then
					    spende = 0
					end
				end
			else
				PlayAnimationNoWait("","talk")
				MsgSay("","_HPFZ_BETTLER_BETTELT_+0")	
			        spende = MsgNews("Besitzer","",
			                "@B[1,@L_HPFZ_BETTLER_ANFRAGE_+1]"..
							"@B[2,@L_HPFZ_BETTLER_ANFRAGE_+2]",
							state_bettler_aidecide,
							"default",
							0.25,
							"@L_HPFZ_BETTLER_ANFRAGE_+3",
							"@L_HPFZ_BETTLER_ANFRAGE_+4"..
							"_HPFZ_BETTLER_ANFRAGE_+5")
			end
			if spende == 1 then
			    local guete = Rand(3)
				local betrag = 0
				if guete == 0 then
				    betrag = 5
				elseif guete == 1 then
				    betrag = 20
				elseif guete == 2 then
				    betrag = 50
				end
			    f_SpendMoney("Besitzer", betrag, "CostBribes")
				MsgNewsNoWait("Besitzer","","","default",-1,"@L_HPFZ_BETTLER_ANFRAGE_+3",
				                                            "@L_HPFZ_BETTLER_ANFRAGE_+6",betrag)
				local beweg = PlayAnimationNoWait("","cheer_01")
				MsgSay("","_HPFZ_BETTLER_SPRUCH_+45")											
			else
				local beweg = PlayAnimationNoWait("","propel")
				MsgSay("", "_HPFZ_BETTLER_SPRUCH_+46",GetID("Besitzer"))
			end	
		else		
		    local beweg = PlayAnimationNoWait("","propel")
			MsgSay("","_HPFZ_BETTLER_SPRUCH_+47")
		end
	else
		MsgSayNoWait("","_HPFZ_BETTLER_SPRUCH_+48")
		PlayAnimation("","sit_down_ground")
		MoveSetStance("",GL_STANCE_LAYGROUND)
		local pennen = 1
		while pennen < 15 do
			Sleep(2)
			pennen = pennen + 1
		end
		local beweg = MoveSetStance("",GL_STANCE_STAND)
        MsgSay("","_HPFZ_BETTLER_SPRUCH_+49")
	end
    Sleep(beweg)
	
end

function aidecide()
    local AIzFall = Rand(3)
	if AIzFall == 0 then
	    return 1
	elseif AIzFall == 1 then
	    return 2
	elseif AIzFall == 2 then
	    return 2
	end
end

function CleanUp()
	MoveSetActivity("","")
	FadeOutFE("","sad",1.0,-1)
end
