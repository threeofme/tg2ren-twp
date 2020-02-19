-------------------------------------------------------------------------------
----
----	OVERVIEW "ArrangeConcert.lua"
----
-------------------------------------------------------------------------------
function Run()
	local MusiciansFee = 0

	if AliasExists("Destination") then
		if SimGetRank("")<2 then
			MusiciansFee = 50
		elseif SimGetRank("")>1 and SimGetRank("")<4 then
			MusiciansFee = 100
		elseif SimGetRank("")>3 then 
			MusiciansFee = 200
		end
		
		MusiciansFee = MusiciansFee + (Rand(3) * 50)
		
		if GetMoney("")<MusiciansFee then
			MusiciansFee = 0
		end
		
		SetProperty("Destination", "MusiciansFee", MusiciansFee)
		StopMeasure()

	else
		local result
		
		while result ~= "C" do
			if HasProperty("", "MusiciansFee") then
				MusiciansFee = GetProperty("", "MusiciansFee")
			else
				SetProperty("", "MusiciansFee", 0)
			end
	
			local addMoneyButton = "@B[A,@L_ARRANGECONCERT_BUTTON_+0]"
			if GetMoney("dynasty") <= 200 then
				addMoneyButton = ""
			end
	
			result = MsgBox("dynasty", "",
				addMoneyButton.."@B[B,@L_ARRANGECONCERT_BUTTON_+1]".."@B[C,@L_GENERAL_BUTTONS_CLOSE_+0]",
				"@L_ARRANGECONCERT_HEAD_+0",
				"@L_ARRANGECONCERT_BODY_+0",
				MusiciansFee,"@L_ARRANGECONCERT_BODY_+2")
			
			if result == "A" then
				value1 = 50
				value2 = 100
				value3 = 200
				value = MsgBox("dynasty", "",
					"@B[A1,@L_ARRANGECONCERT_IN_BUTTON_+0]".."@B[A2,@L_ARRANGECONCERT_IN_BUTTON_+1]".."@B[A3,@L_ARRANGECONCERT_IN_BUTTON_+2]".."@B[C,@L_GENERAL_BUTTONS_CLOSE_+0]",
					"@L_ARRANGECONCERT_HEAD_+0",
					"@L_ARRANGECONCERT_BODY_+0",
					MusiciansFee,"@L_ARRANGECONCERT_BODY_+3",value1,value2,value3)
				
				if value == "A1" then
					SetProperty("", "MusiciansFee", MusiciansFee + value1)
				elseif value == "A2" then
					SetProperty("", "MusiciansFee", MusiciansFee + value2)
				elseif value == "A3" then
					SetProperty("", "MusiciansFee", MusiciansFee + value3)
				end
		
			elseif result == "B" then
				value1 = 50
				value2 = 100
				value = MsgBox("dynasty", "",
					"@B[B1,@L_ARRANGECONCERT_OUT_BUTTON_+0]".."@B[B2,@L_ARRANGECONCERT_OUT_BUTTON_+1]".."@B[B3,@L_ARRANGECONCERT_OUT_BUTTON_+2]".."@B[C,@L_GENERAL_BUTTONS_CLOSE_+0]",
					"@L_ARRANGECONCERT_HEAD_+0",
					"@L_ARRANGECONCERT_BODY_+0",
					MusiciansFee,"@L_ARRANGECONCERT_BODY_+4",value1,value2)
				
				if value == "B1" then
					local calc = MusiciansFee - value1
					if calc < 0 then
						SetProperty("", "MusiciansFee", 0)
					else
						SetProperty("", "MusiciansFee", MusiciansFee - value1)
					end
				elseif value == "B2" then
					local calc = MusiciansFee - value2
					if calc < 0 then
						SetProperty("", "MusiciansFee", 0)
					else
						SetProperty("", "MusiciansFee", MusiciansFee - value2)
					end
				elseif value == "B3" then
					SetProperty("", "MusiciansFee", 0)
				end
			end
		end
	end
end

function CleanUp()
end
