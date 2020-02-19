function Init()
  SimSetMortal("", false)
	SetStateImpact("no_idle")
	SetStateImpact("no_hire")
	SetStateImpact("no_control")
	SetStateImpact("no_attackable")
	SetStateImpact("no_measure_start")
	SetStateImpact("no_measure_attach")
	SetStateImpact("no_action")
	SetStateImpact("no_cancel_button")
end

function Run()

  SetState("", STATE_TOWNNPC, true)
	CarryObject("","Handheld_Device/Anim_scroll.nif",false)
  local i = ScenarioGetObjects("Settlement",10,"Stadt")
	local reiseZiel = {}
	local u = 0
  for k=0,i-1 do
		if AliasExists("Stadt"..k) == true and CityIsKontor("Stadt"..k) == false then
			u = u + 1
		  reiseZiel[u] = "Stadt"..k
		end
	end
		
	local wahl = (Rand(u)+1)
  local reise = reiseZiel[wahl]
	CityGetRandomBuilding(reise, -1, GL_BUILDING_TYPE_SCHOOL, -1, -1, FILTER_IGNORE, "VerkundPlatz")
	GetOutdoorMovePosition("", "VerkundPlatz", "KundPos")
  f_MoveTo("","KundPos",GL_MOVESPEED_WALK,300)

  GetLocalPlayerDynasty("Player")

	MsgNewsNoWait("Player",GetID(reise),"","intrigue",-1,"@L_HPFZ_BARDE_KOPF_+0",
	    "@L_HPFZ_BARDE_RUMPF_+0",GetID(reise))

  GetPosition("","standPos")
	CityGetRandomBuilding(reise, 5, -1, -1, -1, FILTER_IGNORE, "Markt")
	AlignTo("Owner","Markt")
	GfxAttachObject("podest","buildings/barrel.nif")
	GfxSetPositionTo("podest","standPos")
	GfxMoveToPosition("podest", 0, 25, 0, 1, false)
	GfxMoveToPosition("Owner", 0, 500, 0, 1, false)
	local rastet = 0

	while rastet < 2 do
	    MsgSayNoWait("Owner","_HPFZ_BARDE_SPRUCH_+0")
	    Sleep(10)
	    rastet = rastet + 1
	end

	GfxDetachObject("podest")
  GfxMoveToPosition("Owner", 0, 0, 0, 1, false)
	
	GetOutdoorLocator("MapExit1",1,"RastPlatz")
	if not f_MoveTo("","RastPlatz") then
		GetOutdoorLocator("MapExit2",1,"RastPlatz")
		if not f_MoveTo("","RastPlatz") then
			GetOutdoorLocator("MapExit3",1,"RastPlatz")
			f_MoveTo("","RastPlatz")
		end
	end

  hpfzBardeUnterwegs = 0
	StopMeasure()
	
end

function CleanUp()
  CarryObject("","",false)
	InternalDie("Owner")
	InternalRemove("Owner")
end
