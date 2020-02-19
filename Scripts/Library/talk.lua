-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_talk"
----
----	Script functions library for talk situations
----
-------------------------------------------------------------------------------

-- -----------------------
-- Init
-- -----------------------
function Init()
 --needed for caching
end

-- -----------------------
-- ThreatCharacter
-- -----------------------
function ThreatCharacter(Rhetoric)

	local label = "@L_INTRIGUE_THREAT_CHARACTER"
	
	if (Rhetoric < 3) then
		label = label.."_WEAK_RHETORIC"
	elseif (Rhetoric < 6) then
		label = label.."_NORMAL_RHETORIC"
	else
		label = label.."_GOOD_RHETORIC"
	end
	
	return label
	
end

-- -----------------------
-- AskLiaison
-- -----------------------
function AskLiaison(Rhetoric, Gender)

	local label = "@L_LIAISON_QUESTION"
	
	if (Rhetoric < 3) then
		label = label.."_WEAK_RHETORIC"
	elseif (Rhetoric < 6) then
		label = label.."_NORMAL_RHETORIC"
	else
		label = label.."_GOOD_RHETORIC"
	end
	
	if (Gender == GL_GENDER_MALE) then
		label = label.."_TOFEMALE"
	else
		label = label.."_TOMALE"
	end
	
	return label
	
end

-- -----------------------
-- AnswerLiaison
-- -----------------------
function AnswerLiaison(Rhetoric, Gender)

	local label = "@L_COURTLOVER_BEGIN_ANSWER"

	if (Gender == GL_GENDER_MALE) then
		label = label.."_SUCCESS_MALE"
	else
		label = label.."_SUCCESS_FEMALE"
	end
	
	if (Rhetoric < 3) then
		label = label.."_WEAK_RHETORIC"
	elseif (Rhetoric < 6) then
		label = label.."_NORMAL_RHETORIC"
	else
		label = label.."_GOOD_RHETORIC"
	end
		
	return label
	
end

