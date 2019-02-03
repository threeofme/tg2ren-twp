function Run()
	local Target = ""
	if AliasExists("Destination") then
		Target = "Destination"
	end
		
	local result = InitData("@P"..
	"@B[1,@L%1l,@L%1l,Hud/Buttons/btn_playtarot.tga]"..
	"@B[2,@L%2l,@L%2l,Hud/Items/Item_AldermanChain.tga]"..
	"@B[3,@L%3l,@L%3l,Hud/Items/item_diamanten.tga]"..
	"@B[4,@L%4l,@L%4l,Hud/Items/Item_Stonerotary.tga]"..
	"@B[5,@L%5l,@L%5l,Hud/Items/Item_goldhigh.tga]"..
	"@B[6,@L%6l,@L%6l,Hud/Items/Item_Empfehlung.tga]"..
	"@B[7,@L%7l,@L%7l,Hud/Items/Item_MiracleCure.tga]"..
	"@B[8,@L%8l,@L%8l,Hud/Items/Item_HexerdokumentII.tga]",
	-1,
	"@L_MEASURE_HotTea_TITLE_+0","",
	"Unsterblichkeit","Titel","Politik","Erfahrung","Geld","Ruhm","Economy","AIs-Zeit")

	if result==1 then
		if SimIsMortal(Target) then
			SimSetMortal(Target, false)
			MsgQuick("", "Ahh, diese Kraft! Ich fühle mich unsterblich!",GetID(Target))
		else
			SimSetMortal(Target, true)
			MsgQuick("", "Lieber ein sterbliches Leben mit dir, als die Ewigkeit ohne dich!",GetID(Target))
		end

	elseif result==2 then
		if GetNobilityTitle(Target)<7 then
			SetNobilityTitle(Target, 7, true)
		end
	
	elseif result==3 then
		GetHomeBuilding(Target,"myhome")
		BuildingGetCity("myhome","city")
		local citylvl = CityGetLevel("city")
		local highestlvl = CityGetHighestOfficeLevel("city")
		CityGetOffice("city", highestlvl, 0, "office")
		SimSetOffice(Target, "office")
	elseif result==4 then
		chr_GainXP(Target,4000)
		MsgQuick("", "Ach, sag das doch gleich!",GetID(Target))
		LogMessage("1 < 2 but "..result.."2 > 1")
		LogMessage("3 %< 4 but "..result.."5 %> 3")
		LogMessage("1 < 2 but ".."2 > 1")
		LogMessage("3 %< 4 but ".."5 %> 3")
	elseif result==5 then
		f_CreditMoney(Target, 120000, "HotTea")
		MsgQuick("", "Geld, Geld, Geld!",GetID(Target))
	elseif result==6 then
		chr_SimAddFame(Target,25)
		chr_SimAddImperialFame(Target,25)
	elseif result==7 then
		f_SpendMoney(Target, 50000, "HotTea")
		MsgQuick("", "Thieves!", GetID(Target))
	  	-- TheBlackDeath
	    --CreateScriptcall("StartDisease",1,"Measures/Artefacts/as_222_UseMixture.lua","StartDisease","","")
	    --idlelib_GoToTavern(1)
	elseif result == 8 then
		local freeze = MsgBox("","Owner",
				"@P@B[1,@L%1l,]@B[0,@L%2l,]",
				"AIs-Zeit","AI einfrieren?", "Ja", "Nein")
		if freeze == 1 then
			ScenarioPauseAI(true)
		elseif freeze == 0 then
			ScenarioPauseAI(false)
		end
	end
end

function CleanUp()
	SetState("", STATE_LOCKED, false)
end