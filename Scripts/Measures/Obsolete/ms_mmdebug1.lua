function Run()

	GetSettlement("","TheCity")
	CityGetDynastyCharList("TheCity","assessor_candidates") 
	for i=0,ListSize("assessor_candidates")-1,1 do
		ListGetElement("assessor_candidates",i,"tmpa")
		OutputDebugString("Name: "..GetName("tmpa").."\n")
	end
end
 