function Run()
  if SimGetOfficeLevel("") == 3 or SimGetOfficeLevel("") == 4 or SimGetOfficeLevel("") == 5 then
		chr_ModifyFavor("","Actor",8)
		if IsPartyMember("")  then
			MsgNewsNoWait("","Actor","","intrigue",-1,
					"@L_HPFZ_ARTEFAKT_SCHAERPE_OPFER_KOPF_+0",
					"@L_HPFZ_ARTEFAKT_SCHAERPE_OPFER_RUMPF_+0", GetID("Actor"))
		end
	else
	  return ""
	end
end

