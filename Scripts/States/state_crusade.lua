function Init()
	SetStateImpact("no_idle")
	SetStateImpact("no_control")
	SetStateImpact("no_hire")
	SetStateImpact("no_enter")
	SetStateImpact("no_measure_attach")
	SetStateImpact("no_measure_start")
	SetStateImpact("NoCameraJump")
end

function Run()
	if not HasProperty("","CrusadeLeaderID") then
		SetState("",STATE_CRUSADE,false)
	end
	local CrusadeLeaderID = GetProperty("","CrusadeLeaderID")
	RemoveProperty("","CrusadeLeaderID")
	if not GetAliasByID(CrusadeLeaderID,"CrusadeLeader") then
		SetState("",STATE_CRUSADE,false)
	end
	
	MsgSay("","@L_PRIVILEGES_LEADCRUSADE_SPEECH_COMMENTS")
	
	if GetDynastyID("")<=0 then
		SimSetClass("",4)
		AddItems("","Platemail",1,INVENTORY_EQUIPMENT)
	end
	
	CarryObject("","Handheld_Device/ANIM_Shield.nif",true)
	CarryObject("","weapons/mace_02.nif",false)
	
	while not HasProperty("CrusadeLeader","CrusadeDestinationID") do	
		if (GetCurrentMeasureID("CrusadeLeader")~=1111) then
			SetState("",STATE_CRUSADE,false)
		end
		Sleep(1)
	end
	
	if not GetOutdoorLocator("MapExit1",1,"CrusadeDestination") then
		if not GetOutdoorLocator("MapExit2",1,"CrusadeDestination") then
		    if not GetOutdoorLocator("MapExit3",1,"CrusadeDestination") then
--	            local citys = ScenarioGetObjects("Settlement", 10, "Stadt")
--		        for r =0, citys-1 do
--				    local k = Rand(citys)-1
--		            if CityIsKontor("Stadt"..k) == false then
--			            CityGetRandomBuilding("Stadt"..k,-1,18,-1,-1,FILTER_IGNORE,"CrusadeDestination")
--						break
					SetState("",STATE_CRUSADE,false)
--			        end
--		        end	
            end
		end
	end
	
	while HasProperty("CrusadeLeader","NumCrusaders") do
		if (GetImpactValue("CrusadeLeader","IsOnCrusade")==1) and (GetImpactValue("","IsOnCrusade")==0) then
			AddImpact("","IsOnCrusade",1,1)
			if not GetPosition("","StartPos") then
				SetState("",STATE_CRUSADE,false)
			end
			if not HasProperty("CrusadeLeader","CrusadeContainerID") then
				SetState("",STATE_CRUSADE,false)
			end
			
			GetAliasByID(GetProperty("CrusadeLeader","CrusadeContainerID"),"CrusadeContainer")
			MoveStop("")
	--		SimBeamMeUp("","CrusadeContainer",false)
			SetInvisible("", true)
			AddImpact("", "Hidden", 1 , -1)
		end
		Sleep(2)
	end
	if DynastyIsAI("") then
		if AliasExists("StartPos") then
			f_MoveTo("","StartPos")
		end
	end
	SimResetBehavior("")
	SetState("",STATE_CRUSADE,false)
end

function CleanUp()
	RemoveItems("",74,1,INVENTORY_EQUIPMENT)
	CarryObject("","",false)
	CarryObject("","",true)
	RemoveImpact("","Hidden")
	SetInvisible("", false)
end

