-- -----------------------
-- Run
-- -----------------------
function Run()

	if GetRemainingInventorySpace("","Bridle") < 1 then
		MsgQuick("", "@L_BUY_HORSE_FAILURE_+1")
		StopMeasure()
	elseif GetMoney("") < ItemGetBasePrice("Bridle") then
		MsgQuick("", "@L_BUY_HORSE_FAILURE_+0")
		StopMeasure()
	end

	local choice = MsgBox("", "", "@P@B[0,@L_UPGRADE_RESIDENCE_ANSWER_+0]"..
						"@B[1,@L_UPGRADE_RESIDENCE_ANSWER_+1]",
		        "@L_BUY_HORSE_HEAD_+0",
		        "@L_BUY_HORSE_BODY_+0",
						ItemGetBasePrice("Bridle"))

	if (choice==0) then
		if not f_SpendMoney("", ItemGetBasePrice("Bridle"), "Horse", false) then
			MsgQuick("", "@L_BUY_HORSE_FAILURE_+0")
			StopMeasure()
		end
	
		AddItems("","Bridle",1)
	else
		StopMeasure()
	end
	
end

function CleanUp()
end
