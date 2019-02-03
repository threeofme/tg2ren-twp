Installation
============

TradeWarPolitics is based on Fajeth's MegaModPack 0.95. Make sure to follow 
the installation instructions of that mod **before** you continue with the 
following steps.

1. Make sure that **MegaModPack 0.95** is installed correctly.

2. **IMPORTANT** Remove the folder "Scripts/AI/" from your game folder. 
   Do not remove the rest of the scripts folder, as not all scripts are 
   contained in this zip file.
   You may experience oddities in AI behavior if you skipped this step. 

3. Unzip this mod into your Guild2 game folder. Confirm to overwrite 
   existing files. If you are not prompted to confirm any overwrite, 
   you unzipped into the wrong folder.

4. Go into the DBT-folder and remove the file **Text.dbt**. Rename the 
   file **Text_EN.dbt** or **Text_DE.dbt** into **Text.dbt** for English 
   or German text.

5. Start a new game and have fun. 


Mod Details
===========

Abstract
--------

The Mod "Trade, War, Politics" strives to improve the economic aspects of The Guild 2: Renaissance. Trading is improved through better trading routes and a completely reworked sales counter. The war scripts have been fixed to improve chances of war in late game. And another office seat was added in politics. See the feature list for complete reference.

The mod was tested in multiplayer sessions through multiple saves/loads, OOS has not been a problem.

The mod is to be considered "Work in Progress". It is currently based on Fajeth's MegaModPack 0.95 and includes some of Fajeth's fixes after 0.95. I may later port the actual features to other mod bases.

Please see the changelog at the end of this file for the latest changes.


Features
--------

### Trade ###

* A new sales counter was implemented. It is available through a building 
  measure (look for crates). The amount of items in your counter can be configured. 
  The items will be put into the counter automatically. 

* The AI uses the sales counter for all production items. 

* Idle SIMs will check out the sales counters of local shops and may buy items.

* The world traders (neutral carts) will look for interesting goods at local shops. 
  They may buy larger amounts at your sales counter.

* You may use a cart to buy items from market or shops. Use the measure "Send cart 
  and unload" which has a new option to "Buy and return".

* A new Measure "Show Workshop Balance" is available on all production buildings. 
   The sheet sums up all wages and all transactions done with either "Send cart and 
   unload" or trade routes. It also lists sales at your sales counter.

* Trade events are enabled for any market, not just counting houses. The chances are 
  much higher for need events than for offer events.


### War ###

* War will happen later but more than once.

* The calculation for winning/losing the war was improved. Sending officers and armsmen 
  will improve chances.


### Politics ###

* All office incomes have been increased significantly. 

* To afford the extra payments, the costs for office applications counts towards the 
  city treasury.

* New office **Treasurer** was introduced to take care of taxes. This serves to split 
  the power in city council.


### Other Changes ###

* Spirit production was moved to alchemist.

* Fruit farms now produce wine. Sugar beets were removed.

* Nobility title at game start may now be configured in config.ini, look for "InitialTitle". 
  It defaults to "2".

* Increased chances for city events (fire, sickness, black death). Chances are based on 
  difficulty, but never fall to zero. Chances also depend on current season, so expect 
  more fires in summer.


Bug fixes
---------

* AI will now balance choices for new buildings properly.

* Switched steel upgrade, shortsword and longsword in upgrade tree of smithy.

* Black death did not spread properly.

* Bribes by AI were reduced based on the bribe target. This stops the bribe spamming.


Bug fixes by Fajeth
-------------------

These fixes have mainly been provided by Fajeth after the release of MegaModPack 0.95:

* No use of toad excrements (Krötenschleim) outside of working hours.
* Fixed tutorial (Gwendo).
* Removed unused impacts.
* Fixed class check for church measures.
* Enable wool for visions.
* Polluted well only causes cold and influenza now.
* Several fixes in movement functions.
* Improved pathfinding in Dusseldorp
* Stop courting when fiance is hired.
* Added secondmessage when proposing to workers.
* Family members outside the current party were just standing around.
* Dynasty characters did not work properly in AI-controlled buildings.
* Fixed message when no random worker was available for hire.
* Fixed message when hiring employees while budget is low.  


Known Issues
------------

* Workers seem to end their work days early sometimes.
* AI dynasties still seem to die out quickly.
* Trading routes do not continue after being robbed.
* The game may or may not OOS in trial situations. Avoid watching the 
  trial scene if it happens in your game. 
* The AI is unable to build outside the city walls. I see no more ways 
  to fix this without access to the source code. 


Planned Features
----------------
There are still some ideas I'd like to implement in the future -- whenever 
I find the time. Here are the most likely to happen:

* The warehouse should have workers (merchants). They will have two measures: 
  free trade and trade agreement. Free trade is currently limited to dynasty 
  characters and bound to an upgraded residence. 
  Trade agreements can be reached by sending the merchant off to another 
  town/market/counting house. The player chooses item type and amount and tries 
  to fetch good prices.

