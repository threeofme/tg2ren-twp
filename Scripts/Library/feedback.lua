-- -----------------------
-- Init
-- -----------------------
function Init()
 --needed for caching
end


-- -----------------------
-- ShowOverheadSymbol
-- -----------------------
function OverheadPercent(ObjectAlias, Number)
	-- shows fading percents

	ShowOverheadSymbol(ObjectAlias, false, false, 0, "@L$C[51,102,255]%1i%%",Number)

end 

-- -------------
-- OverheadMoney
-- -------------
function OverheadMoney(ObjectAlias, Number)
	-- shows fading money

	ShowOverheadSymbol(ObjectAlias, false, false, 0, "@L%1t",Number)

end

-- -------------
-- OverheadFame
-- -------------
function OverheadFame(ObjectAlias, Number)
	-- shows fading fame
	ShowOverheadSymbol(ObjectAlias, false, false, 0, "@L_GUILDHOUSE_FAME_+0",Number)

end

-- ---------------
-- OverheadImpFame
-- ---------------
function OverheadImpFame(ObjectAlias, Number)
	-- shows fading fame
	ShowOverheadSymbol(ObjectAlias, false, false, 0, "@L_IMPERIAL_FAME_+0",Number)

end

-- ---------------------
-- OverheadCourtProgress
-- ---------------------
function OverheadCourtProgress(ObjectAlias, Progress)

	-- shows fading (possibly broken) heart
	if (Progress>0) then
		ShowOverheadSymbol(ObjectAlias, false, true, 0, "@L$S[2001] +%1i", Progress)
	else
		ShowOverheadSymbol(ObjectAlias, false, true, 0, "@L$S[2012] %1i", Progress)
	end

end

function OverheadActionName(ObjectAlias, ActionName, Force, Replacement)
	-- the overhead is shown permanent
	-- Force: true = show overhead symbol global, false = show overhead symbol only for the dynasty
	-- Replacement: e.g. character name, building name, item name, time, counter, etc.

	if ActionName then
		if Replacement then
			ShowOverheadSymbol(ObjectAlias, true, Force, 0, ActionName, Replacement)
		else
		ShowOverheadSymbol(ObjectAlias, true, Force, 0, ActionName)
		end
	else
		RemoveOverheadSymbols(ObjectAlias)
	end

end

function OverheadComment(ObjectAlias, Comment, NoFade, Force, Replacement1, Replacement2)
	-- NoFade: true = the overhead is shown permanent, false = the overhead is fading out
	-- Force: true = show overhead symbol global, false = show overhead symbol only for the dynasty
	-- Replacement: e.g. character name, building name, item name, time, counter, etc.

	if Comment then
		ShowOverheadSymbol(ObjectAlias, NoFade, Force, 0, Comment, Replacement1, Replacement2)
	else
		RemoveOverheadSymbols(ObjectAlias)
	end

end

function OverheadSkill(ObjectAlias, Skill, Force, Replacement1, Replacement2, Replacement3)
	-- NoFade: true = the overhead is shown permanent, false = the overhead is fading out
	-- Force: true = show overhead symbol global, false = show overhead symbol only for the dynasty
	-- Replacement: e.g. character name, building name, item name, time, counter, etc.
	if Skill then
		ShowOverheadSymbol(ObjectAlias, false, Force, 0, Skill, Replacement1, Replacement2, Replacement3)
	else
		RemoveOverheadSymbols(ObjectAlias)
	end

end

function OverheadFadeText(ObjectAlias, FadeText, Force, Replacement)
	-- Force: true = show overhead symbol global, false = show overhead symbol only for the dynasty
	-- Replacement: e.g. character name, building name, item name, time, counter, etc.

	ShowOverheadSymbol(ObjectAlias, false, Force, 0, FadeText, Replacement)
end


-- -----------------------
-- MsgNews
-- -----------------------
function MessageWorkshop(Owner, Headline, Text, ...)

	local HeaderText = Headline
	local MessageClass = "building"

	-- copies variable parameters to c	
	-- attention - GetVariableParameters works only with special function such as (MsgNews/MsgNewsNoWait/MsgBox/MsgBoxNoWait)
	GetVariableParameters(arg)

	MsgNewsNoWait(Owner,Owner,"",MessageClass,-1, HeaderText, Text)
end

function MessageCharacter(Owner, Headline, Text, ...)

	local HeaderText = Headline
	local MessageClass = "intrigue"
	
	-- copies variable parameters to c	
	-- attention - GetVariableParameters works only with special function such as (MsgNews/MsgNewsNoWait/MsgBox/MsgBoxNoWait)
	GetVariableParameters(arg)
	
	MsgNewsNoWait(Owner,Owner,"",MessageClass,-1, HeaderText, Text)
end

function MessageProduction(Owner, Headline, Text,...)

	local HeaderText = Headline
	local MessageClass = "production"
	
	-- copies variable parameters to c	
	-- attention - GetVariableParameters works only with special function such as (MsgNews/MsgNewsNoWait/MsgBox/MsgBoxNoWait)
	GetVariableParameters(arg)
	
	MsgNewsNoWait(Owner,Owner,"",MessageClass,-1, HeaderText, Text)
end

