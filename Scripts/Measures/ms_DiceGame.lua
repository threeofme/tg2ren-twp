function Init()

	local cash = GetMoney("") 	
	
	if cash < 100 then
		MsgQuick("","@L_MEASURE_DICEGAME_NOMONEY_+0")
		StopMeasure()
	end
	
	if cash > 10000 then
		cash = 10000
	end
	
	local vorab, regeln
	repeat
		vorab = MsgBox("",false,"@P"..
			"@B[A,@L_HPFZ_WS_STUFF_+8]"..
			"@B[B,@L_HPFZ_WS_STUFF_+9]"..
			"@B[C,@L_HPFZ_WS_STUFF_+10]",
			"@L_HPFZ_WS_KOPF_+0",
			"@L_HPFZ_WS_RUMPF_+0")

		if vorab == "A" then
			regeln = MsgBox("",false,"@P"..
				"@B[B,@L_HPFZ_WS_STUFF_+9]"..
				"@B[C,@L_HPFZ_WS_STUFF_+10]",
				"@L_HPFZ_WS_KOPF_+6",
				"@L_HPFZ_WS_RUMPF_+6")
		end
			
		if vorab == "C" or regeln == "C" then
			StopMeasure()
		end
	until vorab == "B" or regeln == "B"
	
	local prSatz = MsgBox("",false,"@P"..
		"@B[10,@L_HPFZ_WS_EINSATZ_+4]"..
		"@B[25,@L_HPFZ_WS_EINSATZ_+1]"..
		"@B[50,@L_HPFZ_WS_EINSATZ_+2]",
		"@L_HPFZ_WS_KOPF_+0",
		"@L_HPFZ_WS_RUMPF_+8")
	
	local setzen = ((cash / 100) * prSatz)
	
	if setzen > 0 then
		if not f_SpendMoney("", setzen, "") then
			MsgQuick("","@L_MEASURE_DICEGAME_NOMONEY_+0")
			StopMeasure()
		end
		
		ShowOverheadSymbol("",false,true,0,"-%1t",setzen)
		SetData("Pott", setzen)
		SetData("Prozent", prSatz)
	else
		MsgQuick("","@L_dicegame_FEHLER_+0")
		StopMeasure()
	end

	MsgBox("",false,"@P"..
		"@B[Start,@L_HPFZ_WS_STUFF_+11]",
		"@L_HPFZ_WS_KOPF_+0",
		"@L_HPFZ_WS_RUMPF_+7",setzen)
	
end

