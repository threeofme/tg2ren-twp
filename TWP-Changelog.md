Changelog
=========

## TWP 1.0.1beta ##

This minor version includes following changes:

* Orchard and beehives are now buildable resources, like fields. Thanks to *Ictiv* for help with that, especially the textures in the building menu.
* Some missing English localization was added.
* New measure "Buy Items (Gegenst‰nde kaufen)" enables your sims to buy items directly from market or a sales counter.
* Some missing files were added. 
 

## TWP 1.0beta ##
TradeWarPolitics 1.0beta is the first mod version independant of the MegaModPack. 
**Installation of the MegaModPack is not required anymore.**

This version also changes several production values to improve AI management. 

Bugfixes:

* Medical treatment: Own dynasty members should not pay for treatment.
* Medical treatment: Patients with burnwounds should also be healed.
* AI settings: Don't ask player about repairs triggered by AI.
* Messages for dying family members were sent to every player.
* Balance: Shadow AI is now less agressive.
* Balance: Reduced infection rates of cold and influenza.

## TWP 0.95.5 ##

The following bugs were fixed:

* AI was unable to accuse someone for trial
* overflowing resources (honey bug) were not removed from market
* offer/need events at markets were bad for performance, so the item limit was removed. Texts are not ideal yet.
* cocottes stopped working after midnight

I also moved the danegeld from mercenaries to robbers. 


## TWP 0.95.4 ##
This is a non-beta release for the changes introduced an polished during the 0.95.3beta.
Thanks and kudos to **Ictiv**, **DarkOmegaMK2** and **Sir Kitteh** from the Steam forum for 
their testing and support during the beta!

Additional changes: 

* removed logging calls in AI
* implemented AI control for player divehouse


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
	
* burglary: added check for building owners and diplomatic state
* f_CreditMoney: always credit to workbuilding, not workers
* send cart and traderoutes: set movespeed to run
* bugfix: availability of medicine was ignored on treat target
* decrease chance for inferno, but include workshops
* bugfix: calculate affordable amount of items to buy
* bugfix: removed call to unused medicinechest
* bugfix: dyn member should not look for spouses
* enable king to vote on treasurer
* bugfix: no idle measures just before trial/duel/election
* increase city income (taxes) to handle increased repair costs
* removed log error for CocotteIdle

2019-02-11 Several Bugfixes

* bugfix: sales counter should offer mussel soup
* bugfix: alias not found for employees in creditmoney (cancels medical treatment)
* bugfix: check presession and pretrial behavior on AI (should fix AI running away from sessions, requires testing)

2019-02-12 Bugfixes for trials, pickpocket and kontor events

* bugfix: don't pickpocket buildings
* bugfix: kontor/market events cancelled early

2019-02-18 Bugfixes for trial and new measure

* The salescounter of fishinghuts did not restock properly. Also removed herring from the counter.
* New measure: thugs may now be set to automatic. They will then look for tasks (patrol, escort, gather evidence) 
  by themselves.
* bugfix: pretrial measure stopped early, freeing the SIM for other tasks
* bugfix: player SIMs did not move during cutscenes (with active logging)
* AI should not use privileges in the first round (seriously, getting banned in your first round is nasty)

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


## TWP 0.95.1 ##

Bug fixes:

* AI will now balance choices for new buildings properly.
* Switched steel upgrade, shortsword and longsword in upgrade tree of smithy.
* Black death did not spread properly.
* Bribes by AI were reduced based on the bribe target. This stops the bribe spamming.

Bug fixes by Fajeth:

* No use of toad excrements (Kr√∂tenschleim) outside of working hours.
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
