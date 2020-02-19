-- -----------------------
-- Run
-- -----------------------
function Run()
	local strongboxvalue
	local result
	local value
	local value1
	local value2
	local value3
	
	BuildingGetOwner("","BuildingOwner")
	local DynID = GetDynastyID("BuildingOwner")
	
	if not HasProperty("", "strongbox") then
		SetProperty("", "strongbox", 0)
	end

	while result ~= "C" do
		strongboxvalue = GetProperty("", "strongbox")
		local addMoneyButton = "@B[A,@L_RESIDENCE_STRONGBOX_BUTTON_+0]"
		if GetMoney("dynasty") <= 0 then
			addMoneyButton = ""
		end
	
		if strongboxvalue == 0 then
			result = MsgBox("dynasty", "",
				addMoneyButton.."@B[C,@L_GENERAL_BUTTONS_CLOSE_+0]",
				"@L_RESIDENCE_STRONGBOX_HEAD_+0",
				"@L_RESIDENCE_STRONGBOX_BODY_+1",
				DynID,0,"@L_RESIDENCE_STRONGBOX_BODY_+2")
		else
			result = MsgBox("dynasty", "",
				addMoneyButton.."@B[B,@L_RESIDENCE_STRONGBOX_BUTTON_+1]".."@B[C,@L_GENERAL_BUTTONS_CLOSE_+0]",
				"@L_RESIDENCE_STRONGBOX_HEAD_+0",
				"@L_RESIDENCE_STRONGBOX_BODY_+0",
				DynID,strongboxvalue,"@L_RESIDENCE_STRONGBOX_BODY_+2")
		end
		
		if result == "A" then
			value1 = math.floor(GetMoney("dynasty") / 25)
			value2 = math.floor(GetMoney("dynasty") / 10)
			value3 = math.floor(GetMoney("dynasty") / 5)
			value = MsgBox("dynasty", "",
				"@B[A1,@L_RESIDENCE_STRONGBOX_IN_BUTTON_+0]".."@B[A2,@L_RESIDENCE_STRONGBOX_IN_BUTTON_+1]".."@B[A3,@L_RESIDENCE_STRONGBOX_IN_BUTTON_+2]".."@B[C,@L_GENERAL_BUTTONS_CLOSE_+0]",
				"@L_RESIDENCE_STRONGBOX_HEAD_+0",
				"@L_RESIDENCE_STRONGBOX_BODY_+0",
				DynID,strongboxvalue,"@L_RESIDENCE_STRONGBOX_BODY_+3",value1,value2,value3)
			
			if value == "A1" then
				f_SpendMoney("dynasty",value1,"strongbox")
				SetProperty("", "strongbox", strongboxvalue + value1)
			elseif value == "A2" then
				f_SpendMoney("dynasty",value2,"strongbox")
				SetProperty("", "strongbox", strongboxvalue + value2)
			elseif value == "A3" then
				f_SpendMoney("dynasty",value3,"strongbox")
				SetProperty("", "strongbox", strongboxvalue + value3)
			end
	
		elseif result == "B" then
			value1 = math.floor(strongboxvalue / 2)
			value2 = math.floor(strongboxvalue / 10)
			value = MsgBox("dynasty", "",
				"@B[B1,@L_RESIDENCE_STRONGBOX_OUT_BUTTON_+0]".."@B[B2,@L_RESIDENCE_STRONGBOX_OUT_BUTTON_+1]".."@B[B3,@L_RESIDENCE_STRONGBOX_OUT_BUTTON_+2]".."@B[C,@L_GENERAL_BUTTONS_CLOSE_+0]",
				"@L_RESIDENCE_STRONGBOX_HEAD_+0",
				"@L_RESIDENCE_STRONGBOX_BODY_+0",
				DynID,strongboxvalue,"@L_RESIDENCE_STRONGBOX_BODY_+4",value1,value2,value3)
			
			if value == "B1" then
				f_CreditMoney("dynasty",value1,"strongbox")
				SetProperty("", "strongbox", strongboxvalue - value1)
			elseif value == "B2" then
				f_CreditMoney("dynasty",value2,"strongbox")
				SetProperty("", "strongbox", strongboxvalue - value2)
			elseif value == "B3" then
				f_CreditMoney("dynasty",strongboxvalue,"strongbox")
				SetProperty("", "strongbox", 0)
			end
		end
	end
	
end

