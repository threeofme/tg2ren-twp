function Run()

	-- send the message to the user
	local Gender = SimGetGender("")
	local HeaderLabel
	local BodyLabel
	local SubstLabel
	
	if(Gender == GL_GENDER_MALE) then
		HeaderLabel = "@L_FAMILY_2_COHABITATION_BIRTH_MESSAGE_HEAD_SON_+0";
		BodyLabel = "@L_FAMILY_2_COHABITATION_BIRTH_MESSAGE_BODY_SON_+0";
		SubstLabel = "@L_FAMILY_2_COHABITATION_BIRTH_BAPTISM_SON_+0";
	else
		HeaderLabel = "@L_FAMILY_2_COHABITATION_BIRTH_MESSAGE_HEAD_DAUGHTER_+0";
		BodyLabel = "@L_FAMILY_2_COHABITATION_BIRTH_MESSAGE_BODY_DAUGHTER_+0";
		SubstLabel = "@L_FAMILY_2_COHABITATION_BIRTH_BAPTISM_DAUGHTER_+0";
	end
	
	local PanelParam = "@N".."@B[0,@L_FAMILY_2_COHABITATION_BIRTH_BAPTISM_BTN_+1]"    
	
	if(AliasExists("SetName") == true) then
		PanelParam = "MB_OK"    		
		SubstLabel = ""
	end

	if (IsPartyMember("Destination")) then
		MsgNews("Destination","",PanelParam,0,"default",1,HeaderLabel,BodyLabel,GetID("Destination"),SubstLabel)
	else
		SimGetSpouse("Destination", "Spouse")
		MsgNews("Spouse","",PanelParam,0,"default",1,HeaderLabel,BodyLabel,GetID("Destination"),SubstLabel)
	end	
end
