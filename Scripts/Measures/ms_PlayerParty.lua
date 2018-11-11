function Run()

	local choice

	if IsOnlyPartyMember("") then
		choice = MsgBox("dynasty","","@B[-1,Cancel]",
								"@L_BLOODLINE_A_2_+0",
								"@L_BLOODLINE_A_2_+1", GetID(""))
	else
		if IsPartyMember("") then
			choice = MsgBox("dynasty","",
									"@B[1,@L_BLOODLINE_BUTTONS_+1]"..
									"@B[-1,Cancel]",
									"@L_BLOODLINE_A_QUESTION_+0",
									"@L_BLOODLINE_C_QUESTION_+0", GetID(""))
		else
			local count = DynastyGetMemberCount("")
			if count > 2 then
				choice = MsgBox("dynasty","","@B[-1,Cancel]",
										"@L_BLOODLINE_B_5_+0",
										"@L_BLOODLINE_B_5_+1", GetID(""))
			else
				choice = MsgBox("dynasty","",
						"@B[0,@L_BLOODLINE_BUTTONS_+0]"..
						"@B[-1,Cancel]","@L_BLOODLINE_B_QUESTION_+0",
						"@L_BLOODLINE_C_QUESTION_+1", GetID(""))
			end		
		end
	end

	if choice == 0 then
		SimResetBehavior("")
		DynastyAddMember("dynasty","")
	elseif choice == 1 then
		SimSetBehavior("", "idle")
		DynastyRemoveMember("","dynasty")
	else
		StopMeasure()
	end
end

