function Run()

	if GetImpactValue("","outlaw")>0 then
		chr_ModifyFavor("","Actor",-15)

		if SimGetProfession("")==GL_PROFESSION_CITYGUARD then
			if GetState("Actor",STATE_UNCONSCIOUS) and GetImpactValue("Actor", "REVOLT")==1 then
				MeasureRun("","Actor","Kill")
			else
				gameplayformulas_SimAttackWithRangeWeapon("", "Actor")
				BattleJoin("","Actor", true)
			end
		end
	end

	return ""
end

