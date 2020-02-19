function Init()
 --needed for caching
end

function Round(fValue)
	local	IntVal = math.floor(fValue)
	local	RandVal = (fValue - IntVal)*100
	if RandVal > 0 then
		if Rand(100) < RandVal then
			IntVal = IntVal + 1
		end
	end
	return IntVal
end

function CalcAttack(fWeaponDamage)
	local AttackValue	= GetSkillValue("",FIGHTING)
	local Damage	= gameplayformulas_CalcDamage(fWeaponDamage) --fWeaponDamage + (SimGetLevel("") + AttackValue)*0.5
	local CritChance	= 2*GetSkillValue("", SHADOW_ARTS)
	CritChance		= CritChance + GetImpactValue("", "FightCrit")
	if Rand(100) < CritChance then
		Damage = anims_fight_sim_Round(Damage * 1.5)
	end
	SetData("FCAttackValue", AttackValue)
	SetData("FCAttackDamage", Damage)
end

function CalcDefend(a_fAttackValue, a_fDamage)
	local bDefenseResult = 0
	local Damage				= a_fDamage
	local fDefenseValue = GetSkillValue("",DEXTERITY)
	
	local	ToHit	= 73 + ( a_fAttackValue - fDefenseValue)*3
	
	if Rand(100) > ToHit then
		Damage = 0
		bDefenseResult = 1
	end
	
	SetData("FCDefenseResult", bDefenseResult)
	SetData("FCDefenseDamage", Damage)
end

function ModifyDamage(fDamage)

	local ModDamage = fDamage;
	if ModDamage>0 then
		local	Armor 	= gameplayformulas_CalcArmorValue() --GetArmor("") + GetImpactValue("", "FightArmor")
		if Armor~= 0 then
			ModDamage	= anims_fight_sim_Round(ModDamage - ModDamage * Armor * 0.01)
			if ModDamage<1 then
				ModDamage = 1
			end
		end
	end
	SetData("FCModDamage", ModDamage)
end

function AttackArmed(fWeaponDamage)

	local Anim = Rand(6)+1

	local	AnimName
	if (Anim == 1) then
		AnimName = "attack_top"
	elseif (Anim == 2) then
		AnimName = "attack_top2"
	elseif (Anim == 3) then
		AnimName = "attack_middle"
	elseif (Anim == 4) then
		AnimName = "attack_middle2"
	elseif (Anim == 5) then
		AnimName = "attack_bottom"
	elseif (Anim == 6) then
		AnimName = "attack_bottom2"
	end
	local AnimTime = PlayAnimationNoWait("", AnimName)
	if (AnimTime > 0) then
		SetData("FCAttackAnim", Anim)
		SetData("FCAttackLenght", AnimTime)
	
		anims_fight_sim_CalcAttack(fWeaponDamage)
	end
end

function AttackArmedVisual(SoundType)
	-- sword slash sound?
end

function AttackUnarmed(fWeaponDamage)

	local Anim = Rand(6)+1

	local	AnimName
	if (Anim == 1) then
		AnimName = "fistfight_punch_01"
	elseif (Anim == 2) then
		AnimName = "fistfight_punch_02"
	elseif (Anim == 3) then
		AnimName = "fistfight_punch_03"
	elseif (Anim == 4) then
		AnimName = "fistfight_punch_04"
	elseif (Anim == 5) then
		AnimName = "fistfight_punch_05"
	elseif (Anim == 6) then
		AnimName = "fistfight_punch_06"
	elseif (Anim == 7) then
		AnimName = "fistfight_punch_07"
	elseif (Anim == 8) then
		AnimName = "fistfight_punch_08"
	end
	local AnimTime = PlayAnimationNoWait("", AnimName)
	if (AnimTime > 0) then
		SetData("FCAttackAnim", Anim)
		SetData("FCAttackLenght", AnimTime)
	
		anims_fight_sim_CalcAttack(fWeaponDamage)
	end
end

function AttackUnarmedVisual(SoundType)
	-- fist swing sound?
end

-- bool (armed unarmed)
function DrawWeapon(unarmed)
	if (unarmed == 1) then
		PlayAnimationNoWait("", "fistfight_in")
	elseif (unarmed == 0) then
		PlayAnimationNoWait("", "fight_draw_weapon")
	end
end

function DrawWeaponVisual(unarmed)
	Sleep(0.68)
	if (unarmed == 0) then
		PlaySound3DVariation("","Effects/combat_draw_weapon",1)	
		local weaponname = BattleGetWeaponName("")
		CarryObject("", weaponname ,false)	
	end
end

function UndrawWeapon(unarmed)
	if (unarmed == 1) then
		PlayAnimationNoWait("", "fistfight_out")
	elseif (unarmed == 0) then
		PlayAnimationNoWait("", "fight_store_weapon")
	end
