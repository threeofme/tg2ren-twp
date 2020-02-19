function Run()

	GetFleePosition("Owner", "Actor", Rand(50)+205, "Away")
	f_MoveTo("Owner", "Away", GL_MOVESPEED_WALK)
	AlignTo("Owner", "Actor")
	Sleep(1)

	SetRepeatTimer("Owner", "Ausschenken", 10)
	
		if Rand(2) == 1 then
			if SimGetGender("")==GL_GENDER_MALE then
				PlaySound3DVariation("","CharacterFX/male_cheer",1)
			else
				PlaySound3DVariation("","CharacterFX/female_cheer",1)
			end
				PlayAnimation("Owner", "cheer_01")
		else
			PlayAnimation("Owner", "cheer_02")
		end
		
		behavior_hpfz_simausschenken_HandelStuff()
		
		local drink
		if Rand(2) == 0 then
            drink = PlayAnimationNoWait("Owner","use_potion_standing")
            Sleep(1)
	        CarryObject("Owner", "Handheld_Device/ANIM_beaker.nif", false)
            PlaySound3D("","CharacterFX/drinking/drinking+2.ogg",1.0)
	        Sleep(drink-2)
	        CarryObject("Owner", "", false)
        else
			drink = PlayAnimationNoWait("","clink_glasses")
			Sleep(1)
			CarryObject("","Handheld_Device/ANIM_beaker.nif",false)
			Sleep(drink-2)
			PlaySound3DVariation("","CharacterFX/male_belch",1)
			CarryObject("","",false)
		end

    Sleep(2.0)
end

function HandelStuff()

  local Gewinn = 0
  if SimGetRank("Owner")==1 then
		Gewinn = Rand(5) + 1
  elseif SimGetRank("Owner")==2 then
		Gewinn = Rand(5) + 5
  elseif SimGetRank("Owner")==3 then
		Gewinn = Rand(10) + 5
  elseif SimGetRank("Owner")==4 then
		Gewinn = Rand(10) + 10
  elseif SimGetRank("Owner")==5 then
		Gewinn = Rand(15) + 15
  end
  
  local Feilschen = GetSkillValue("Actor",9)
	local Getrank = {"WheatBeer","SmallBeer"}
	local Lager, try, Eingenommen
	local Rfolge = {}
		Rfolge[1] = {1,2}
		Rfolge[2] = {2,1}
	local zFall = (Rand(2)+1)
	local w = 0
				
  if GetItemCount("Actor", "WheatBeer")>0 or GetItemCount("Actor", "SmallBeer")>0 then
		repeat
			w = w + 1
			try = Rfolge[zFall][w]
			Lager = Getrank[try]
			if w == 3 then
				break
			end
		until GetItemCount("Actor", Lager)>0
		
		local GPreis = ItemGetBasePrice(Lager)
		Eingenommen = GPreis + (Gewinn * Feilschen)
		SimGetWorkingPlace("Actor", "Workingplace")
		if AliasExists("Workingplace") then
			f_CreditMoney("Workingplace",Eingenommen,"Offering")
			economy_UpdateBalance("Workingplace", Eingenommen, "Service")
		else
			f_CreditMoney("Actor",Eingenommen,"Offering")
		end
		IncrementXPQuiet("Actor",5)
		ShowOverheadSymbol("Actor",false,true,0,"%1t",Eingenommen)
		SatisfyNeed("Owner", 6, -0.5)
    	RemoveItems("Actor", Lager, 1)
	end

end
