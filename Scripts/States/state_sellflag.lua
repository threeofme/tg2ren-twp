function Init()
	BuildingGetOwner("", "FormerOwner")
	SetData("FormerOwner", GetID("FormerOwner"))
end

function Run()
	local offsety = 90
	if not GetLocatorByName("", "sell", "Pos", true) then
		GetLocatorByName("", "Entry1", "Pos")
		offsety = 10
	end
	local x, y, z = PositionGetVector("Pos")
	GfxAttachObject("SellFlag","buildings/Verkaufsschild.nif")
	GfxSetPosition("SellFlag",x,y-offsety,z,true)
	while true do
		Sleep(2)
		if not BuildingGetForSale("") then
			return
		end
	end
end

function CleanUp()
	if AliasExists("SellFlag") then
		GfxSetPosition("SellFlag",0,-1000,0,false)
		GfxDetachObject("SellFlag")
	end
	
	BuildingGetOwner("", "NewOwner")
	if GetData("FormerOwner") ~= GetID("NewOwner") then
		bld_HandleNewOwner("", "FormerOwner") 
	end
end