* War should lead to special conditions at the markets. Any weapons and armor 
  will be needed as well as food for the army. Also, participating in war should 
  be more interesting and transparent. 

* AI-workshops currently don't look for resources at the sales counters of other 
  shops.

* The AI control for rogue buildings of the player is mostly useless. It works 
  better for AI rogues. I'll look into that some time.


Changelog
=========

## TWP 0.95.3beta ##

This version offers a thorough rework of AI dynasties. It still requires testing of
AI and performance in longer games:

**NOTE** this is a beta release, so don't blame me for breaking your game. 
It's possible to have two installations of the game side-by-side, make use 
of that. Also, I'd appreciate any feedback regarding the AI or the mod in 
general. 

* The courting process works all the way up to marriage. The AI is now able 
  to start with a single character, just like the player. 
  
* The AI should even be able to build the first workshop pretty soon, but I still 
  recommend giving them one workshop at game start.

* Several dynasty actions were moved to idle behavior of a SIM. This includes tavern 
  visits, medical treatment, poison treatment and usage of boosting artefacts. It also 
  includes additional courting actions to make sure they are able to get married.

* Idle family members (non-party) will also perform idle actions (see above).

* The decisions of AI dynasties are now partly based on a priority system that calculates 
  their current interest in political and military actions. The decisions are also based on 
  current events like duels, trials and office applications.

* The AI will now focus aggressive actions on a few enemies. The current enemies are 
  reconsidered every other day and may include economic rivals, current feuds and other 
  colored dynasties. 

* The AI did not receive/spend money in most scripted actions. I found a workaround to
  enable normal finances for AI dynasties. Try getting them bankrupt :) 

* The divehouse was unable to use the sales counter for smuggled goods. It is now enabled. 

* The working hours of some professions were reduced. I'll check the balancing of these 
  changes later, just seemed right to give these guys some leisure time and sleep. 
    - Brewer:  10--24
	- Priest:   9--21
	- Cocotte: 12-- 2
	- Medic:    8--22
	- Banker:   6--20
	- Juggler:  9--21

## TWP 0.95.2 ##

This version improves the sales counter and balance sheets for workshops. It also introduces some major changes to the rogue class.


### Features ###

* The warehouse has access to a special sales counter. You may offer any goods at the warehouse. The sales counter is limited to 16 slots though.

* Some item selections (send cart, trade route) have been changed to an icon based approach. This should make the process more natural.

* The thieves now have a measure that steals directly from the sales counter of a building. The measure is similar to the old plunder measure, but targets sales counters only. It may need further balancing.

* The balance sheet of a workshop now calculates the wages into your shop balance for each round.

* The measure "Send card, load and return" now unloads the goods if it returns to its home workshop.


### Rogue changes ###

* The Mercenary camp was removed from the rogue class and is now available to everyone. Mercenaries now offer escort and patrols. Further rework will require a closer look at the measures of mercenaries. 

* Kidnapping was moved to robbers and requires third level. Robber and thief now share the same indoor scene, since the robbers need the prison cell.

* A balance sheet is now available for rogue buildings. Note that robbed carts will not show as theft, but selling the goods will be listed as income.

* Thieves can now be properly controlled by the AI. You should see more burglaries happen than before.

* The thief measures now depend on the building level. Your start out with pickpocketing. Second level grants burglary. Third level allows you to steal from sales counters.


### Bugfixes ###

* Farms and orchards did not restock the sales counter automatically.

* World traders did not move between workshops to buy random goods. This bug made sales counters much more profitable than intended.

* Randomized the gender of the main character of opposing dynasties.

* Some issues were located that produced errors in the logfile.

* Fixed a bug that led to shadow dynasties having no carts at all. 


### Known Bugs ###

* The wrenches of AI controlled taverns do not go out to work. 

* Some text substitution errors show in the log, but I didn't find the source yet.


### Modding Information ###

The following information may be helpful for modders:

* Most of the functions regarding the reworked sales counter can be found in library/economy.lua. This file is also home to a few functions regarding the balance sheet of workshops.

* Most building scripts were refactored to use functions in library/bld.lua. Hence the references to bld_HandleOnSetup(), bld_HandlePingHour() and similar functions. This makes additions to these actions much easier.

* I implemented some helper functions for carts in library/cart.lua. 

* The rogue actions of the AI are now implemented in library/roguelib.lua. These functions (i.e. pickpocket) will first attempt to find a valid destination and then start the measure or return false.

* I found the hard coded function CityFindCrowdedPlace() to be bugged. Most importantly the result is not random, leading to a lot of thieves at one place.

* The list of items offered in sales counters can be found in DB/BuildingToItems.dbt. If you add your own items, make sure to add them to those lists. 


