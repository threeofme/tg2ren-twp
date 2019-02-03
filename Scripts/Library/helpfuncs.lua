-- several helpful functions, copy pasted from various lua tutorial websites or created myself. Serp
-- version 1


function Init()
 --needed for caching
end

-- help functions to deal with arrays and strings... because the lua table and alot of other lua functions do not work -.-
function iter (a, i)
  i = i + 1
  local v = a[i]
  if v then
    return i, v
  end
end
function myipairs (a)   -- funktioniert nur mit zahlen als Key
  return helpfuncs_iter, a, 0
end
function mytablelength(T)
  local count = 0
  for _ in helpfuncs_myipairs(T) do count = count + 1 end
  return count
end
function mysplit(source, delimiters)
    local elements = {}
    local pattern = '([^'..delimiters..']+)'
    string.gsub(source, pattern, function(value) elements[helpfuncs_mytablelength(elements) + 1] =     value;  end);   
    return elements
end

function myreplace(source,repl,with) -- repl has to be at least 2 characters long
    result = string.gsub(source,"%b"..repl, with) -- to use it for one character, leave out the %b .   To replace a non-alphanumeric character like a dot, use %. for a dot
    return result
end

-- rounding of numbers
function myround(num, idp)
  if idp and idp>0 then
    local mult = 10^idp
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end

-- to unpack an array as single arguments in a function (eg. good for msgboxes with a variable number of arguments)
function myunpack (t, i)
    i = i or 1
    if t[i] ~= nil then
        return t[i], helpfuncs_myunpack(t, i + 1)
    end
end

-- Sorts a table opionally using specified comparison function.
-- http://rosettacode.org/wiki/Sorting_algorithms/Quicksort#Lua
-- Arguments:
--    t        table to be sorted
--    start    first element index
--    endi     last element index
--    compare  (optional) comparison function used to sort the elements. The function should take 2 arguments and
--             should return true when the first is less than or equal to the second and false otherwise. The default is:
--             function(a,b) return a<=b end
function QuickSort(t, start, endi, compare)
  start = start or 1
  compare = compare or function(a,b) return a<=b end
  -- partition w.r.t. first element
  if(endi - start < 2) then return t end
  local pivot = start
  for i = start + 1, endi do
    -- equivalent of:   if t[i] <= t[pivot] then
    if compare(t[i], t[pivot]) then
      local temp = t[pivot + 1]
      t[pivot + 1] = t[pivot]
      if(i == pivot + 1) then
        t[pivot] = temp
      else
        t[pivot] = t[i]
        t[i] = temp
      end
      pivot = pivot + 1
    end
  end
  t = helpfuncs_QuickSort(t, start, pivot - 1, compare)
  return helpfuncs_QuickSort(t, pivot + 1, endi, compare)
end


-- the Alias should be the sim, which started the measure, which is just ""
function GetNameParts(Alias)  -- seperates firstname from lastname, from the charakter that is doing this measure. don't know how to give the charakter to another script function, so these functions have to be in the script from the measure
    local name = GetName(Alias) -- gets the whole name
    local lastname = SimGetLastname(Alias)  -- get last name, simgetfirstname does not exist
    SimSetLastname(Alias,"13429035845435") -- change to nothing does not work.. so we set it to sth that won't exist ingame, like random numbers
    local newname = GetName(Alias) -- get the whole new name
    local firstname = string.gsub(newname,"%b 13429035845435", "")  -- and then we cut those numbers with the space after the firstname, so only the firstname is left
    SimSetLastname(Alias,lastname) -- set the last name back
    return {firstname,lastname}
end

function GetEnteredString(firstname,lastname,Alias) -- gets the entered string, which is the new firstname.
    local infoname = GetName(Alias)
    local info = string.gsub(infoname,"%b "..lastname, "") -- the info ist the infoname without the lastname and space
    SimSetFirstname(Alias,firstname)  -- change the firstname back 
    MsgQuick(Alias,"klappt")
    return info
end

function StringToIdList(ItemsString)
	if ItemsString == nil or ItemsString == "" then
		return 0, {}
	end
	local Items = {}
	local Count = 0
	for Id in string.gfind(ItemsString, "%d+") do
		Count = Count + 1
		Items[Count] = (Id + 0) -- convert id from string to number through arithmetic operation
	end
	return Count, Items
end


function IdListToString(IdList, ElementCount)
	local NewList = ""
	local Exists
	for i = 1, ElementCount do
		NewList = NewList..IdList[i].." "
	end
	return NewList
end


-- ##other useful lua functions, that does work:##
-- string.sub("Hello Lua user", 7)  --> "Lua user"
-- string.len("abc")                --> 3



-- INFO wenn ich ein übergebe und es in der funktion dann verändere, wird es überall woanders auch verändert!

-- ## in work: ##
-- function mystringtotable(thestring)   -- -- does not work, don't know why, but it works in fct itself -- does only work for my specific form of the array, but of course it can be generalized... "@LName_+0,@LName_+0,nichts,Der Bertige/@LGender_+0,-,@Lmale&@Lfemale,-"
    -- local Array = {}
    -- eintragarray = helpfuncs_mysplit(infostring,"/") -- seperate at the "/" sign
    -- for i, v in helpfuncs_myipairs(eintragarray) do 
        -- valuesarray = helpfuncs_mysplit(v,",") -- seperate at the "," sign.
        -- Array[i]={}
        -- for nummer, value in helpfuncs_myipairs(valuesarray) do 
            -- if nummer ~= 3 then
                -- Array[i][nummer] = value
            -- else -- nummer==3 need to be seperated again
                -- Array[i][nummer] = {}
                -- answerarray = helpfuncs_mysplit(value,"&")
                -- for answernummer, answer in helpfuncs_myipairs(answerarray) do
                    -- Array[i][nummer][answernummer] = answer
                -- end
            -- end
        -- end
    -- end 
    -- return Array
-- end

-- function mytabletostring(thetable) -- create a string, that has all info from the Kriterien array (because we can save only strings or numbers in property, to use it in another script) -- does only work for my specific array! needs to be generalized, before using it for all cases
    -- local infostring = ""
    -- for eintrag, v in helpfuncs_myipairs(thetable) do -- eintrag is the key like "1", and v is the value, at the moment: {Label="@LName_+0",Chosen="-",Answers={},Search=""}
        -- for nummer, value in helpfuncs_myipairs(v) do
            -- if nummer == helpfuncs_mytablelength(v) then
                -- infostring = infostring..value -- if it is the last value, no "," at the end
            -- elseif nummer == 3 then-- the Answers eintrag is a table
                -- for answernumber, answer in helpfuncs_myipairs(value) do
                    -- if answernumber == helpfuncs_mytablelength(value) then
                        -- infostring = infostring..answer
                    -- else
                        -- infostring = infostring..answer.."&" -- this as seperater
                    -- end
                -- end
                -- infostring = infostring.."," -- a "," after the whole entry
            -- else
                -- infostring = infostring..value..","  -- seperates the values with ","
            -- end
        -- end
        -- if eintrag ~= helpfuncs_mytablelength(thetable) then
            -- infostring = infostring.."/"   -- seperates the v with "/"
        -- end
    -- end
    -- return infostring
-- end
