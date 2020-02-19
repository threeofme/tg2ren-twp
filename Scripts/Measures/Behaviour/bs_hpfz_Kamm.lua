function Run()
	if SimGetOfficeLevel("") ~= -1 then
		chr_ModifyFavor("","Actor",10)
		if IsPartyMember("")  then
			MsgNewsNoWait("","Actor","","intrigue",-1,
					"@L_HPFZ_ARTEFAKT_KAMM_OPFER_KOPF_+0",
					"@L_HPFZ_ARTEFAKT_KAMM_OPFER_RUMPF_+0",GetID("Actor"))
		end
	else
		return ""
	end
end

