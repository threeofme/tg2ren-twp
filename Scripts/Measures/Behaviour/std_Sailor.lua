function Init()
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
  local markt = Rand(5)
	GetPosition("","HomeHafen")
	GetNearestSettlement("","HafenStadt")
	CityGetRandomBuilding("HafenStadt", 5, 14, -1, -1, FILTER_IGNORE, "ZielMarkt")
	MoveSetActivity("","carry")
  Sleep(2)
	if markt == 0 then
  	CarryObject("","Handheld_Device/ANIM_Bag.nif",false)
	elseif markt == 1 then
	  CarryObject("","Handheld_Device/ANIM_Barrel.nif",false)
	elseif markt == 2 then
	  CarryObject("","Handheld_Device/ANIM_Metalbar.nif",false)
	elseif markt == 3 then
	  CarryObject("","Handheld_Device/ANIM_Tailorbasket.nif",false)
	elseif markt == 4 then
	  CarryObject("","Handheld_Device/ANIM_Cloth.nif",false)
	end
	f_MoveTo("","ZielMarkt")
	MoveSetActivity("","")
	Sleep(2)
  CarryObject("","",false)
	f_MoveTo("","HomeHafen",GL_MOVESPEED_WALK)
	SetState("", STATE_INVISIBLE, true)
end

function CleanUp()
	InternalDie("")
	InternalRemove("")
end
