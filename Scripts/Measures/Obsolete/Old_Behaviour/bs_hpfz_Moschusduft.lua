function Run()
  if SimGetGender("Actor") == SimGetGender("") then
    if SimGetOfficeLevel("Actor") == SimGetOfficeLevel("") then
	    chr_ModifyFavor("","Actor",10)
	    if IsPartyMember("")  then
		    MsgNewsNoWait("","Actor","","intrigue",-1,
					"@L_HPFZ_ARTEFAKT_MOSCHUS_OPFER_KOPF_+0",
					"@L_HPFZ_ARTEFAKT_MOSCHUS_OPFER_RUMPF_+0", GetID(""), GetID("Actor"))
	    end
		end
	else
	  return ""
	end
end
