function Init()

  if GetItemCount("",186,INVENTORY_STD)>0 then 	
    SetData("TalentPlus", 2)
  elseif GetItemCount("",190,INVENTORY_STD)>0 then
    SetData("TalentPlus", 1)
  else
    MsgQuick("","_HPFZ_LEHREN_FEHLER_+1")
    StopMeasure()
  end

  local result = InitData("@P@B[1,,@L_HPFZ_LEHREN_ANFRAGE_+1,Hud/Buttons/btn_kampf.tga]"..
    			  "@B[2,,@L_HPFZ_LEHREN_ANFRAGE_+2,Hud/Buttons/btn_philo.tga]"..
    			  "@B[3,,@L_HPFZ_LEHREN_ANFRAGE_+3,Hud/Buttons/btn_handwerk.tga]",
						"",
						"@L_HPFZ_LEHREN_ANFRAGE_+0")

	if result==1 then
		SetData("BonusTalent", 4)
	elseif result==2 then
		SetData("BonusTalent", 7)
	elseif result==3 then
		SetData("BonusTalent", 5)
	end

end 

function Run()

  local MaxDistance = 1500
  local ActionDistance = 130
  local MeasureID = GetCurrentMeasureID("")
  local TimeOut	= mdata_GetTimeOut(MeasureID)
  
  if not HasData("BonusTalent") then
      StopMeasure()
  end

  if not HasData("TalentPlus") then
      StopMeasure()
  end

  if not ai_StartInteraction("", "Destination", MaxDistance, ActionDistance, nil) then
      StopMeasure()
  end	
  
    SetMeasureRepeat(TimeOut)
	StopAnimation("Destination")
  AlignTo("Owner", "Destination")
  AlignTo("Destination", "Owner")
  MeasureSetNotRestartable()
  local DerSkill = GetData("BonusTalent")
	if DerSkill == 4 then
		ms_lehren_Fechtmeister()
	elseif DerSkill == 7 then
	  ms_lehren_Philosoph()
	elseif DerSkill == 5 then
	  ms_lehren_Handwerker()
	end
	chr_GainXP("",GetData("BaseXP"))

  StopMeasure()
end	

function Fechtmeister()

  local DieMenge = GetData("TalentPlus")
	
  if DieMenge == 2 then
  	RemoveItems("",186,1)
  elseif DieMenge == 1 then
    RemoveItems("",190,1)
  end	

  PlayAnimationNoWait("Destination","fight_draw_weapon")
  PlayAnimationNoWait("","fight_draw_weapon")
  Sleep(1)
  CarryObject("Destination","weapons/shortsword_01.nif",false)
  CarryObject("","weapons/sword_01.nif",false)
	
  local Runden = 6
  for aktion=0, Runden-1 do
    local treff = PlayAnimationNoWait("Destination","attack_middle")
    PlayAnimationNoWait("","block_middle_01")
	Sleep(0.5)
    PlaySound3DVariation("","Effects/combat_defence_metal_metal",1)
    Sleep(3)
  end
  local SkillHaben = GetSkillValue("Destination",4)
  local SkillNeu = SkillHaben + DieMenge
  SetSkillValue("Destination",4,SkillNeu)
	
  PlayAnimationNoWait("Destination","fight_store_weapon")
  PlayAnimationNoWait("","fight_store_weapon")
  Sleep(1.5)
  CarryObject("Destination","",false)
  CarryObject("","",false)

  GfxDetachAllObjects()
		GetPosition("Destination", "ParticleSpawnPos")
		StartSingleShotParticle("particles/sparkle_talents.nif", "ParticleSpawnPos",1,5)
		PlaySound3D("Destination","Effects/mystic_gift+0.wav", 1.0)
		--show overhead text
		feedback_OverheadSkill("Destination", "@L_ARTEFACTS_OVERHEAD_+0", false,
			"@L_TALENTS_fighting_ICON_+0", "@L_TALENTS_fighting_NAME_+0", DieMenge)
		Sleep(1)				
	
end

function Philosoph()

  local DieMenge = GetData("TalentPlus")

  if DieMenge == 2 then
  	RemoveItems("",186,1)
  elseif DieMenge == 1 then
    RemoveItems("",190,1)
  end		
	
  MoveSetActivity("Destination","carry")
  Sleep(0.5)
CarryObject("Destination","Handheld_Device/ANIM_bookpile.nif",false)
  Sleep(1)

  local Runden = 3
  for aktion=0, Runden-1 do
    local lesen = PlayAnimationNoWait("","use_book_standing")
    Sleep(1)
    CarryObject("","Handheld_Device/ANIM_book.nif",false)
    Sleep(lesen-2)
    CarryObject("","",false)
    local Spruch = Rand(4)
    if Spruch == 0 then
      MsgSay("Destination","_HPFZ_LEHREN_SPRUCH_+0")
    elseif Spruch == 1 then
      MsgSay("Destination","_HPFZ_LEHREN_SPRUCH_+1")
    elseif Spruch == 2 then
      MsgSay("Destination","_HPFZ_LEHREN_SPRUCH_+2")
		elseif Spruch == 3 then
	    MsgSay("Destination","_HPFZ_LEHREN_SPRUCH_+3")
    end
    PlayAnimation("","preach")
    Sleep(1)
  end
  local SkillHaben = GetSkillValue("Destination",7)
  local SkillNeu = SkillHaben + DieMenge
  SetSkillValue("Destination",7,SkillNeu)
  MoveSetActivity("Destination","")
  Sleep(0.5)
  CarryObject("Destination","",false)
 
  GfxDetachAllObjects()
		GetPosition("Destination", "ParticleSpawnPos")
		StartSingleShotParticle("particles/sparkle_talents.nif", "ParticleSpawnPos",1,5)
		PlaySound3D("Destination","Effects/mystic_gift+0.wav", 1.0)
		--show overhead text
		feedback_OverheadSkill("Destination", "@L_ARTEFACTS_OVERHEAD_+0", false,
			"@L_TALENTS_rhetoric_ICON_+0", "@L_TALENTS_rhetoric_NAME_+0", DieMenge)
		Sleep(1)
		
