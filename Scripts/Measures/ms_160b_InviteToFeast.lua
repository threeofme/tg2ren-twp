function AIDecision()
	if GetFavorToDynasty("Destination","") < 30 then
		return "C"
	else
		return "O"
	end
end

function Run()
	if not GetHomeBuilding("","MyHome") then
		StopMeasure()
	end
	if not HasProperty("MyHome","InvitationsLeft") then
		StopMeasure()
	end
	local InvitationsLeft = GetProperty("MyHome","InvitationsLeft")
	if InvitationsLeft > 0 then
		if HasProperty("Destination","InvitedBy") then
			if GetProperty("Destination","InvitedBy")==GetID("") then	--invited by me
				MsgQuick("","@L_FEAST_FAILURES_+0",GetID("Destination"))
				StopMeasure()
			else								--invited by someone else
				MsgQuick("","@L_FEAST_FAILURES_+1",GetID("Destination"))
				StopMeasure()
			end
		else
			if not HasProperty("MyHome","PriceForInvite") then
				StopMeasure()
			end
			local PriceToInvite = GetProperty("MyHome","PriceForInvite")
			if not f_SpendMoney("",PriceToInvite,"CostSocial") then
				StopMeasure()
			end
			MsgMeasure("","@L_FEAST_2_INVITE_A_INFOLINE_+1",GetID("Destination"))
			local MsgTimeOut = 1 --15 sekunden
			local PartyDate = GetProperty("MyHome","PartyDate")
			local PartyDateSmall = PartyDate/60
			local BodyText
			if not GetSettlement("MyHome","Settlement") then
				StopMeasure()
			end
			if SimGetGender("Destination")==GL_GENDER_MALE then
				BodyText = "@L_FEAST_2_INVITE_B_LETTER_TO_MALE_+0"
			else
				BodyText = "@L_FEAST_2_INVITE_B_LETTER_TO_FEMALE_+0"
			end
			
			local Result = MsgNews("Destination","",
				"@B[O,@L_FEAST_2_INVITE_B_LETTER_ANSWER_+0]"..
				"@B[C,@L_FEAST_2_INVITE_B_LETTER_ANSWER_+1]",
				ms_160b_invitetofeast_AIDecision,  --AIFunc
				"intrigue", --MessageClass
				MsgTimeOut, --TimeOut
				"@L_FEAST_2_INVITE_B_LETTER_HEADER_+0",
				BodyText,
				GetID("Destination"),
				PartyDate,
				PartyDate,
				GetID("Settlement"),
				"@L_FEAST_2_INVITE_B_LETTER_SUBSCRIPTION_+0",
				GetID(""))
			
					
			if Result == "C" then		--destination didn't want
				local DeclineAnswerBodyText
				if SimGetGender("")==GL_GENDER_MALE then
					DeclineAnswerBodyText = "@L_FEAST_2_INVITE_C_ANSWER_BODY_NO_TO_MALE"
				else
					DeclineAnswerBodyText = "@L_FEAST_2_INVITE_C_ANSWER_BODY_NO_TO_FEMALE"
				end
				
				MsgNewsNoWait("", "Destination", "panel_nobility_title_deed", "schedule", -1,
				--MsgNewsNoWait("", "", "@P", "schedule", -1,
						"@L_FEAST_2_INVITE_C_ANSWER_HEADER_+0", 
						DeclineAnswerBodyText,
						GetID(""),
						"@L_FEAST_2_INVITE_C_ANSWER_SUBSCRIPTION",
						GetID("Destination"))
				StopMeasure()
			else				--destination agrees
				local CurrentTime = math.mod(GetGametime(),24)
				local TimeToCall = (PartyDate/60) - 2
				local AcceptAnswerBodyText
				if SimGetGender("")==GL_GENDER_MALE then
					AcceptAnswerBodyText = "@L_FEAST_2_INVITE_C_ANSWER_BODY_YES_TO_MALE"
				else
					AcceptAnswerBodyText = "@L_FEAST_2_INVITE_C_ANSWER_BODY_YES_TO_FEMALE"
				end
				MsgNewsNoWait("", "Destination", "panel_nobility_title_deed", "schedule", -1,
				--MsgNewsNoWait("", "", "@P", "schedule", -1,
						"@L_FEAST_2_INVITE_C_ANSWER_HEADER_+0", 
						AcceptAnswerBodyText,
						GetID(""),
						PartyDate,
						GetID("Destination"),
						GetID("Settlement"),
						"@L_FEAST_2_INVITE_C_ANSWER_SUBSCRIPTION")
				
				SetProperty("MyHome","Guest"..InvitationsLeft,GetID("Destination"))
				InvitationsLeft = InvitationsLeft - 1
				SetProperty("MyHome","InvitationsLeft",InvitationsLeft)
				SetProperty("Destination","InvitedBy",GetID(""))
				local SimsInvited = 6 - InvitationsLeft
				SimAddDatebookEntry("", PartyDate, "MyHome", "@L_FEAST_5_TIMEPLANNERENTRY_INVITER_+0",
								"@L_FEAST_5_TIMEPLANNERENTRY_INVITER_+1",
								GetID(""),SimsInvited,GetID("Settlement"))
				SimAddDatebookEntry("Destination", PartyDate, "MyHome", "@L_FEAST_5_TIMEPLANNERENTRY_GUEST_+0",
								"@L_FEAST_5_TIMEPLANNERENTRY_GUEST_+1",
								GetID("Destination"),GetID(""),GetID("Settlement"))				
				CreateScriptcall("CallToFeast",TimeToCall-GetGametime(),"Measures/ms_160b_InviteToFeast.lua","CallToFeast","Destination")
				StopMeasure()
			end
		end
	--too much invitations
	else	
		MsgQuick("","@L_FEAST_FAILURES_+2")
		StopMeasure()
	end	
end

function CallToFeast()
	if GetState("",STATE_CUTSCENE) then
		return
	end
	if GetState("",STATE_LOCKED) then
		return
	end
	if not HasProperty("","InvitedBy") then
		StopMeasure()
	end
	local HostID = GetProperty("","InvitedBy")
	if not GetAliasByID(HostID,"PartyHost") then
		StopMeasure()
	end
	if GetFavorToDynasty("","PartyHost") < 30 then
		StopMeasure()
	end
	if not GetHomeBuilding("PartyHost","PartyLocation") then
		StopMeasure()
	end
	if not BuildingHasUpgrade("PartyLocation",531) then	--salon
		StopMeasure()
	end
	if not MeasureRun("","PartyLocation","AttendFestivity") then
		StopMeasure()
	end
end

function CleanUp()

end

