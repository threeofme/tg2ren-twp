function Run()

  if ReadyToRepeat("", "Sim4Statue") then

    SetRepeatTimer("Owner", "Sim4Statue", 16)
    local statLvl = BuildingGetLevel("Actor")
		BuildingGetOwner("Actor","Mich")
    if SimGetOfficeID("") >= 0 then
    	bs_hpfz_statue_AmtsUrteil(statLvl,"Mich")
    else
      bs_hpfz_statue_BuergerUrteil(statLvl,"Mich")
    end

    if GetFavorToSim("","Actor") < 11 or GetFavorToSim("","Actor") > 79 then
	    if GetImpactValue("","spying") ~= 1 then
		    if GetState("",STATE_ROBBERGUARD)==false then
			    if IsPartyMember("")==false then
				    if GetState("",STATE_WORKING)==false then
					    return "StatueBewert"
						end
					end
				end
			end
		end
		    
	end

end

function AmtsUrteil(stLvl,dy)

  if stLvl == 1 then
  	if SimGetOfficeID("") == 15 or SimGetOfficeID("") == 14 or SimGetOfficeID("") == 13 then
    	chr_ModifyFavor("",dy,10)
			return 2
    else
	    return 1
		end
	elseif stLvl == 2 then
  	if SimGetOfficeID("") == 24 or SimGetOfficeID("") == 23 or SimGetOfficeID("") == 22 then
    	chr_ModifyFavor("",dy,10)
			return 2
    else
	    return 1
		end
	elseif stLvl == 3 then
    if SimGetOfficeID("") == 33 or SimGetOfficeID("") == 32 or SimGetOfficeID("") == 31 then
      chr_ModifyFavor("",dy,10)
			return 2
    else
	    return 1
		end
	end

end

function BuergerUrteil(stLvl,dy)

  if stLvl == 1 then
    if SimGetRank("") == 1 then
	    chr_ModifyFavor("",dy,-5)
		end
		if SimGetRank("") == 3 then
	    chr_ModifyFavor("",dy,5)
		end
	elseif stLvl == 2 then
    if SimGetRank("") == 1 then
	    chr_ModifyFavor("",dy,-5)
		end
    if SimGetRank("") == 2 then
	    chr_ModifyFavor("",dy,-5)
		end
    if SimGetRank("") == 3 then
	    chr_ModifyFavor("",dy,5)
		end
    if SimGetRank("") == 4 then
	    chr_ModifyFavor("",dy,5)
		end
	elseif stLvl == 3 then
    if SimGetRank("") == 2 then
	    chr_ModifyFavor("",dy,-10)
		end
    if SimGetRank("") == 4 then
	    chr_ModifyFavor("",dy,5)
		end
    if SimGetRank("") == 5 then
	    chr_ModifyFavor("",dy,5)
		end
	end

end
