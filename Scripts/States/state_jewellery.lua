function Init()
end

function Run()
	if IsType("","Sim") then
		if GetImpactValue("","jewellery")==1 then
			CommitAction("jewellery","","")
			while GetImpactValue("","jewellery")>0 do
				Sleep(6)
			end
			StopAction("jewellery", "")
			SetState("",STATE_JEWELLERY,false)
			return
		end
	end
end


function CleanUp()
	
	SetState("Owner", STATE_JEWELLERY, false)
	RemoveProperty("Owner","jewellery")
	
end

