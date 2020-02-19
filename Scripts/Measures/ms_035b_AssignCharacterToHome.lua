-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_035b_AssignCharacterToHome"
----
----	with this measure the player can assign a new residence to one of his
----	main characters
----
-------------------------------------------------------------------------------


function Run()
	GetInsideBuilding("", "Destination")

	if AliasExists("Destination") then
	
		if GetHomeBuilding("","OldHome") then
			if GetState("OldHome",STATE_FEAST) then
				MsgQuick("", "@L_GENERAL_MEASURES_035_ASSIGNCHARACTERTOBUILDING_FAILURES_+1", GetID(""))
				return
			end
		end
		
		if BuildingGetType("Destination")~=GL_BUILDING_TYPE_RESIDENCE then
			MsgQuick("", "@L_GENERAL_MEASURES_035_ASSIGNCHARACTERTOBUILDING_FAILURES_+0", GetID(""))
			return
		end

		if GetSettlementID("")~=GetSettlementID("Destination") then
			if SimGetOfficeID("")~=-1 then
				MsgQuick("", "@L_GENERAL_MEASURES_035_ASSIGNCHARACTERTOBUILDING_FAILURES_+2", GetID(""))
				return
			end
			
			if SimIsAppliedForOffice("") then
				MsgQuick("", "@L_GENERAL_MEASURES_035_ASSIGNCHARACTERTOBUILDING_FAILURES_+3", GetID(""))
				return
			end
			
			if SimGetCourtLover("", "Loverboy") then
				MsgQuick("", "@L_INTERFACE_ASSIGNCHARACTERTOBUILDING_+1")
				return
			end
		end
		
		f_MoveTo("", "Destination", GL_MOVESPEED_RUN)

		if ChangeResidence("", "Destination") then
			feedback_MessageWorkshop("",
				"@L_GENERAL_MEASURES_035_ASSIGNCHARACTERTOBUILDING_SUCCESS_HEAD_+0",
				"@L_GENERAL_MEASURES_035_ASSIGNCHARACTERTOBUILDING_SUCCESS_BODY_+0", GetID("Owner"), GetID("Destination"))
		else
			MsgQuick("", "@L_GENERAL_MEASURES_035_ASSIGNCHARACTERTOBUILDING_FAILURES_+0", GetID("Owner"), GetID("Destination"))
		end
	end
end