function MessageEconomie(Owner, Headline, Text, ...)

	local HeaderText = Headline
	local MessageClass = "economie"

	-- copies variable parameters to c	
	-- attention - GetVariableParameters works only with special function such as (MsgNews/MsgNewsNoWait/MsgBox/MsgBoxNoWait)
	GetVariableParameters(arg)

	MsgNewsNoWait(Owner,Owner,"",MessageClass,-1, HeaderText, Text)
end

function MessageMilitary(Owner, Headline, Text, ...)

	local HeaderText = Headline
	local MessageClass = "military"
	
	-- copies variable parameters to c	
	-- attention - GetVariableParameters works only with special function such as (MsgNews/MsgNewsNoWait/MsgBox/MsgBoxNoWait)
	GetVariableParameters(arg)
		
	MsgNewsNoWait(Owner,Owner,"",MessageClass,-1, HeaderText, Text)
end

function MessagePolitics(Owner, Headline, Text, ...)

	local HeaderText = Headline
	local MessageClass = "politics"
	
	-- copies variable parameters to c	
	-- attention - GetVariableParameters works only with special function such as (MsgNews/MsgNewsNoWait/MsgBox/MsgBoxNoWait)
	GetVariableParameters(arg)
		
	MsgNewsNoWait(Owner,Owner,"",MessageClass,-1, HeaderText, Text)
end

function MessageSchedule(Owner, Headline, Text, ...)

	local HeaderText = Headline
	local MessageClass = "schedule"
	
	-- copies variable parameters to c	
	-- attention - GetVariableParameters works only with special function such as (MsgNews/MsgNewsNoWait/MsgBox/MsgBoxNoWait)
	GetVariableParameters(arg)

	MsgNewsNoWait(Owner,Owner,"",MessageClass,-1, HeaderText, Text)
end

function MessageMission(Owner, Headline, Text, ...)

	local HeaderText = Headline
	local MessageClass = "mission"	
	
	-- copies variable parameters to c	
	-- attention - GetVariableParameters works only with special function such as (MsgNews/MsgNewsNoWait/MsgBox/MsgBoxNoWait)
	GetVariableParameters(arg)

	MsgNewsNoWait(Owner,0,"",MessageClass,-1, HeaderText, Text)
end

function MessageDefault(Owner, Headline, Text, ...)

	local HeaderText = Headline
	local MessageClass = "default"

	-- copies variable parameters to c	
	-- attention - GetVariableParameters works only with special function such as (MsgNews/MsgNewsNoWait/MsgBox/MsgBoxNoWait)
	GetVariableParameters(arg)

	MsgNewsNoWait(Owner,Owner,"",MessageClass,-1, HeaderText, Text)
end

-- -----------------------
-- MsgBox - ganz wichtige Messages
-- -----------------------

function MessageBox(Owner, Headline, Text, ...)

	local HeaderText = Headline
	
	-- copies variable parameters to c	
	-- attention - GetVariableParameters works only with special function such as (MsgNews/MsgNewsNoWait/MsgBox/MsgBoxNoWait)
	GetVariableParameters(arg)
		
	MsgBoxNoWait(Owner,Owner,HeaderText, Text)
end

-- -----------------------
-- PregnancySuccess
-- -----------------------
function PregnancySuccess(Gender, Success)

	label = "@L_FAMILY_2_COHABITATION_PREGNANCY"
	
	if (Success == 0) then
		label = label.."_UNSUCCESSFUL"
	else
		label = label.."_SUCCESSFUL"
	end
	
	if (Gender == GL_GENDER_MALE) then
		label = label.."_TOFEMALE"
	else
		label = label.."_TOMALE"
	end
	
	return label
end

-- -----------------------
-- AskMarriage
-- -----------------------
function AskMarriage(Rhetoric, Gender)

	label = "@L_FAMILY_1_MARRIAGE_QUESTION"
	
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
-- AnswerMarriage
-- -----------------------
function AnswerMarriage(Rhetoric, Gender)

	label = "@L_FAMILY_1_MARRIAGE_ANSWER"
	
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


-- -------------------------
-- Msg for gaining an office
-- -------------------------
function MessageOffice(Owner, GetPrivilegeList, Headline, Text, ...)

	local HeaderText = Headline
	local MessageClass = "politics"
	
	local Privilegs = { GetPrivilegeList() }
	local PrivilegName
	local Label
	local Count = 1
	local Param = {}
	
	local FirstFreeParameter = arg.n + 2
	local PriviText = ""
	
	GetVariableParameters(arg)

	if not(Privilegs[Count]) then
		Text = Text.."_+1"
	else
		Text = Text.."_+0"	
		while (Privilegs[Count]) do
	
			PrivilegName = Privilegs[Count]
			
			-- PrivilegName -> "AimForInquisitionalProceeding" or "HaveImmunity"
			
			Param[Count] 		= "_MEASURE_"..PrivilegName.."_NAME_+0"
			PriviText 		= PriviText .. "$N  - %"..FirstFreeParameter.."l"
			FirstFreeParameter 	= FirstFreeParameter + 1
			
			Count = Count + 1
		end
	end

	SetArg( arg.n+1, PriviText)
	Count = 1
	while (Param[Count]) do
		SetArg(arg.n+1+Count, Param[Count])
		Count = Count + 1
	end
	
	-- copies variable parameters to c	
	-- attention - GetVariableParameters works only with special function such as (MsgNews/MsgNewsNoWait/MsgBox/MsgBoxNoWait)

		
	MsgNewsNoWait(Owner,Owner,"",MessageClass,-1, HeaderText, Text)
end

