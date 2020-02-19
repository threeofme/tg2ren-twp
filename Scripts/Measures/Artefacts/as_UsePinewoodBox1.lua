-------------------------------------------------------------------------------
----
----	OVERVIEW "as_UsePinewoodBox1"
----
-------------------------------------------------------------------------------

function Run()

	local random = Rand(6) + 5
	local Object = "PinewoodBox1"
	local RawMaterial = "Pinewood"
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
		RemoveItems("",Object,1)
		if GetRemainingInventorySpace("",RawMaterial) < random then
			MsgQuick("", "@L_UNPACK_RAWMATERIAL_FAILURE_+0", ObjectLabel)
			AddItems("",Object,1)
			StopMeasure()
		else
			AddItems("",RawMaterial,random)
		end
	end
end


function CleanUp()
end
