function Run()

	GetFleePosition("Owner", "Actor", Rand(50)+200, "Away")
	f_MoveTo("Owner", "Away", GL_MOVESPEED_WALK)
	AlignTo("Owner", "Actor")
	Sleep(1)

	SetRepeatTimer("Owner", "Sim2Betrugen", 16)

  if (GetSkillValue("Actor",6) > GetSkillValue("Owner",8)) then
	  local freude = PlayAnimationNoWait("Owner","use_book_standing")
	  Sleep(1)
	  CarryObject("Owner", "Handheld_Device/ANIM_openscroll.nif", false)
	  Sleep(freude-2)
	  PlayAnimationNoWait("Owner","cheer_01")
	  
	  local Fasel = Rand(4)
	  if Fasel == 0 then
	  	MsgSay("Owner","_HPFZ_BEHAVIOUR_BETRUGEN_SPRUCH_+0")
	  elseif Fasel == 1 then
	    MsgSay("Owner","_HPFZ_BEHAVIOUR_BETRUGEN_SPRUCH_+1")
	  elseif Fasel == 2 then
	    MsgSay("Owner","_HPFZ_BEHAVIOUR_BETRUGEN_SPRUCH_+2")
	  else
	    MsgSay("Owner","_HPFZ_BEHAVIOUR_BETRUGEN_SPRUCH_+3")
	  end

    if SimGetGender("Owner") == 1 then
      PlaySound3D("Owner","CharacterFX/male_joy_loop/male_joy_loop+2.ogg", 1.0)
    else
      PlaySound3D("Owner","CharacterFX/female_joy_loop/female_joy_loop+3.ogg", 1.0)
    end
    Sleep(3)
    CarryObject("Owner", "", false)
				
		local basePrice = ItemGetBasePrice("Urkunde")
    local Geld = GetSkillValue("Actor",9)
    local Betrug = 0
    if SimGetRank("Owner")==1 then
	    Betrug = basePrice + (5*Geld)
    elseif SimGetRank("Owner")==2 then
	    Betrug = basePrice + (10*Geld)
    elseif SimGetRank("Owner")==3 then
			Betrug = basePrice + (15*Geld)
    elseif SimGetRank("Owner")==4 then
			Betrug = basePrice + (20*Geld)
    elseif SimGetRank("Owner")==5 then
			Betrug = basePrice + (25*Geld)
    end

    if RemoveItems("Actor", "Urkunde", 1, INVENTORY_STD) > 0 then
      f_CreditMoney("Actor",Betrug,"Offering")
	    IncrementXPQuiet("Actor",10)
      ShowOverheadSymbol("Actor",false,true,0,"%1t",Betrug)
      if IsDynastySim("Owner") then
	      f_SpendMoney("Owner",Betrug,"Offering")
      end
		end
                
  else
    GetPosition("Actor","Betruger")
    CarryObject("Owner","Handheld_Device/ANIM_carrot.nif",false)
    Sleep(1)
    PlayAnimationNoWait("Owner","throw")
    Sleep(1.8)
    CarryObject("Owner","",false)
    local fDuration = ThrowObject("Owner","Betruger","Handheld_Device/ANIM_carrot.nif",0.1,"veg",0,150,0)
    Sleep(fDuration)
    GetPosition("Betruger","ParticleSpawnPos")
    StartSingleShotParticle("particles/veg.nif","ParticleSpawnPos",1,5)
    Sleep(0.7)
    
    if SimGetGender("Owner")==GL_GENDER_MALE then
        PlaySound3DVariation("Owner","CharacterFX/male_anger",1)
    else
        PlaySound3DVariation("Owner","CharacterFX/female_anger",1)
    end
    
    local Fasel = Rand(4)
    if Fasel == 0 then
    	MsgSay("Owner","_HPFZ_BEHAVIOUR_BETRUGEN_SPRUCH_+4")
    elseif Fasel == 1 then
      MsgSay("Owner","_HPFZ_BEHAVIOUR_BETRUGEN_SPRUCH_+5")
    elseif Fasel == 2 then
      MsgSay("Owner","_HPFZ_BEHAVIOUR_BETRUGEN_SPRUCH_+6")
    else
      MsgSay("Owner","_HPFZ_BEHAVIOUR_BETRUGEN_SPRUCH_+7")
    end
    PlayAnimation("Owner","propel")
    chr_ModifyFavor("Owner","Actor",-20)
  end

  Sleep(2.0)
	
end
