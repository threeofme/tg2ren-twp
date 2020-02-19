function Run()
	if SimGetAge("") > 14 then
		return
	end
	
	if GetImpactValue("","HaveBeenPickpocketed")>0 then
		return
	end

	MeasureRun("","","FollowRatBoy",true)
	Sleep(2)
end

