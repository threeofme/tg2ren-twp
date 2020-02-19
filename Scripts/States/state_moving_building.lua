function Init()
	local BuildingType = BuildingGetType("")
	local Level = BuildingGetLevel("")
	GetPosition("","Pos")
	local x,y,z = PositionGetVector("Pos")
	local BuildingRotRad = (ObjectGetRotationY("") / 360) * (2 * math.pi)
	
	if BuildingType == 104 then -- Windmill
		local dx = 20
		local dz = 200
		local ZN = z + math.cos(BuildingRotRad) * (dx) - math.sin(BuildingRotRad) * (dz)
		local XN = x + math.sin(BuildingRotRad) * (dx) + math.cos(BuildingRotRad) * (dz)
		
		GfxAttachObject("BuildingAnimation0","buildings/windmillwheel.nif")
		if AliasExists("BuildingAnimation0") then
			GfxSetPosition("BuildingAnimation0",XN,y+665,ZN,true)
			GfxSetRotation("BuildingAnimation0", 0, 90, 0, false)
		end
	elseif BuildingType == 27 then -- Arsenal
		local dx = 0
		local dz = 0
		local ZN = z + math.cos(BuildingRotRad) * (dx) - math.sin(BuildingRotRad) * (dz)
		local XN = x + math.sin(BuildingRotRad) * (dx) + math.cos(BuildingRotRad) * (dz)
		if Level == 1 then
			GfxAttachObject("BuildingAnimation0","buildings/arsenal_anim_low.nif")
		elseif Level == 2 then
			GfxAttachObject("BuildingAnimation0","buildings/arsenal_anim_med.nif")
		else
			GfxAttachObject("BuildingAnimation0","buildings/arsenal_anim_high.nif")
		end
		if AliasExists("BuildingAnimation0") then
			GfxSetPosition("BuildingAnimation0",XN,y,ZN,true)
			GfxSetRotation("BuildingAnimation0", 0, 90, 0, false)
		end
	elseif BuildingType == 24 then -- Well
		local dx = 0
		local dz = 0
		local ZN = z + math.cos(BuildingRotRad) * (dx) - math.sin(BuildingRotRad) * (dz)
		local XN = x + math.sin(BuildingRotRad) * (dx) + math.cos(BuildingRotRad) * (dz)
		if Level == 1 then
			GfxAttachObject("BuildingAnimation0","buildings/well_anim_low.nif")
		elseif Level == 2 then
			GfxAttachObject("BuildingAnimation0","buildings/well_anim_med.nif")
		else
			GfxAttachObject("BuildingAnimation0","buildings/well_anim_high.nif")
		end
		if AliasExists("BuildingAnimation0") then
			GfxSetPosition("BuildingAnimation0",XN,y+2,ZN,true)
			GfxSetRotation("BuildingAnimation0", 0, 0, 0, false)	
		end
	elseif BuildingType == 102 then -- Juggler
		if Level > 1 then
			local dx = -270
			local dz = 390
			
			local ZN = z + math.cos(BuildingRotRad) * (dx) - math.sin(BuildingRotRad) * (dz)
			local XN = x + math.sin(BuildingRotRad) * (dx) + math.cos(BuildingRotRad) * (dz)
			GfxAttachObject("BuildingAnimation0","buildings/juggler_anim_med.nif")
			if AliasExists("BuildingAnimation0") then
				GfxSetPosition("BuildingAnimation0",XN,y+5,ZN,true)
				GfxSetRotation("BuildingAnimation0", 0, 315, 0, false)
			end	
		end
		if Level == 1 then
			GfxStartParticle("JugglerFlames0", "particles/fire1.nif", "Pos", 1)
		elseif Level == 2 then
			GfxStartParticle("JugglerFlames0", "particles/fire1.nif", "Pos", 2)
		else
			GfxStartParticle("JugglerFlames0", "particles/fire1.nif", "Pos", 2)
		end
		SetProperty("","FireOn", 1)
	elseif BuildingType == 109 then -- Soldierplace
		local dx = 0
		local dz = 0
		
		local ZN = z + math.cos(BuildingRotRad) * (dx) - math.sin(BuildingRotRad) * (dz)
		local XN = x + math.sin(BuildingRotRad) * (dx) + math.cos(BuildingRotRad) * (dz)
		GfxAttachObject("BuildingAnimation0","buildings/soldierplace_anim.nif")
		if AliasExists("BuildingAnimation0") then
			GfxSetPosition("BuildingAnimation0",XN,y,ZN,true)
			GfxSetRotation("BuildingAnimation0", 0, 0, 0, false)
		end
	elseif BuildingType == 21 and Level > 1 then -- Mercenary
		local dx = 0
		local dz = 0
		
		local ZN = z + math.cos(BuildingRotRad) * (dx) - math.sin(BuildingRotRad) * (dz)
		local XN = x + math.sin(BuildingRotRad) * (dx) + math.cos(BuildingRotRad) * (dz)
		GfxAttachObject("BuildingAnimation0","buildings/mercenary_anim.nif")
		if AliasExists("BuildingAnimation0") then
			GfxSetPosition("BuildingAnimation0",XN,y,ZN,true)
			GfxSetRotation("BuildingAnimation0", 0, 0, 0, false)
		end
	end
