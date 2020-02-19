function Run()

	if GetItemCount("","Schadelkerze")<6 then
		MsgQuick("","_HPFZ_VERFLUCHEN_FEHLER_+1")
		StopMeasure()
	end 
 
	local talent = GetSkillValue("",10) -- secret knowledge
	local MaxDistance = 1500
	local ActionDistance = 500
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
 
	-- visual stuff
	CarryObject("","Handheld_Device/ANIM_torchparticles.nif", false)
	
	if not ai_StartInteraction("", "Destination", MaxDistance, ActionDistance, nil) then
		StopMeasure()
	end
	
	PlayAnimation("","watch_for_guard")
	Sleep(1)
	RemoveItems("","Schadelkerze",6)
	SetMeasureRepeat(TimeOut)
	MeasureSetNotRestartable()
	CommitAction("poison","", "Destination", "Destination")

	GetPosition("","FluchPos")
	GfxAttachObject("skull1", "Locations/Alchimist/Skull.nif")
	GfxSetPosition("skull1", -140, 10, 0, false)
	GfxSetRotation("skull1",0,-90,0,true)
	GfxAttachObject("pentg", "particles/Campfire.nif")
	GfxSetPosition("pentg", -140, 50, 0, false)

	GfxAttachObject("skull2", "Locations/Alchimist/Skull.nif")
	GfxSetPosition("skull2", 140, 10, 0, false)
	GfxSetRotation("skull2",0,90,0,true)
	GfxAttachObject("feuer1", "particles/Campfire.nif")
	GfxSetPosition("feuer1", 140, 50, 0, false)

	GfxAttachObject("skull3", "Locations/Alchimist/Skull.nif")
	GfxSetPosition("skull3", 100, 10, 150, false)
	GfxSetRotation("skull3",0,30,0,true)
	GfxAttachObject("feuer2", "particles/Campfire.nif")
	GfxSetPosition("feuer2", 100, 50, 150, false)

	GfxAttachObject("skull4", "Locations/Alchimist/Skull.nif")
	GfxSetPosition("skull4", 100, 10, -150, false)
	GfxSetRotation("skull4",0,150,0,true)
	GfxAttachObject("feuer3", "particles/Campfire.nif")
	GfxSetPosition("feuer3", 100, 50, -150, false)

	GfxAttachObject("skull5", "Locations/Alchimist/Skull.nif")
	GfxSetPosition("skull5", -100, 10, -150, false)
	GfxSetRotation("skull5",0,220,0,true)
	GfxAttachObject("feuer4", "particles/Campfire.nif")
	GfxSetPosition("feuer4", -100, 50, -150, false)

	GfxAttachObject("skull6", "Locations/Alchimist/Skull.nif")
	GfxSetPosition("skull6", -100, 10, 150, false)
	GfxSetRotation("skull6",0,-30,0,true)
	GfxAttachObject("feuer5", "particles/Campfire.nif")
	GfxSetPosition("feuer5", -100, 50, 150, false)

	CarryObject("","",false)
	PlayAnimationNoWait("","preach")
	Sleep(2)
	GfxAttachObject("hex", "particles/summon2.nif")
	GfxScale("hex", 1)
	Sleep(14)
	GfxDetachAllObjects()

	-- effect
	local ansprach = ""
	
	if talent > Rand(10) then
		AddImpact("Destination",388,1,talent)
		SetState("Destination",STATE_HPFZ_VERFLUCHT,true)
		chr_GainXP("",GetData("BaseXP"))
		BuildingGetOwner("Destination","Besitzer")
		if SimGetGender("Besitzer")==GL_GENDER_MALE then
			ansprach = "_HPFZ_VERFLUCHEN_ANFRAGE_+0"
		else
			ansprach = "_HPFZ_VERFLUCHEN_ANFRAGE_+2"
		end
		MsgNewsNoWait("Owner","Destination","","intrigue",-1,"@L"..ansprach.."",
					"@L_HPFZ_VERFLUCHEN_ANFRAGE_+1",GetID("Besitzer"))
	else
		MsgSay("","_HPFZ_VERFLUCHEN_SPRUCH_+0")
	end
    
	StopAction("poison","")
	Sleep(1)
	StopMeasure()
end

function CleanUp()
    GfxDetachAllObjects()
    CarryObject("","",false)
    StopAction("poison","")
end

function GetOSHData(MeasureID)
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end
