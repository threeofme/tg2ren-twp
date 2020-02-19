-- ms_MedicineChest by Fajeth
-- Script for better storage of medical supplies, input and output

function Run()

	CopyAlias("","Workshop")
	
	-- stored inside the chest
	
	local result, result2, result3
	local Salves = 0
	local Bandages = 0
	local Medicines = 0
	local PainKillers = 0
	local Soaps = 0
	local MiracleCures = 0
	
	-- stored inside the building's inventory
	
	local StoredSalve = GetItemCount("","Salve",INVENTORY_STD)
	local StoredBandage = GetItemCount("","Bandage",INVENTORY_STD)
	local StoredMedicine = GetItemCount("","Medicine",INVENTORY_STD)
	local StoredPainKiller = GetItemCount("","PainKiller",INVENTORY_STD)
	local StoredSoap = GetItemCount("","Soap",INVENTORY_STD)
	local StoredMiracleCure = GetItemCount("","MiracleCure",INVENTORY_STD)
	
	-- for input purpose
	
	local RemoveSalve = 0
	local RemoveBandage = 0
	local RemoveMedicine = 0
	local RemovePainKiller = 0
	local RemoveSoap = 0
	local RemoveMiracleCure = 0
	
	-- get actual values from the chest
	
	if HasProperty("Workshop","Salves") then
		Salves = GetProperty("Workshop","Salves")
	end
	
	if HasProperty("Workshop","Bandages") then
		Bandages = GetProperty("Workshop","Bandages")
	end
	
	if HasProperty("Workshop","Medicines") then
		Medicines = GetProperty("Workshop","Medicines")
	end
	
	if HasProperty("Workshop","PainKillers") then
		PainKillers = GetProperty("Workshop","PainKillers")
	end
	
	if HasProperty("Workshop","Soaps") then
		Soaps = GetProperty("Workshop","Soaps")
	end
	
	if HasProperty("Workshop","MiracleCures") then
		MiracleCures = GetProperty("Workshop","MiracleCures")
	end
	
	-- Screen
	if not IsStateDriven() then
		result = MsgNews("dynasty","","@P"..
					"@B[0,@L_MEASURE_MEDICINECHEST_INPUT_GENERAL_+0]"..
					"@B[1,@L_MEASURE_MEDICINECHEST_OUTPUT_GENERAL_+0]"..
					"@B[2,@L_MEASURE_ORDERCREDIT_STUFF_+4]",
					0,
					"production",-1,"@L_MEASURE_MEDICINECHEST_HEAD_+0",
					"@L_MEASURE_MEDICINECHEST_BODY_+0",GetID("Workshop"),
					Salves,Bandages,Medicines,PainKillers,
					Soaps, MiracleCures)
	else
		result = 0
	end
					
	-- input
	if result == 0 then
		
		local Input1 = "@B[1,@L_MEASURE_MEDICINECHEST_INPUT_SALVES_+0]"
		if StoredSalve<1 then
			Input1 = ""
		end
		
		local Input2 = "@B[2,@L_MEASURE_MEDICINECHEST_INPUT_BANDAGES_+0]"
		if StoredBandage<1 then
			Input2 = ""
		end
		
		local Input3 = "@B[3,@L_MEASURE_MEDICINECHEST_INPUT_MEDICINES_+0]"
		if StoredMedicine<1 then
			Input3 = ""
		end
		
		local Input4 = "@B[4,@L_MEASURE_MEDICINECHEST_INPUT_PAINKILLERS_+0]"
		if StoredPainKiller<1 then
			Input4 = ""
		end
		
		local Input5 = "@B[5,@L_MEASURE_MEDICINECHEST_INPUT_SOAPS_+0]"
		if StoredSoap<1 then
			Input5 = ""
		end
		
		local Input6 = "@B[6,@L_MEASURE_MEDICINECHEST_INPUT_MIRACLECURES_+0]"
		if StoredMiracleCure<1 then
			Input6 = ""
		end
		
		if not IsStateDriven() then		
			result2 = MsgNews("dynasty","","@P"..
						"@B[0,@L_MEASURE_MEDICINECHEST_INPUT_ALL_+0]"..
						Input1..
						Input2..
						Input3..
						Input4..
						Input5..
						Input6..
						"@B[7,@L_MEASURE_ORDERCREDIT_STUFF_+4]",
						0,
						"production",-1,"@L_MEASURE_MEDICINECHEST_INPUT_HEAD_+0",
						"@L_MEASURE_MEDICINECHEST_INPUT_BODY_+0")
		else
			result2 = 0
		end
		-- input all
		if result2 == 0 then
			-- remove the items from the building's inventory and add everything to the chest
			if StoredSalve > 0 then
				if IsStateDriven() then -- AI only stores 20
					if StoredSalve < 20 then
						RemoveSalve = RemoveItems("","Salve",StoredSalve,INVENTORY_STD)
						SetProperty("","Salves",(Salves+RemoveSalve))
					end
				else
					RemoveSalve = RemoveItems("","Salve",StoredSalve,INVENTORY_STD)
					SetProperty("","Salves",(Salves+RemoveSalve))
				end
			end
				
			if StoredBandage > 0 then
				RemoveBandage = RemoveItems("","Bandage",StoredBandage,INVENTORY_STD)
				SetProperty("","Bandages",(Bandages+RemoveBandage))
			end
				
			if StoredMedicine > 0 then
				RemoveMedicine = RemoveItems("","Medicine",StoredMedicine,INVENTORY_STD)
				SetProperty("","Medicines",(Medicines+RemoveMedicine))
			end
			
			if StoredPainKiller > 0 then
				RemovePainKiller = RemoveItems("","PainKiller",StoredPainKiller,INVENTORY_STD)
				SetProperty("","PainKillers",(PainKillers+RemovePainKiller))
			end
			
			if StoredSoap > 0 then
				if IsStateDriven() then -- AI only stores some soap
					if StoredSoap < 9 then
						RemoveSoap = RemoveItems("", "Soap", StoredSoap, INVENTORY_STD)
						SetProperty("", "Soaps", (Soaps+RemoveSoap))
					end
				else
					RemoveSoap = RemoveItems("","Soap",StoredSoap,INVENTORY_STD)
					SetProperty("","Soaps",(Soaps+RemoveSoap))
				end
			end
			
			if StoredMiracleCure > 0 then
				RemoveMiracleCure = RemoveItems("","MiracleCure",StoredMiracleCure,INVENTORY_STD)
				SetProperty("","MiracleCures",(MiracleCures+RemoveMiracleCure))
			end
			
			if not IsStateDriven() then
				-- X units have been added to the chest
				MsgBoxNoWait("dynasty", "Workshop", "@L_MEASURE_MEDICINECHEST_INPUT_HEAD_+0",
						"@L_MEASURE_MEDICINECHEST_INPUT_SUCCESS_ALL_BODY_+0",GetID("Workshop"),
						RemoveSalve, RemoveBandage, RemoveMedicine, RemovePainKiller, RemoveSoap, RemoveMiracleCure)
			end
		-- input salve
		elseif result2 == 1 then
			if StoredSalve > 0 then 
				RemoveSalve = RemoveItems("","Salve",StoredSalve,INVENTORY_STD)
				SetProperty("","Salves",(Salves+RemoveSalve))
				
				-- X units have been added to the chest
				MsgBoxNoWait("dynasty", "Workshop", "@L_MEASURE_MEDICINECHEST_INPUT_HEAD_+0",
						"@L_MEASURE_MEDICINECHEST_INPUT_SUCCESS_SALVE_BODY_+0",GetID("Workshop"),
						RemoveSalve)
			else
				-- Error, no Salves on stock
				MsgBoxNoWait("dynasty", "Workshop", "@L_MEASURE_MEDICINECHEST_INPUT_HEAD_+0",
						"@L_MEASURE_MEDICINECHEST_INPUT_FAIL_SALVE_BODY_+0",GetID("Workshop"))
			end
			
		-- input bandage
		elseif result2 == 2 then
			if StoredBandage > 0 then 
				RemoveBandage = RemoveItems("","Bandage",StoredBandage,INVENTORY_STD)
				SetProperty("","Bandages",(Bandages+RemoveBandage))
				
				-- X units have been added to the chest
				MsgBoxNoWait("dynasty", "Workshop", "@L_MEASURE_MEDICINECHEST_INPUT_HEAD_+0",
						"@L_MEASURE_MEDICINECHEST_INPUT_SUCCESS_BANDAGE_BODY_+0",GetID("Workshop"),
						RemoveBandage)
			else
				-- Error, no bandages on stock
				MsgBoxNoWait("dynasty", "Workshop", "@L_MEASURE_MEDICINECHEST_INPUT_HEAD_+0",
						"@L_MEASURE_MEDICINECHEST_INPUT_FAIL_BANDAGE_BODY_+0",GetID("Workshop"))
			end
		
		-- input medicine
		elseif result2 == 3 then
			if StoredMedicine > 0 then
				RemoveMedicine = RemoveItems("","Medicine",StoredMedicine,INVENTORY_STD)
				SetProperty("","Medicines",(Medicines+RemoveMedicine))
				
				-- X units have been added to the chest
				MsgBoxNoWait("dynasty", "Workshop", "@L_MEASURE_MEDICINECHEST_INPUT_HEAD_+0",
						"@L_MEASURE_MEDICINECHEST_INPUT_SUCCESS_MEDICINE_BODY_+0",GetID("Workshop"),
						RemoveMedicine)
			else
				-- Error, no medicines on stock
				MsgBoxNoWait("dynasty", "Workshop", "@L_MEASURE_MEDICINECHEST_INPUT_HEAD_+0",
						"@L_MEASURE_MEDICINECHEST_INPUT_FAIL_MEDICINE_BODY_+0",GetID("Workshop"))
			end
		
		-- input painkiller
		elseif result2 == 4 then
			if StoredPainKiller > 0 then
				RemovePainKiller = RemoveItems("","PainKiller",StoredPainKiller,INVENTORY_STD)
				SetProperty("","PainKillers",(PainKillers+RemovePainKiller))
				
				-- X units have been added to the chest
				MsgBoxNoWait("dynasty", "Workshop", "@L_MEASURE_MEDICINECHEST_INPUT_HEAD_+0",
						"@L_MEASURE_MEDICINECHEST_INPUT_SUCCESS_PAINKILLER_BODY_+0",GetID("Workshop"),
						RemovePainKiller)
			else
				-- Error, no painkillers on stock
				MsgBoxNoWait("dynasty", "Workshop", "@L_MEASURE_MEDICINECHEST_INPUT_HEAD_+0",
						"@L_MEASURE_MEDICINECHEST_INPUT_FAIL_PAINKILLER_BODY_+0",GetID("Workshop"))
			end
		
		-- input soap
		elseif result2 == 5 then
			if StoredSoap > 0 then
				RemoveSoap = RemoveItems("","Soap",StoredSoap,INVENTORY_STD)
				SetProperty("","Soaps",(Soaps+RemoveSoap))
				
				-- X units have been added to the chest
				MsgBoxNoWait("dynasty", "Workshop", "@L_MEASURE_MEDICINECHEST_INPUT_HEAD_+0",
						"@L_MEASURE_MEDICINECHEST_INPUT_SUCCESS_SOAP_BODY_+0",GetID("Workshop"),
						RemoveSoap)
			else
				-- Error, no soaps on stock
				MsgBoxNoWait("dynasty", "Workshop", "@L_MEASURE_MEDICINECHEST_INPUT_HEAD_+0",
						"@L_MEASURE_MEDICINECHEST_INPUT_FAIL_SOAP_BODY_+0",GetID("Workshop"))
			end
		
		-- input miraclecure
		elseif result2 == 6 then
			if StoredMiracleCure > 0 then
				RemoveMiracleCure = RemoveItems("","MiracleCure",StoredMiracleCure,INVENTORY_STD)
				SetProperty("","MiracleCures",(MiracleCures+RemoveMiracleCure))
				
				-- X units have been added to the chest
				MsgBoxNoWait("dynasty", "Workshop", "@L_MEASURE_MEDICINECHEST_INPUT_HEAD_+0",
						"@L_MEASURE_MEDICINECHEST_INPUT_SUCCESS_MIRACLECURE_BODY_+0",GetID("Workshop"),
						RemoveMiracleCure)
			else
				-- Error, no miraclecures on stock
				MsgBoxNoWait("dynasty", "Workshop", "@L_MEASURE_MEDICINECHEST_INPUT_HEAD_+0",
						"@L_MEASURE_MEDICINECHEST_INPUT_FAIL_MIRACLECURE_BODY_+0",GetID("Workshop"))
			end
		end
	
	-- output
	elseif result == 1 then
		local Output1 = "@B[1,@L_MEASURE_MEDICINECHEST_OUTPUT_SALVES_+0]"
		if Salves<1 then
			Output1 = ""
		end
		
		local Output2 = "@B[2,@L_MEASURE_MEDICINECHEST_OUTPUT_BANDAGES_+0]"
		if Bandages<1 then
			Output2 = ""
		end
		
		local Output3 = "@B[3,@L_MEASURE_MEDICINECHEST_OUTPUT_MEDICINES_+0]"
		if Medicines<1 then
			Output3 = ""
		end
		
		local Output4 = "@B[4,@L_MEASURE_MEDICINECHEST_OUTPUT_PAINKILLERS_+0]"
		if PainKillers<1 then
			Output4 = ""
		end
		
		local Output5 = "@B[5,@L_MEASURE_MEDICINECHEST_OUTPUT_SOAPS_+0]"
		if Soaps<1 then
			Output5 = ""
		end
		
		local Output6 = "@B[6,@L_MEASURE_MEDICINECHEST_OUTPUT_MIRACLECURES_+0]"
		if MiracleCures<1 then
			Output6 = ""
		end
		
		result3 = MsgNews("","","@P"..
						Output1..
						Output2..
						Output3..
						Output4..
						Output5..
						Output6..
						"@B[7,@L_MEASURE_ORDERCREDIT_STUFF_+4]",
						-1,
						"production",-1,"@L_MEASURE_MEDICINECHEST_OUTPUT_HEAD_+0",
						"@L_MEASURE_MEDICINECHEST_OUTPUT_BODY_+0")
		
		-- output salve
		if result3 == 1 then
			if CanAddItems("Workshop","Salve",Salves, INVENTORY_STD) then -- check for space
				RemoveProperty("Workshop","Salves")
				AddItems("Workshop","Salve",Salves, INVENTORY_STD)
				
				-- X units have been added to the stock
				MsgBoxNoWait("dynasty", "Workshop", "@L_MEASURE_MEDICINECHEST_OUTPUT_HEAD_+0",
						"@L_MEASURE_MEDICINECHEST_OUTPUT_SUCCESS_SALVE_BODY_+0",GetID("Workshop"),
						Salves)
			else
				-- not enough space
				MsgBoxNoWait("dynasty", "Workshop", "@L_MEASURE_MEDICINECHEST_OUTPUT_HEAD_+0",
						"@L_MEASURE_MEDICINECHEST_OUTPUT_FAIL_SALVE_BODY_+0",GetID("Workshop"),
						Salves)
			end
		
		-- output bandage
		elseif result3 == 2 then
			if CanAddItems("Workshop","Bandage",Bandages, INVENTORY_STD) then -- check for space
				RemoveProperty("Workshop","Bandages")
				AddItems("Workshop","Bandage",Bandages, INVENTORY_STD)
				
				-- X units have been added to the stock
				MsgBoxNoWait("dynasty", "Workshop", "@L_MEASURE_MEDICINECHEST_OUTPUT_HEAD_+0",
						"@L_MEASURE_MEDICINECHEST_OUTPUT_SUCCESS_BANDAGE_BODY_+0",GetID("Workshop"),
						Bandages)
			else
				-- not enough space
				MsgBoxNoWait("dynasty", "Workshop", "@L_MEASURE_MEDICINECHEST_OUTPUT_HEAD_+0",
						"@L_MEASURE_MEDICINECHEST_OUTPUT_FAIL_BANDAGE_BODY_+0",GetID("Workshop"),
						Bandages)
			end
			
		-- output medicine
		elseif result3 == 3 then
			if CanAddItems("Workshop","Medicine",Medicines, INVENTORY_STD) then -- check for space
				RemoveProperty("Workshop","Medicines")
				AddItems("Workshop","Medicine",Medicines, INVENTORY_STD)
				
				-- X units have been added to the stock
				MsgBoxNoWait("dynasty", "Workshop", "@L_MEASURE_MEDICINECHEST_OUTPUT_HEAD_+0",
						"@L_MEASURE_MEDICINECHEST_OUTPUT_SUCCESS_MEDICINE_BODY_+0",GetID("Workshop"),
						Medicines)
			else
				-- not enough space
				MsgBoxNoWait("dynasty", "Workshop", "@L_MEASURE_MEDICINECHEST_OUTPUT_HEAD_+0",
						"@L_MEASURE_MEDICINECHEST_OUTPUT_FAIL_MEDICINE_BODY_+0",GetID("Workshop"),
						Medicines)
			end
			
		-- output painkiller
		elseif result3 == 4 then
			if CanAddItems("Workshop","PainKiller",PainKillers, INVENTORY_STD) then -- check for space
				RemoveProperty("Workshop","PainKillers")
				AddItems("Workshop","PainKiller",PainKillers, INVENTORY_STD)
				
				-- X units have been added to the stock
				MsgBoxNoWait("dynasty", "Workshop", "@L_MEASURE_MEDICINECHEST_OUTPUT_HEAD_+0",
						"@L_MEASURE_MEDICINECHEST_OUTPUT_SUCCESS_PAINKILLER_BODY_+0",GetID("Workshop"),
						PainKillers)
			else
				-- not enough space
				MsgBoxNoWait("dynasty", "Workshop", "@L_MEASURE_MEDICINECHEST_OUTPUT_HEAD_+0",
						"@L_MEASURE_MEDICINECHEST_OUTPUT_FAIL_PAINKILLER_BODY_+0",GetID("Workshop"),
						PainKillers)
			end
			
		-- output soap
		elseif result3 == 5 then
			if CanAddItems("Workshop","Soap",Soaps, INVENTORY_STD) then -- check for space
				RemoveProperty("Workshop","Soaps")
				AddItems("Workshop","Soap",Soaps, INVENTORY_STD)
				
				-- X units have been added to the stock
				MsgBoxNoWait("dynasty", "Workshop", "@L_MEASURE_MEDICINECHEST_OUTPUT_HEAD_+0",
						"@L_MEASURE_MEDICINECHEST_OUTPUT_SUCCESS_SOAP_BODY_+0",GetID("Workshop"),
						Soaps)
			else
				-- not enough space
				MsgBoxNoWait("dynasty", "Workshop", "@L_MEASURE_MEDICINECHEST_OUTPUT_HEAD_+0",
						"@L_MEASURE_MEDICINECHEST_OUTPUT_FAIL_SOAP_BODY_+0",GetID("Workshop"),
						Soaps)
			end
		
		-- output miraclecure
		elseif result3 == 6 then
			if CanAddItems("Workshop","MiracleCure",MiracleCures, INVENTORY_STD) then -- check for space
				RemoveProperty("Workshop","MiracleCures")
				AddItems("Workshop","MiracleCure",MiracleCures, INVENTORY_STD)
				
				-- X units have been added to the stock
				MsgBoxNoWait("dynasty", "Workshop", "@L_MEASURE_MEDICINECHEST_OUTPUT_HEAD_+0",
						"@L_MEASURE_MEDICINECHEST_OUTPUT_SUCCESS_MIRACLECURE_BODY_+0",GetID("Workshop"),
						MiracleCures)
			else
				-- not enough space
				MsgBoxNoWait("dynasty", "Workshop", "@L_MEASURE_MEDICINECHEST_OUTPUT_HEAD_+0",
						"@L_MEASURE_MEDICINECHEST_OUTPUT_FAIL_MIRACLECURE_BODY_+0",GetID("Workshop"),
						MiracleCures)
			end
		end
	end
end