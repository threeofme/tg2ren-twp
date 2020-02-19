-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_007_PaybackCredit"
----
----	this function is called after the user has selected the credit from the 
----	credit sheet. The selected credit is stored in the property 
----	"CreditNumber"
----
-------------------------------------------------------------------------------


function Run()
	if not AliasExists("Destination") then
		MsgDebugMeasure("PaybackCredit - Can not pay back credit in this building")
		return
	end
	
	if not HasData("CreditNumber") then
		MsgQuick("", "@L_BANK_007_PAYBACKCREDIT_FAILURES_+0")
		return
	end
	
	local CreditNumber
	CreditNumber = GetData("CreditNumber")
	
	if not DynastyGetCredit("", CreditNumber, "Credit") then
		MsgQuick("", "@L_BANK_007_PAYBACKCREDIT_FAILURES_+0")
		return
	end
	
	local	Sum
	Sum = CreditGetTotal("Credit")
	
	if GetMoney("") < Sum then
		MsgQuick("", "@L_BANK_007_PAYBACKCREDIT_FAILURES_+1")
		return
	end
	
	if DynastyPaybackCredit("", CreditNumber) then
		-- the money is transmitted during the payback credit function
		feedback_MessageCharacter("",
			"@L_BANK_007_PAYBACKCREDIT_SUCCESS_HEAD_+0",
			"@L_BANK_007_PAYBACKCREDIT_SUCCESS_BODY_+0", Sum)

		feedback_OverheadFadeText("", "@L%1t", false, -Sum)

	else
		MsgQuick("", "@L_BANK_007_PAYBACKCREDIT_FAILURES_+1")
	end
	
end

function CleanUp()
end

