-- -----------------------
-- Init
-- -----------------------
function Init()
 --needed for caching
end

function GetDuration(MeasureID)
	local Duration = GetDatabaseValue("Measures",MeasureID,"duration")
	--for artifact duration
	if (((MeasureID >= 1630) and (MeasureID <= 1990)) or
	(MeasureID == 10925) or
	((MeasureID >= 10928) and (MeasureID <= 10930)) or
	((MeasureID == 10932)) or
	((MeasureID >= 10961) and (MeasureID <= 10963)) or
	((MeasureID >= 11001) and (MeasureID <= 11011)) or
	((MeasureID >= 11093) and (MeasureID <= 11097)) or
	((MeasureID >= 11968) and (MeasureID <= 11989)) or
	((MeasureID >= 12052) and (MeasureID <= 12054)) or
	((MeasureID >= 12063) and (MeasureID <= 12064)) or
	((MeasureID >= 13005) and (MeasureID <= 13006)) or
	((MeasureID >= 13018) and (MeasureID <= 13030))) then
		Duration = Duration + (chr_ArtifactsDuration("",Duration))
	end
	return Duration
end

function GetTimeOut(MeasureID)
	local TimeOut = GetDatabaseValue("Measures",MeasureID,"repeat_time")
	--for artifact timeout
	if (((MeasureID >= 1630) and (MeasureID <= 1990)) or
	(MeasureID == 10925) or
	((MeasureID >= 10928) and (MeasureID <= 10930)) or
	((MeasureID == 10932)) or
	((MeasureID >= 10961) and (MeasureID <= 10963)) or
	((MeasureID >= 11001) and (MeasureID <= 11011)) or
	((MeasureID >= 11093) and (MeasureID <= 11097)) or
	((MeasureID >= 11968) and (MeasureID <= 11989)) or
	((MeasureID >= 12052) and (MeasureID <= 12054)) or
	((MeasureID >= 12063) and (MeasureID <= 12064)) or
	((MeasureID >= 13005) and (MeasureID <= 13006)) or
	((MeasureID >= 13018) and (MeasureID <= 13030))) then
		TimeOut = TimeOut - (chr_ArtifactsDuration("",TimeOut))
	end
	return TimeOut
end

