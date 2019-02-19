function Init()

    local auswahlID = { 1, 2, 3, 6, 8, 10, 11, 40, 201, 202, 241, 242, 243, 244 }
	local was, wieviel, wahlNam, kosten, runit, whereto
	local wahlButt = ""
	local hafenzoll = 100 -- noch festzulegen
	local handlerteil = 100 -- noch festzulegen
	local kontorteil = 100 -- noch festzulegen
	GetLocalPlayerDynasty("Chef")

	for i=1,14 do
		wahlNam = ItemGetLabel(auswahlID[i],true)
	    wahlButt = wahlButt.."@B["..auswahlID[i]..",@L"..wahlNam..",]"
	end
    was = MsgBox("Chef","Owner","@P"..wahlButt.."@B[C,@L_REN_FASTMERCHANTSHIP_CANCEL_+0]","@L_REN_FASTMERCHANTSHIP_TITLE_+0","@L_REN_FASTMERCHANTSHIP_KOPF_+0")
	
	if was == "C" then
		StopMeasure()
	end
	
	wieviel = MsgBox("Chef","Owner","@P@B[20,@L_REN_FASTMERCHANTSHIP_AMOUNT_+0]"..
	                              "@B[40,@L_REN_FASTMERCHANTSHIP_AMOUNT_+1]"..
								  "@B[60,@L_REN_FASTMERCHANTSHIP_AMOUNT_+2]"..
								  "@B[C,@L_REN_FASTMERCHANTSHIP_CANCEL_+0]", 
								  "@L_REN_FASTMERCHANTSHIP_TITLE_+0","@L_REN_FASTMERCHANTSHIP_KOPF_+1")
								  
	if wieviel == "C" then
		StopMeasure()
	end								  
	
	whereto = MsgBox("Chef","Owner","@P@B[X,@L_REN_FASTMERCHANTSHIP_CHOOSEBUTTON_+0]"..
						"@B[C,@L_REN_FASTMERCHANTSHIP_CANCEL_+0]","@L_REN_FASTMERCHANTSHIP_TITLE_+0","@L_REN_FASTMERCHANTSHIP_KOPF_+2")
	
	if whereto == "C" then
		StopMeasure()
	end
	
	InitAlias("Ablade",MEASUREINIT_SELECTION, "__F((Object.CanBeControlled()) AND (Object.IsClass(2)))",
			"",0)

    if GetRemainingInventorySpace("Ablade",was,INVENTORY_STD) < wieviel then
	    MsgNewsNoWait("Chef","Owner","","economy",-1,"@L_REN_FASTMERCHANTSHIP_FEHLER_+0",
	                    "@L_REN_FASTMERCHANTSHIP_FEHLER_+1")
		StopMeasure()
	end			
	kosten = (ItemGetBasePrice(was)*wieviel) + hafenzoll + handlerteil + kontorteil
	if kosten > GetMoney("Chef") then
	    MsgNewsNoWait("Chef","Owner","","economy",-1,"@L_REN_FASTMERCHANTSHIP_FEHLER_+0",
	                    "@L_REN_FASTMERCHANTSHIP_FEHLER_+2")
		StopMeasure()
	end
	
	local itName = ItemGetLabel(was, true)
	runit = MsgBox("Chef","Owner","@P@B[A,@L_REN_FASTMERCHANTSHIP_WAHL_+0,]@B[B,@L_REN_FASTMERCHANTSHIP_WAHL_+1,]","","@L_REN_FASTMERCHANTSHIP_RUMPF_+0",wieviel,itName,kosten,GetID("Ablade"),handlerteil,hafenzoll,kontorteil)
	if runit == "B" then
	    StopMeasure()
	end
	
	if kosten > GetMoney("Chef") then -- Paranoia-Fix, evt. wartet Chef zu lange bei Bestellung
	    MsgNewsNoWait("Chef","Owner","","economy",-1,"@L_REN_FASTMERCHANTSHIP_FEHLER_+0",
	                    "@L_REN_FASTMERCHANTSHIP_FEHLER_+2")
		StopMeasure()
	end	
	
	f_SpendMoney("Chef", kosten, "")
	SetData("BestellWare",was)
	SetData("BestellMenge",wieviel)
	SetData("BestellOrt","Ablade")

end

function Run()

    local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
    SetMeasureRepeat(TimeOut,"")

    local Bware = GetData("BestellWare")
	local Bmenge = GetData("BestellMenge")
	local Bort = GetData("BestellOrt")

	GetPosition("Owner","SetzPos")
    ScenarioCreateCart(6, nil, "SetzPos", "SHandler")

	GetNearestSettlement("SHandler","StartOrt")
	CityGetRandomBuilding("ZielOrt", -1, 13, nil, nil, nil, "Versetz")
	f_MoveTo("SHandler","Versetz")

	repeat
	    ScenarioGetRandomObject("Settlement","ReiseOrt")
	until CityIsKontor("ReiseOrt")==true
	CityGetRandomBuilding("ReiseOrt", -1, 34, nil, nil, nil, "ReiseZiel")

	f_MoveTo("SHandler","ReiseZiel")
	Sleep(20)
	AddItems("SHandler",Bware,Bmenge,INVENTORY_STD)
	f_MoveTo("SHandler","Owner")
	Sleep(6)
	GetLocatorByName("Owner", "Entry1", "KarPos")
	ScenarioCreateCart(2, nil, "KarPos", "SHandlerKar")
	TransferItems("SHandler","SHandlerKar")
	f_MoveTo("SHandlerKar",Bort)
	TransferItems("SHandlerKar",Bort)
	InternalDie("SHandler")
	InternalRemove("SHandler")
	f_MoveTo("SHandlerKar","Owner")
	InternalDie("SHandlerKar")
	InternalRemove("SHandlerKar")

end

function CleanUp()
	if AliasExists("SHandlerKar") then
		InternalDie("SHandlerKar")
		InternalRemove("SHandlerKar")
	end
	if AliasExists("SHandler") then
		InternalDie("SHandler")
		InternalRemove("SHandler")
	end
end
