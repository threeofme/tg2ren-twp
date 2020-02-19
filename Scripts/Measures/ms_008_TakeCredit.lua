-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_008_TakeCredit"
----
----	this function is called after the user has selected the credit from the 
----	credit sheet. The selected credit is stored in the property 
----	"CreditNumber"
----
-------------------------------------------------------------------------------


function Run()
	if not AliasExists("Destination") then
		MsgDebugMeasure("TakeCredit - Can not take a credit in this building")
		return
	end
	
	if not HasData("CreditNumber") then
		MsgQuick("", "@L_BANK_008_TAKECREDIT_FAILURES_+0")
		return
	end
	
	local CreditNumber
	CreditNumber = GetData("CreditNumber")
	
	if not BankGetOffer("Destination", "", CreditNumber, "Credit") then
		MsgQuick("", "@L_BANK_008_TAKECREDIT_FAILURES_+0")
		return
	end
	
	local	Sum
	Sum = CreditGetSum("Credit")
	if Sum <= 0 then
		MsgQuick("", "@L_BANK_008_TAKECREDIT_FAILURES_+0")
		return
	end

	if DynastyTakeCredit("Destination", "", CreditNumber) then
		-- the money is transmitted during the take credit function
		feedback_MessageCharacter("",
			"@L_BANK_008_TAKECREDIT_SUCCESS_HEAD_+0",
			"@L_BANK_008_TAKECREDIT_SUCCESS_BODY_+0", Sum)
		
		feedback_OverheadFadeText("", "@L%1t", false, Sum)
	else
		MsgQuick("", "@L_BANK_008_TAKECREDIT_FAILURES_+1")
	end
	
end
