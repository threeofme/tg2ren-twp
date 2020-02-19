-------------------------------------------------------------------------------
----
----	OVERVIEW "std_Towncrier.lua"
----
----	Behavior of the towncrier
----	
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()

	local YearArray = {}

	GetScenario("World")
	if HasProperty("World", "Vienna") then
		YearArray = {1401,1403,1409,1410,1413,1415,1417,1418,1420,1425,1426,1427,1429,1431,1432,1433,1438,1440,1443,1444,1445,1447,1448,1450,1451,1452,1453,1456,1461,1463,1471,1473,1476,1478,1480,1481,1483,1493,1499,1502,1504,1506,1515,1519,1522,1526,1529,1532,1536,1540,1543,1547,1551,1555,1557,1560,1563,1566,1575,1580,1584,1588,1591,1597,-1}
	else
		YearArray = {1401,1403,1404,1405,1406,1409,1410,1413,1415,1416,1417,1418,1419,1420,1421,1422,1423,1424,1425,1426,1427,1428,1429,1430,1431,1432,1433,1434,1436,1438,1440,1443,1444,1445,1447,1448,1450,1451,1452,1453,1454,1456,1459,1461,1463,1465,1469,1471,1473,1474,1476,1478,1479,1480,1481,1483,1489,1493,1495,1499,1502,1504,1506,1507,1508,1509,1510,1511,1512,1515,1519,1522,1526,1529,1532,1536,1540,1543,1547,1551,1555,1557,1560,1563,1566,1569,1571,1573,1575,1580,1584,1588,1591,1594,1597,-1}
	end

	local action = false
	local counter = 1

	SetState("", STATE_TOWNNPC, true)
	SimSetMortal("",false)
	--AddImpact("","FinnishQuest",1,-1)
	GetHomeBuilding("", "home")
	BuildingGetCity("home", "homecity")
	local LastYear = 1399
	local CurrentYear = 1399
	
	--bard props
	SetProperty("","IsBard",1)
	SetProperty("","BardIsFree",1)
	
	while true do
		if GetProperty("","BardIsFree")==1 then

			--if not CityGetRandomBuilding("homecity",5,14,-1,Rand(5)+1,FILTER_IGNORE,"Market") then
			if not CityGetRandomBuilding("homecity", -1, GL_BUILDING_TYPE_MARKET, nil, nil, FILTER_IGNORE, "Market") then
				f_MoveTo("", "homecity")
			end
			GetOutdoorMovePosition("","Market","crypos")
			f_MoveTo("", "crypos")
			AlignTo("","homecity")
			
			Sleep(10)
			-- Check the year
			CurrentYear = GetYear()
			if (CurrentYear < 1597) and (CurrentYear > LastYear) and not (YearArray[counter]==-1) then
			
				while (YearArray[counter] - 1) < CurrentYear do
					if (YearArray[counter]==-1) then
						break
					elseif (YearArray[counter]==CurrentYear) then
						action = true
					end
					counter = counter + 1
				end
				
				if action then
					PlayAnimationNoWait("", "pray_standing")
					MsgSay("", "@L_TOWNCRIER_INTROS")
					MsgSay("", "@L_TOWNCRIER_"..CurrentYear)
					MsgSay("", "@L_TOWNCRIER_OUTROS")
				end
							
			end
			LastYear = CurrentYear

		end
		Sleep(30)		
	end	
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	--RemoveImpact("","FinnishQuest")
end