end

function Handwerker()

  local fart
  local DieMenge = GetData("TalentPlus")
	    GetPosition("","MovePos")
	    GfxAttachObject("kasten", "city/Stuff/ToolcaseSpec.nif")
	    GfxSetPositionTo("kasten", "MovePos")

  if DieMenge == 2 then
    RemoveItems("",186,1)
  elseif DieMenge == 1 then
    RemoveItems("",190,1)
  end			  

  fart = PlayAnimationNoWait("","use_object_standing")
  Sleep(0.5)
  CarryObject("","Handheld_Device/ANIM_Chisel.nif",false)
  Sleep(fart)
 
  fart = PlayAnimationNoWait("Destination","manipulate_middle_low_r")
  Sleep(0.5)
  CarryObject("Destination","Handheld_Device/ANIM_Chisel.nif",false)
  Sleep(fart)
  local Spruch = Rand(4)
  if Spruch == 0 then
      MsgSay("Destination","_HPFZ_LEHREN_SPRUCH_+0")
  elseif Spruch == 1 then
      MsgSay("Destination","_HPFZ_LEHREN_SPRUCH_+4")
  elseif Spruch == 2 then
      MsgSay("Destination","_HPFZ_LEHREN_SPRUCH_+5")
	elseif Spruch == 3 then
	    MsgSay("Destination","_HPFZ_LEHREN_SPRUCH_+6")
  end

    CarryObject("","",false)  
  fart = PlayAnimationNoWait("","use_object_standing")
  Sleep(0.5)
  CarryObject("","Handheld_Device/ANIM_File.nif",false)
  Sleep(fart)

    CarryObject("Destination","",false)
  fart = PlayAnimationNoWait("Destination","manipulate_middle_low_r")
  Sleep(0.5)
  CarryObject("Destination","Handheld_Device/ANIM_File.nif",false)
  Sleep(fart)

    CarryObject("","",false)  
  fart = PlayAnimationNoWait("","use_object_standing")
  Sleep(0.5)
  CarryObject("","Handheld_Device/Anim_Hammer.nif",false)
  Sleep(fart)

    CarryObject("Destination","",false)
  fart = PlayAnimationNoWait("Destination","manipulate_middle_low_r")
  Sleep(0.5)
  CarryObject("Destination","Handheld_Device/Anim_Hammer.nif",false)
  Sleep(fart)
  local Spruch = Rand(4)
  if Spruch == 0 then
      MsgSay("Destination","_HPFZ_LEHREN_SPRUCH_+7")
  elseif Spruch == 1 then
      MsgSay("Destination","_HPFZ_LEHREN_SPRUCH_+8")
  elseif Spruch == 2 then
      MsgSay("Destination","_HPFZ_LEHREN_SPRUCH_+9")
	elseif Spruch == 3 then
	    MsgSay("Destination","_HPFZ_LEHREN_SPRUCH_+0")
  end

    CarryObject("","",false)  
  fart = PlayAnimationNoWait("","use_object_standing")
  Sleep(0.5)
  CarryObject("","Handheld_Device/ANIM_Planer.nif",false)
  Sleep(fart)

    CarryObject("Destination","",false) 
  fart = PlayAnimationNoWait("Destination","manipulate_middle_low_r")
  Sleep(0.5)
  CarryObject("Destination","Handheld_Device/ANIM_Planer.nif",false)
  Sleep(fart)

  local SkillHaben = GetSkillValue("Destination",5)
  local SkillNeu = SkillHaben + DieMenge
  SetSkillValue("Destination",5,SkillNeu)

	GfxDetachAllObjects()
		GetPosition("Destination", "ParticleSpawnPos")
		StartSingleShotParticle("particles/sparkle_talents.nif", "ParticleSpawnPos",1,5)
		PlaySound3D("Destination","Effects/mystic_gift+0.wav", 1.0)
		--show overhead text
		feedback_OverheadSkill("Destination", "@L_ARTEFACTS_OVERHEAD_+0", false,
			"@L_TALENTS_craftsmanship_ICON_+0", "@L_TALENTS_craftsmanship_NAME_+0", DieMenge)
		Sleep(1)
	
end

function CleanUp()
    CarryObject("Destination","",false)
    CarryObject("","",false)
	StopAnimation("")
	StopAnimation("Destination")
	GfxDetachAllObjects()
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end