end

function UndrawWeaponVisual(unarmed)
	Sleep(1.92)
	if unarmed==0 then
		if not GetState("",STATE_FIGHTING) then
			PlaySound3DVariation("","Effects/combat_sheath_weapon",1)
			CarryObject("", "" ,false)
		end
	end	
end

function PlayDefendAnim(AnimName, AttackLen)
	if not AttackLen or AttackLen<=0 then
		AttackLen = 1.5
	end
	
	local DefendLen = GetAnimationLength("", AnimName)
	if not DefendLen or DefendLen<=0 then
		DefendLen = AttackLen
	end
	local 	Speed = DefendLen / AttackLen
	local AnimTime = PlayAnimationNoWait("", AnimName, 0, Speed)
	return
end

function HitUnarmed(ByAnim, AttackLenght)
	local	AnimName
	if (ByAnim < 1) then
		ByAnim = Rand(8)+1
	end

	if (ByAnim == 1) then
		AnimName = "fistfight_got_hit_01"
	elseif (ByAnim == 2) then
		AnimName = "fistfight_got_hit_01"
	elseif (ByAnim == 3) then
		AnimName = "fistfight_got_hit_01"
	elseif (ByAnim == 4) then
		AnimName = "fistfight_got_hit_01"
	elseif (ByAnim == 5) then
		AnimName = "fistfight_got_hit_03"
	elseif (ByAnim == 6) then
		AnimName = "fistfight_got_hit_02"
	elseif (ByAnim == 7) then
		AnimName = "fistfight_got_hit_04"
	elseif (ByAnim == 8) then
		AnimName = "fistfight_got_hit_05"
	end
	anims_fight_sim_PlayDefendAnim(AnimName, AttackLenght)
end

function HitUnarmedVisual(SoundType, Damage)
	Sleep(0.6)
	--ShowOverheadSymbol("", false, true, 0, "@L_GENERAL_OVERHEADSYMBOL_HP_DEC_+0", Damage)
	if GetPositionOfSubobject("", "Game_Chest_Scale", "Game_Chest_Scale") then
		StartSingleShotParticle("particles/bloodsplash.nif", "Game_Chest_Scale", 0.5, 3.0)
		if (SoundType == GL_FIGHT_HIT_TYPE_UNARMED) then
			PlaySound3DVariation("", "Effects/combat_strike_fist", 1)
		elseif (SoundType == GL_FIGHT_HIT_TYPE_SHARP) then
			PlaySound3DVariation("","Effects/combat_strike_metal",1)
		elseif (SoundType == GL_FIGHT_HIT_TYPE_BLUNT) then
			PlaySound3DVariation("","Effects/combat_strike_mace",1)
		elseif (SoundType == GL_FIGHT_HIT_TYPE_PROJECTILE) then
			PlaySound3DVariation("","Effects/combat_arrow_strike",1)
		end
	end
	
	if SimGetGender("") == GL_GENDER_MALE then
		PlaySound3DVariation("", "CharacterFX/male_pain_short", 1)
	else
		PlaySound3DVariation("", "CharacterFX/female_pain_short", 1)
	end
	
end


function HitArmed(ByAnim, AttackLenght)

	local	AnimName
	if (ByAnim < 1) then
		ByAnim = Rand(8)+1
	end

	if (ByAnim == 1) then
		AnimName = "fight_got_hit_01"
	elseif (ByAnim == 2) then
		AnimName = "fight_got_hit_02"
	elseif (ByAnim == 3) then
		AnimName = "fight_got_hit_03"
	elseif (ByAnim == 4) then
		AnimName = "fight_got_hit_04"
	elseif (ByAnim == 5) then
		AnimName = "fight_got_hit_05"
	elseif (ByAnim == 6) then
		AnimName = "fight_got_hit_06"
	elseif (ByAnim == 7) then
		AnimName = "fight_got_hit_04"
	elseif (ByAnim == 8) then
		AnimName = "fight_got_hit_05"
	end
	anims_fight_sim_PlayDefendAnim(AnimName, AttackLenght)
	return 0
end

function HitArmedVisual(SoundType, Damage)
	Sleep(0.6)
	--ShowOverheadSymbol("", false, true, 0, "@L_GENERAL_OVERHEADSYMBOL_HP_DEC_+0", Damage)
	if GetPositionOfSubobject("", "Game_Chest_Scale", "Game_Chest_Scale") then
		StartSingleShotParticle("particles/bloodsplash.nif", "Game_Chest_Scale", 0.5, 3.0)
		if (SoundType == GL_FIGHT_HIT_TYPE_UNARMED) then
			PlaySound3DVariation("","Effects/combat_strike_fist",1)
		elseif (SoundType == GL_FIGHT_HIT_TYPE_SHARP) then
			PlaySound3DVariation("","Effects/combat_strike_metal",1)
		elseif (SoundType == GL_FIGHT_HIT_TYPE_BLUNT) then
			PlaySound3DVariation("","Effects/combat_strike_mace",1)
		elseif (SoundType == GL_FIGHT_HIT_TYPE_PROJECTILE) then
			PlaySound3DVariation("","Effects/combat_arrow_strike",1)
		end
	end
	
	if SimGetGender("") == GL_GENDER_MALE then
		PlaySound3DVariation("", "CharacterFX/male_pain_short", 1)
	else
		PlaySound3DVariation("", "CharacterFX/female_pain_short", 1)
	end
	
