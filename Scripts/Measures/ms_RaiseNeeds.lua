function Run()

	local Choice1 = "@B[1,@L_RAISENEEDS_Eat_+0,]"
	local Choice2 = "@B[2,@L_RAISENEEDS_Pleasure_+0,]"
	local Choice3 = "@B[3,@L_RAISENEEDS_Talk_+0,]"
	local Choice4 = "@B[4,@L_RAISENEEDS_Faith_+0,]"
	local Choice5 = "@B[5,@L_RAISENEEDS_Curiosity_+0,]"
	local Choice6 = "@B[6,@L_RAISENEEDS_Illness_+0,]"
	local Choice7 = "@B[7,@L_RAISENEEDS_Konsum_+0,]"
	local Choice8 = "@B[8,@L_RAISENEEDS_Drinking_+0,]"
	local Choice9 = "@B[9,@L_RAISENEEDS_Financial_+0,]"
				
	local Result = MsgBox("","Destination","@P"..Choice1..
					Choice2..
					Choice3..
					Choice4..
					Choice5..
					Choice6..
					Choice7..
					Choice8..
					Choice9,"Erhöhe ein Bedürfnis für diesen Sim","Welches Bedürfnis soll erhöht werden?$N")
				
	if Result == 1 then
		SatisfyNeed("Destination",1,(-1))
	elseif Result == 2 then
		SatisfyNeed("Destination",2,(-1))
	elseif Result == 3 then
		SatisfyNeed("Destination",3,(-1))
	elseif Result == 4 then
		SatisfyNeed("Destination",4,(-1))
	elseif Result == 5 then
		SatisfyNeed("Destination",5,(-1))
	elseif Result == 6 then
		SatisfyNeed("Destination",6,(-1))
	elseif Result == 7 then
		SatisfyNeed("Destination",7,(-1))
	elseif Result == 8 then
		SatisfyNeed("Destination",8,(-1))
	else
		SatisfyNeed("Destination",9,(-1))
	end
	
end
