-------------------------------------------------------------------------------
----
----	OVERVIEW "as_UseArmorsBox3"
----
-------------------------------------------------------------------------------

function Run()

	local random = Rand(2) + 2
	local Object = "ArmorsBox3"

	local RawMaterial = { 
			"Chainmail", "Platemail"
			}

	local	itemcount = 1
	while RawMaterial[itemcount] do
		itemcount = itemcount + 1
	end

	local ObjectLabel = ItemGetLabel(Object, true)
	local choice

	if AiDriven then
		choice = 0
	else
		choice = MsgBox("", "", "@P@B[0,@LJa_+0]"..
							"@B[1,@LNein_+0]",
							"@L_UNPACK_RAWMATERIAL_HEAD_+0",
							"@L_UNPACK_RAWMATERIAL_TEXT_+0",
							ObjectLabel, GetID(""))
	end

	if choice == 0 then
		local numobjects = Rand(itemcount)+1
		RemoveItems("",Object,1)
		if GetRemainingInventorySpace("",RawMaterial[numobjects]) < random then
			MsgQuick("", "@L_UNPACK_RAWMATERIAL_FAILURE_+0", ObjectLabel)
			AddItems("",Object,1)
			StopMeasure()
		else
			AddItems("",RawMaterial[numobjects],random)
		end
	end
end


function CleanUp()
end
