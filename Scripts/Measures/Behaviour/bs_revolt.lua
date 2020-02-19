function Run()

	if GetImpactValue("Actor","revolt")>0 then
		chr_ModifyFavor("","Actor",-15)

		if SimGetProfession("")==GL_PROFESSION_CITYGUARD then
			if GetState("Actor",STATE_UNCONSCIOUS) and GetImpactValue("Actor", "REVOLT")>0 then
				MeasureRun("","Actor","Kill")
			else
				gameplayformulas_SimAttackWithRangeWeapon("", "Actor")
				BattleJoin("","Actor", true)
			end
		end
	end

	return ""
end

