function Init()
end

function Run()

-- error

	if GetItemCount("","Tool")==0 or GetItemCount("","BuildMaterial")==0 then 	
		MsgQuick("","_HPFZ_REPARIER_FEHLER_+0")
		StopMeasure()
	end

	if GetHP("Destination")==GetMaxHP("Destination") then
		MsgQuick("","_HPFZ_REPARIER_FEHLER_+1")
		StopMeasure()
	end

	if not f_MoveTo("","Destination",GL_WALKSPEED_RUN, 300) then
		StopMeasure()
	end

	GetOutdoorMovePosition("","Destination","WorkPos2")
	GetFreeLocatorByName("Destination","bomb",1,3,"WorkPos",true)
	
	if not f_BeginUseLocator("","WorkPos",GL_STANCE_STAND,true) then
		if not f_MoveTo("","WorkPos2") then
			StopMeasure()
		end
	end
-- animation start

	AlignTo("","Destination")
	Sleep(0.7)
	SetContext("","rangerhut")
	CarryObject("","Handheld_Device/Anim_Hammer.nif", false)
	PlayAnimation("","chop_in")
-- repair value
	local hpmod = 100 + (50 * GetSkillValue("", CRAFTSMANSHIP))
	local hpprocess

-- start the repair
	while GetItemCount("","Tool")>0 and GetItemCount("","BuildMaterial")>0 do
		RemoveItems("","Tool",1)
		RemoveItems("","BuildMaterial",1)
		hpprocess = math.floor(hpmod / 10)
		for i=1,10 do
			PlayAnimation("","chop_loop")
			ModifyHP("Destination",hpprocess,false)
			-- building is at 100% hp
			if GetHP("Destination")==GetMaxHP("Destination") then
				f_EndUseLocator("","WorkPos",GL_STANCE_STAND)
				PlayAnimation("","chop_out")
				CarryObject("","",false)
				StopAnimation()
				chr_GainXP("",GetData("BaseXP"))
				feedback_MessageWorkshop("", 
				"@L_BUILDING_RENOVATE_SUCCESS_HEAD_+0",
				"@L_BUILDING_RENOVATE_SUCCESS_BODY_+0", GetID("Destination"))
				
				if BuildingGetOwner("Destination","Boss") then
					if GetID("")~=GetID("Boss") then
						ModifyFavorToSim("","Boss",10)  
					end
				end
			StopMeasure()
			end
		end
	end

-- not enough tools
	f_EndUseLocator("","WorkPos",GL_STANCE_STAND)
	PlayAnimation("","chop_out")
	CarryObject("","",false)
	StopAnimation("")
	MsgQuick("","_HPFZ_REPARIER_FEHLER_+2")
	StopMeasure()
end

function Cleanup()
	StopAnimation("")
	CarryObject("","",false)
	StopMeasure()
end
