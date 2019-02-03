function ScoreAccuse(Actor)
	if GetDynasty(Actor,"accusing_dynasty") then
		local v = GetProperty("accusing_dynasty","ConvictionScore")
		if v~=nil then
			SetProperty("accusing_dynasty","ConvictionScore",v+1)
--			local left = GetProperty("accusing_dynasty","ConvictionGoal") - GetProperty("accusing_dynasty","ConvictionScore")
--
--			if left==1 then
--				feedback_MessageMission(Actor,"@TMission: Ankläger","@TMit diesem Todesurteil seid Ihr Eurem Auftragsziel ein Stück näher gerückt. Ihr benötigt nur noch ein weiteres Todesurteil zum Sieg.")
--			elseif left>1 then
--				feedback_MessageMission(Actor,"@TMission: Ankläger","@TMit diesem Todesurteil seid Ihr Eurem Auftragsziel ein Stück näher gerückt. Ihr benötigt jetzt noch %1i weitere Todesurteile zum Sieg.", left)
--			end
		end
	end
end

function ScoreCrime(Actor,Money)
	if GetDynasty(Actor,"criminal_dynasty") then
		local v = GetProperty("criminal_dynasty","CrimeMoneyScore")
		if v~=nil then
			SetProperty("criminal_dynasty","CrimeMoneyScore",v+Money)
		else
			SetProperty("criminal_dynasty","CrimeMoneyScore",Money)
		end
	end
end

function IsDeathMatch()
	GetScenario("Scenario")
	-- see DefaultCampaign.lua
	local Mission = GetProperty("Scenario", "AITWP_Mission") or 99
	return Mission == 0
end
