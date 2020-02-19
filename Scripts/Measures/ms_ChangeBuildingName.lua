function Run()

	-- send the message to the user
	local HeaderLabel
	local BodyLabel
	local SubstLabel
	HeaderLabel = "@L_MEASURE_ChangeBuildingName_HEAD_+0";
	BodyLabel = "@L_MEASURE_ChangeBuildingName_BODY_+0";

	
	local PanelParam = "@N".."@B[0,@L_FAMILY_2_COHABITATION_BIRTH_BAPTISM_BTN_+1]"    

	MsgBox("","",PanelParam,HeaderLabel,BodyLabel,GetID(""))
	
end
