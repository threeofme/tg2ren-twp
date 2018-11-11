function Run()

	if not BuildingGetCity("","City") then
		StopMeasure()
	end

	local BandageCount = GetProperty("", ItemGetID("Bandage")) or 0
	BandageCount = BandageCount + GetItemCount("", "Bandage", INVENTORY_STD)
	
	local MedicineCount = GetProperty("", ItemGetID("Medicine")) or 0
	MedicineCount = MedicineCount + GetItemCount("", "Medicine", INVENTORY_STD)
	
	local SalveCount = GetProperty("", ItemGetID("Salve")) or 0
	SalveCount = SalveCount + GetItemCount("", "Salve", INVENTORY_STD)
	
	local PainkillerCount = GetProperty("", ItemGetID("PainKiller")) or 0
	PainkillerCount = PainkillerCount + GetItemCount("", "PainKiller", INVENTORY_STD)
	
	local SprainInfected = GetProperty("City","SprainInfected") or 0
	local ColdInfected = GetProperty("City","ColdInfected") or 0
	local InfluenzaInfected = GetProperty("City","InfluenzaInfected") or 0
	local BurnWoundInfected = GetProperty("City","BurnWoundInfected") or 0
	local PoxInfected = GetProperty("City","PoxInfected") or 0
	local PneumoniaInfected = GetProperty("City","PneumoniaInfected") or 0
	local BlackdeathInfected = GetProperty("City","BlackdeathInfected") or 0
	local FractureInfected = GetProperty("City","FractureInfected") or 0
	local CariesInfected = GetProperty("City","CariesInfected") or 0

	MsgBoxNoWait("dynasty", "", "@L_MEASURE_showdiseasedpeople_HEAD_+0",
						"@L_MEASURE_showdiseasedpeople_BODY_+0",
						GetID("City"), 
						"@L_ONSCREENHELP_9_ACTION_IMPACT_Sprain_NAME_+0", SprainInfected, BandageCount, ItemGetLabel("Bandage",false), 
						"@L_ONSCREENHELP_9_ACTION_IMPACT_Cold_NAME_+0", ColdInfected, BandageCount, ItemGetLabel("Bandage",false), 
						"@L_ONSCREENHELP_9_ACTION_IMPACT_Influenza_NAME_+0", InfluenzaInfected, MedicineCount, ItemGetLabel("Medicine",false), 
						"@L_ONSCREENHELP_9_ACTION_IMPACT_BurnWound_NAME_+0", BurnWoundInfected, SalveCount, ItemGetLabel("Salve",false), 
						"@L_ONSCREENHELP_9_ACTION_IMPACT_Pox_NAME_+0", PoxInfected, MedicineCount, ItemGetLabel("Medicine",false), 
						"@L_ONSCREENHELP_9_ACTION_IMPACT_Fracture_NAME_+0", FractureInfected, PainkillerCount, ItemGetLabel("PainKiller",false), 
						"@L_ONSCREENHELP_9_ACTION_IMPACT_Caries_NAME_+0", CariesInfected, PainkillerCount, ItemGetLabel("PainKiller",false),
						"@L_ONSCREENHELP_9_ACTION_IMPACT_Pneumonia_NAME_+0", PneumoniaInfected, PainkillerCount, ItemGetLabel("PainKiller",false), 
						"@L_ONSCREENHELP_9_ACTION_IMPACT_Blackdeath_NAME_+0", BlackdeathInfected, PainkillerCount, ItemGetLabel("PainKiller",false)) 

end