function Run()
	
	GetInsideBuilding("Owner","Tave")
	GetFreeLocatorByName("Tave","DicePlayer",-1,-1,"SitPos")
	f_BeginUseLocator("Owner","SitPos",GL_STANCE_STAND,true)	

    local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	SetMeasureRepeat(TimeOut)
	
	local grEinsatz
	local werte, cash
	local StartSpiel = InitData("@P"..
		"@B[START,,,hpfzextra/dices/dice_highlighted_ques.tga]",-1,
		"@L_HPFZ_WS_STUFF_+0",
		"")
	local wurf1 = ms_dicegame_wuerfel()
    ms_dicegame_wuerfelVerlauf(1,wurf1)

	local wurf2 = ms_dicegame_wuerfel()
    ms_dicegame_wuerfelVerlauf(1,wurf2)
	
	local wurf3 = ms_dicegame_wuerfel()
    ms_dicegame_wuerfelVerlauf(1,wurf3)
	
	PlaySound3D("","measures/shake_dices/shake_dices+0.wav", 1.0)
	local wfallen = PlayAnimationNoWait("","manipulate_middle_low_r")
	Sleep(wfallen-1)
	PlaySound3D("","measures/throw_dices/throw_dices+0.wav", 1.0)
	
	local SpielStand1 = InitData("@P"..
		"@B[A,,@L_HPFZ_WS_STUFF_+2,hpfzextra/dices/dice_highlighted_"..wurf1..".tga]"..
		"@B[A,,@L_HPFZ_WS_STUFF_+2,hpfzextra/dices/dice_highlighted_"..wurf2..".tga]"..
		"@B[A,,@L_HPFZ_WS_STUFF_+2,hpfzextra/dices/dice_highlighted_"..wurf3..".tga]",-1,
		"@L_HPFZ_WS_STUFF_+1",
		"")	

	if GetData("Summe") == 17 then
	    ms_dicegame_siebz(3)
	elseif GetData("Summe") > 17 then
	    ms_dicegame_Auszahlung(4)
	end	
	
	cash = GetMoney("")
	
	if cash > 10000 then
		cash = 10000
	end
	
	grEinsatz = ms_dicegame_AllEinsatz(1,cash)
	
	local SpielAnalyse = MsgBox("",false,"@P"..
		"@B["..grEinsatz..",@L_HPFZ_WS_EINSATZ_+0,]"..
		"@B[Exit,@L_HPFZ_WS_EINSATZ_+3,]",
		"@L_HPFZ_WS_KOPF_+1",
		"@L_HPFZ_WS_RUMPF_+1",grEinsatz,GetData("Summe"))
	
	if SpielAnalyse == "Exit" then
	   	werte = ms_dicegame_Xwurf(3)
		if werte ~= 3 then
		   werte = ms_dicegame_Auswertung()
		end
		ms_dicegame_Auszahlung(werte)
	else
		ms_dicegame_AllEinsatz(2,cash)
	end

	local wurf4 = ms_dicegame_wuerfel()
    ms_dicegame_wuerfelVerlauf(1,wurf4)
	
	PlaySound3D("","measures/shake_dices/shake_dices+0.wav", 1.0)
	local wfallen = PlayAnimationNoWait("","manipulate_middle_low_r")
	Sleep(wfallen-1)
	PlaySound3D("","measures/throw_dices/throw_dices+0.wav", 1.0)
	
	local SpielStand2 = InitData("@P"..
		"@B[C,,@L_HPFZ_WS_STUFF_+2,hpfzextra/dices/dice_highlighted_"..wurf1..".tga]"..
		"@B[C,,@L_HPFZ_WS_STUFF_+2,hpfzextra/dices/dice_highlighted_"..wurf2..".tga]"..
		"@B[C,,@L_HPFZ_WS_STUFF_+2,hpfzextra/dices/dice_highlighted_"..wurf3..".tga]"..
		"@B[C,,@L_HPFZ_WS_STUFF_+2,hpfzextra/dices/dice_highlighted_"..wurf4..".tga]",-1,
		"@L_HPFZ_WS_STUFF_+3",
		"")
	
	if GetData("Summe") == 17 then
	    ms_dicegame_siebz(4)
	elseif GetData("Summe") > 17 then
	    ms_dicegame_Auszahlung(4)
	end	

	cash = GetMoney("")
	
	if cash > 10000 then
		cash = 10000
	end
	
	grEinsatz = ms_dicegame_AllEinsatz(1,cash)	
	
	local SpielAnalyse2 = MsgBox("",false,"@P"..
		"@B["..grEinsatz..",@L_HPFZ_WS_EINSATZ_+0,]"..
		"@B[Exit,@L_HPFZ_WS_EINSATZ_+3,]",
		"@L_HPFZ_WS_KOPF_+1",
		"@L_HPFZ_WS_RUMPF_+1",grEinsatz,GetData("Summe"))
	
	if SpielAnalyse2 == "Exit" then
	    werte = ms_dicegame_Xwurf(4)
		if werte ~= 3 then
		    werte = ms_dicegame_Auswertung()
        end
		    ms_dicegame_Auszahlung(werte)
	else
	    ms_dicegame_AllEinsatz(2,cash)
	end

	local wurf5 = ms_dicegame_wuerfel()
    ms_dicegame_wuerfelVerlauf(1,wurf5)
	
	PlaySound3D("","measures/shake_dices/shake_dices+0.wav", 1.0)
	local wfallen = PlayAnimationNoWait("","manipulate_middle_low_r")
	Sleep(wfallen-1)
	PlaySound3D("","measures/throw_dices/throw_dices+0.wav", 1.0)
	
	local SpielStand3 = InitData("@P"..
		"@B[E,,@L_HPFZ_WS_STUFF_+2,hpfzextra/dices/dice_highlighted_"..wurf1..".tga]"..
		"@B[E,,@L_HPFZ_WS_STUFF_+2,hpfzextra/dices/dice_highlighted_"..wurf2..".tga]"..
		"@B[E,,@L_HPFZ_WS_STUFF_+2,hpfzextra/dices/dice_highlighted_"..wurf3..".tga]"..
		"@B[E,,@L_HPFZ_WS_STUFF_+2,hpfzextra/dices/dice_highlighted_"..wurf4..".tga]"..
		"@B[E,,@L_HPFZ_WS_STUFF_+2,hpfzextra/dices/dice_highlighted_"..wurf5..".tga]",-1,
		"@L_HPFZ_WS_STUFF_+4",
		"")	

	if GetData("Summe") == 17 then
	    ms_dicegame_siebz(5)
	elseif GetData("Summe") > 17 then
	    ms_dicegame_Auszahlung(4)
	end	

	cash = GetMoney("")
	
	if cash > 10000 then
		cash = 10000
	end
	
	grEinsatz = ms_dicegame_AllEinsatz(1,cash)
	
	local SpielAnalyse3 = MsgBox("",false,"@P"..
		"@B["..grEinsatz..",@L_HPFZ_WS_EINSATZ_+0,]"..
		"@B[Exit,@L_HPFZ_WS_EINSATZ_+3,]",
		"@L_HPFZ_WS_KOPF_+1",
		"@L_HPFZ_WS_RUMPF_+1",grEinsatz,GetData("Summe"))
	
	if SpielAnalyse3 == "Exit" then
	    werte = ms_dicegame_Xwurf(5)
		if werte ~= 3 then
		    werte = ms_dicegame_Auswertung()
		end
		ms_dicegame_Auszahlung(werte)
	else
	    ms_dicegame_AllEinsatz(2,cash)
	end

	local wurf6 = ms_dicegame_wuerfel()
    ms_dicegame_wuerfelVerlauf(1,wurf6)
	
	PlaySound3D("","measures/shake_dices/shake_dices+0.wav", 1.0)
	local wfallen = PlayAnimationNoWait("","manipulate_middle_low_r")
	Sleep(wfallen-1)
	PlaySound3D("","measures/throw_dices/throw_dices+0.wav", 1.0)
	
	local SpielStand4 = InitData("@P"..
		"@B[G,,@L_HPFZ_WS_STUFF_+2,hpfzextra/dices/dice_highlighted_"..wurf1..".tga]"..
		"@B[G,,@L_HPFZ_WS_STUFF_+2,hpfzextra/dices/dice_highlighted_"..wurf2..".tga]"..
		"@B[G,,@L_HPFZ_WS_STUFF_+2,hpfzextra/dices/dice_highlighted_"..wurf3..".tga]"..
		"@B[G,,@L_HPFZ_WS_STUFF_+2,hpfzextra/dices/dice_highlighted_"..wurf4..".tga]"..
		"@B[G,,@L_HPFZ_WS_STUFF_+2,hpfzextra/dices/dice_highlighted_"..wurf5..".tga]"..
		"@B[G,,@L_HPFZ_WS_STUFF_+2,hpfzextra/dices/dice_highlighted_"..wurf6..".tga]",-1,
		"@L_HPFZ_WS_STUFF_+5",
		"")

	if GetData("Summe") > 17 then
	    ms_dicegame_Auszahlung(4)
	end
	
	werte = ms_dicegame_Xwurf(6)
	if werte ~= 3 then
	    werte = ms_dicegame_Auswertung()
	end
	ms_dicegame_Auszahlung(werte)
	