end

function Run()
	if BuildingGetType("") == 104 then -- Windmill
		local LastState = 0
		if not HasProperty("","Active") then
			SetProperty("","Active",0)
		end
		while true do
			local NextState = GetProperty("","Active")
			if NextState ~= LastState then
				LastState = NextState
				GfxSetPosition("BuildingAnimation0",0,-1000,0,false)
				GfxDetachObject("BuildingAnimation0")
				
				if NextState == 1 then
					GfxAttachObject("BuildingAnimation0","buildings/windmillwheel_anim.nif")
				else
					GfxAttachObject("BuildingAnimation0","buildings/windmillwheel.nif")
				end
				GetPosition("","Pos")
				local x,y,z = PositionGetVector("Pos")
				local BuildingRotRad = (ObjectGetRotationY("") / 360) * (2 * math.pi)
				local dx = 20
				local dz = 200
				local ZN = z + math.cos(BuildingRotRad) * (dx) - math.sin(BuildingRotRad) * (dz)
				local XN = x + math.sin(BuildingRotRad) * (dx) + math.cos(BuildingRotRad) * (dz)
				
				GfxSetPosition("BuildingAnimation0",XN,y+665,ZN,true)
				GfxSetRotation("BuildingAnimation0", 0, 90, 0, false)
			end
			Sleep(Rand(2)+5)
		end
	elseif BuildingGetType("") == 102 then -- Juggler
		while true do
			if Weather_GetValue(0) > 0.5 and GetProperty("","FireOn") == 1 then -- rain
				GfxStopParticle("JugglerFlames0")
				SetProperty("","FireOn", 0)
			elseif Weather_GetValue(0) < 0.5 and GetProperty("","FireOn") == 0 then
				if Level == 1 then
					GfxStartParticle("JugglerFlames0", "particles/fire1.nif", "Pos", 1)
				elseif Level == 2 then
					GfxStartParticle("JugglerFlames0", "particles/fire1.nif", "Pos", 2)
				else
					GfxStartParticle("JugglerFlames0", "particles/fire1.nif", "Pos", 2)
				end
				SetProperty("","FireOn", 1)
			end
			Sleep(Rand(2)+5)
		end
	else
		while true do
			Sleep(Rand(2)+5)
		end
	end
end

function CleanUp()
	if AliasExists("BuildingAnimation0") then
		if BuildingGetType("") == 104 or BuildingGetType("") == 27 
			or BuildingGetType("") == 29 or BuildingGetType("") == 102 
			or BuildingGetType("") == 109 or BuildingGetType("") == 21 then
			GfxSetPosition("BuildingAnimation0",0,-1000,0,false)
			GfxDetachObject("BuildingAnimation0")
		end
	end

	if BuildingGetType("") == 102 then
		GfxStopParticle("JugglerFlames0")
	end
end