end

function BlockUnarmed(a_AttackAnim, a_fAttackValue, a_fDamage, AttackLenght)

	anims_fight_sim_CalcDefend(a_fAttackValue, a_fDamage)
	
	-- run anims if really blocked)
	if (bDefenseResult == 1) then
		local	AnimName
		if (a_AttackAnim == 1) then
			AnimName = "fistfight_block_01"
		elseif (a_AttackAnim == 2) then
			AnimName = "fistfight_block_02"
		elseif (a_AttackAnim == 3) then
			AnimName = "fistfight_block_03"
		elseif (a_AttackAnim == 4) then
			AnimName = "fistfight_dodge_01"
		elseif (a_AttackAnim == 5) then
			AnimName = "fistfight_dodge_02"
		elseif (a_AttackAnim == 6) then
			AnimName = "fistfight_block_01"
		elseif (a_AttackAnim == 7) then
			AnimName = "fistfight_dodge_01"
		elseif (a_AttackAnim == 8) then
			AnimName = "fistfight_dodge_02"
		end
		anims_fight_sim_PlayDefendAnim(AnimName, AttackLenght)
	end
end

function BlockUnarmedVisual(SoundType, OwnSoundType)
	--feedback_OverheadFadeText("", "Abgewehrt", false)
	Sleep(0.6)
	if GetPositionOfSubobject("", "Game_Chest_Scale", "Game_Chest_Scale") then
		StartSingleShotParticle("particles/sparks.nif", "Game_Chest_Scale", 0.5, 3.0)
		--block sounds from unarmed to the different weapon types?
		PlaySound3DVariation("","Effects/combat_strike_mace",1)
	end
end

function BlockArmed(a_AttackAnim, a_fAttackValue, a_fDamage, AttackLenght)

	anims_fight_sim_CalcDefend(a_fAttackValue, a_fDamage)
	
	-- run anims if really blocked)
	if (bDefenseResult == 1) then
	
		local	AnimName
		if (a_AttackAnim == 1) then
			AnimName = "block_top_01"
		elseif (a_AttackAnim == 2) then
			AnimName = "block_top_02"
		elseif (a_AttackAnim == 3) then
			AnimName = "block_middle_01"
		elseif (a_AttackAnim == 4) then
			AnimName = "block_middle_02"
		elseif (a_AttackAnim == 5) then
			AnimName = "block_bottom_01"
		elseif (a_AttackAnim == 6) then
			AnimName = "block_bottom_02"
		end
		anims_fight_sim_PlayDefendAnim(AnimName, AttackLenght)
	end
end

function BlockArmedVisual(AttackerSoundType, OwnSoundType)
	--feedback_OverheadFadeText("", "Abgewehrt", false)
	Sleep(0.6)
	if GetPositionOfSubobject("", "Game_Chest_Scale", "Game_Chest_Scale") then
		StartSingleShotParticle("particles/sparks.nif", "Game_Chest_Scale", 0.5, 3.0)
		if (AttackerSoundType == GL_FIGHT_HIT_TYPE_UNARMED) then
			PlaySound3DVariation("","Effects/combat_strike_fist",1)
		elseif (AttackerSoundType == GL_FIGHT_HIT_TYPE_SHARP) then
			if (OwnSoundType == GL_FIGHT_HIT_TYPE_SHARP) then
				PlaySound3DVariation("","Effects/combat_defence_metal_metal",1)
			elseif (OwnSoundType == GL_FIGHT_HIT_TYPE_BLUNT) then
				PlaySound3DVariation("","Effects/combat_defence_metal_mace",1)		
			end
		elseif (AttackerSoundType == GL_FIGHT_HIT_TYPE_BLUNT) then
			if (OwnSoundType == GL_FIGHT_HIT_TYPE_SHARP) then
				PlaySound3DVariation("","Effects/combat_defence_metal_mace",1)
			elseif (OwnSoundType == GL_FIGHT_HIT_TYPE_BLUNT) then
				PlaySound3DVariation("","Effects/combat_defence_mace_mace",1)		
			end
		end	
	end
end


function Miss(ByAnim)

end


			