end

function siebz(d)

	local SpielAnalyseX = MsgBox("",false,"@P"..
	"@B[Exit,@L_HPFZ_WS_EINSATZ_+3,]",
	"@L_HPFZ_WS_KOPF_+1",
	"@L_HPFZ_WS_RUMPF_+9",GetData("Summe"))
	
	if SpielAnalyse == "Exit" then
	    werte = ms_dicegame_Xwurf(d)
		if werte ~= 3 then
		    werte = ms_dicegame_Auswertung()
		end
		ms_dicegame_Auszahlung(werte)
	end

end

function Xwurf(wuerfel)

    local Xwuerfel = ""
	local SPwurf, XPwurf

	PlaySound3D("","measures/shake_dices/shake_dices+0.wav", 1.0)
	Sleep(1)
	PlaySound3D("","measures/throw_dices/throw_dices+0.wav", 1.0)
	
	local Xwurf1 = ms_dicegame_wuerfel()
	ms_dicegame_wuerfelVerlauf(2,Xwurf1)
	Xwuerfel = Xwuerfel.."@B[X,,@L_HPFZ_WS_STUFF_+6,hpfzextra/dices/dice_"..Xwurf1..".tga]"
	
	local Xwurf2 = ms_dicegame_wuerfel()
	ms_dicegame_wuerfelVerlauf(2,Xwurf2)
	Xwuerfel = Xwuerfel.."@B[X,,@L_HPFZ_WS_STUFF_+6,hpfzextra/dices/dice_"..Xwurf2..".tga]"
	
	local Xwurf3 = ms_dicegame_wuerfel()
	ms_dicegame_wuerfelVerlauf(2,Xwurf3)
	Xwuerfel = Xwuerfel.."@B[X,,@L_HPFZ_WS_STUFF_+6,hpfzextra/dices/dice_"..Xwurf3..".tga]"

    SPwurf = GetData("Summe")
	XPwurf = GetData("XSumme")
	if XPwurf > SPwurf and XPwurf <= 17 then
	    local Gegnerwurf = InitData("@P"..Xwuerfel,-1,"@L_HPFZ_WS_STUFF_+7","")
	    return 3
	end
	
	if wuerfel >= 4 then
		local Xwurf4 = ms_dicegame_wuerfel()
		ms_dicegame_wuerfelVerlauf(2,Xwurf4)
	    Xwuerfel = Xwuerfel.."@B[X,,@L_HPFZ_WS_STUFF_+6,hpfzextra/dices/dice_"..Xwurf4..".tga]"
	end

    SPwurf = GetData("Summe")
	XPwurf = GetData("XSumme")
	if XPwurf > SPwurf and XPwurf <= 17 then
	    local Gegnerwurf = InitData("@P"..Xwuerfel,-1,"@L_HPFZ_WS_STUFF_+7","")
	    return 3
	end
	
	if wuerfel >= 5 then
	    local Xwurf5 = ms_dicegame_wuerfel()
		ms_dicegame_wuerfelVerlauf(2,Xwurf5)
	    Xwuerfel = Xwuerfel.."@B[X,,@L_HPFZ_WS_STUFF_+6,hpfzextra/dices/dice_"..Xwurf5..".tga]"	
	end

    SPwurf = GetData("Summe")
	XPwurf = GetData("XSumme")
	if XPwurf > SPwurf and XPwurf <= 17 then
	    local Gegnerwurf = InitData("@P"..Xwuerfel,-1,"@L_HPFZ_WS_STUFF_+7","")
	    return 3
	end
	
	if wuerfel == 6 then
	    local Xwurf6 = ms_dicegame_wuerfel()
		ms_dicegame_wuerfelVerlauf(2,Xwurf6)
	    Xwuerfel = Xwuerfel.."@B[X,,@L_HPFZ_WS_STUFF_+6,hpfzextra/dices/dice_"..Xwurf6..".tga]"	
	end

    SPwurf = GetData("Summe")
	XPwurf = GetData("XSumme")
	if XPwurf > SPwurf and XPwurf <= 17 then
	    local Gegnerwurf = InitData("@P"..Xwuerfel,-1,"@L_HPFZ_WS_STUFF_+7","")
	    return 3
	end
	
	local Gegnerwurf = InitData("@P"..Xwuerfel,-1,"@L_HPFZ_WS_STUFF_+7","")
	return
	
