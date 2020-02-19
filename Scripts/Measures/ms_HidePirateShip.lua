function Run()
	if GetState("", STATE_HIDDEN) then
		SetState("",STATE_HIDDEN,false)
		--RemoveAllImpactDependendImpacts("",6666)
	else
		SetState("",STATE_HIDDEN,true)
		-- Move speed mod
		--AddImpactDependendImpact("",6666,"MoveSpeed",0.6,-1)
	end
end

