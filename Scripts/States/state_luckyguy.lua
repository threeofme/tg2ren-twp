Include("Measures/ms_randomevents.lua")
function Init()
    SetStateImpact("no_attackable")
	AddImpact("","luckyguy",1,6)
	AddImpact("","empathy",2,6)
	AddImpact("","dexterity",2,6)
end

function Run()
    while GetImpactValue("","luckyguy")==1 do
		Sleep(Rand(10)+20)
		if Rand(4) == 3 then
			ms_randomevents_RandomEventPositiv()
		end
	end
end

function CleanUp()
  SetState("",58,false)
end