end

function AllEinsatz(pre,zusatz)

  local pott = GetData("Pott")
	local altSatz = GetData("Prozent")
	local neuSatz = ((zusatz / 100) * altSatz)
	if pre == 2 then
	  if not f_SpendMoney("", neuSatz, "") then
			MsgQuick("","@L_MEASURE_DICEGAME_NOMONEY_+0")
			StopMeasure()
		end
	  ShowOverheadSymbol("",false,true,0,"-%1t",neuSatz)
    SetData("Pott", neuSatz+pott)	
		return
	else	
	  return neuSatz
	end

end

function Auswertung()

  local SPsumm = GetData("Summe")
	local Xsumm = GetData("XSumme")

	if SPsumm == Xsumm then
		return 1
	end

	if (17 - SPsumm) < (17 - Xsumm) or (17 - Xsumm) < 0 then
	  return 2
	end

	if (17 - SPsumm) > (17 - Xsumm) or (17 - SPsumm) < 0 then
	  return 3
	end

end

function Auszahlung(code)

  local gewinn

  if code == 1 then
	  gewinn = GetData("Pott")
    MsgBox("",false,"","@L_HPFZ_WS_KOPF_+2",
	  	"@L_HPFZ_WS_RUMPF_+2",GetData("Summe"))
    f_CreditMoney("",gewinn,"Offering")
	  ShowOverheadSymbol("",false,true,0,"%1t",gewinn)
	elseif code == 2 then
	  gewinn = GetData("Pott")*2
    MsgBox("",false,"","@L_HPFZ_WS_KOPF_+3",
	  	"@L_HPFZ_WS_RUMPF_+3",GetData("Summe"),GetData("XSumme"),gewinn)
		f_CreditMoney("",gewinn,"Offering")
	  ShowOverheadSymbol("",false,true,0,"%1t",gewinn)
	  if not HasProperty("Tave","BestDicePlayer") then
	  	local winnername = GetName("")
	    SetProperty("Tave","BestDicePlayer",winnername)
		  SetProperty("Tave","BestDicePott",gewinn)
	  else
	    local altwinner = GetProperty("Tave","BestDicePott")
		  if gewinn > altwinner then
	  	  local winnername = GetName("")
	      SetProperty("Tave","BestDicePlayer",winnername)
		    SetProperty("Tave","BestDicePott",gewinn)
		  end
	  end
		IncrementXPQuiet("",25)
	elseif code == 4 then
	  gewinn = GetData("Pott")
    MsgBox("",false,"","@L_HPFZ_WS_KOPF_+5",
	  	"@L_HPFZ_WS_RUMPF_+5",gewinn)
	else
		gewinn = GetData("Pott")
    MsgBox("",false,"","@L_HPFZ_WS_KOPF_+4",
	  	"@L_HPFZ_WS_RUMPF_+4",GetData("XSumme"),GetData("Summe"),gewinn)
	  if not HasProperty("Tave","WorstDicePlayer") then
	  	local winnername = GetName("")
	    SetProperty("Tave","WorstDicePlayer",winnername)
		  SetProperty("Tave","WorstDicePott",gewinn)
	  else
	    local altwinner = GetProperty("Tave","WorstDicePott")
		  if gewinn > altwinner then
	  	  local winnername = GetName("")
	      SetProperty("Tave","WorstDicePlayer",winnername)
		    SetProperty("Tave","WorstDicePott",gewinn)
		  end
	  end
	end
  StopMeasure()

end

function wuerfelVerlauf(key,wurf)

	if key == 1 then
		if GetData("Summe") then
		  local altSumme = GetData("Summe")
			local neuSumme = altSumme + wurf
			SetData("Summe",neuSumme)
		else
		  SetData("Summe",wurf)
		end
	end
		
	if key == 2 then
		if GetData("XSumme") then
		  local XaltSumme = GetData("XSumme")
			local XneuSumme = XaltSumme + wurf
		  SetData("XSumme",XneuSumme)
		else
		  SetData("XSumme",wurf)
		end
	end
end

function wuerfel()
	return Rand(6)+1
end

function CleanUp()
	f_EndUseLocator("Owner","DicePlayer",GL_STANCE_STAND)
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end