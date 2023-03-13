Installation
============

Download-Link: https://github.com/threeofme/tg2ren-twp/archive/master.zip

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

  
### Nobility Title at Start ###

Nobility title at game start may now be configured in config.ini.
The setting "InitialTitle" relates directly to the file "NobilityTitle.dbt". 
So it should be a value of 2 (default) or higher.
Here is what I currently use on hardest difficulty:

	~~~~
	[INIT-PLAYER-4]
	HasResidence = 1
	Workshops = 0
	Money = 4000
	Married = 0
	InitialTitle = 2

	[INIT-AI-4]
	InitDelay = 1
	HasResidence = 1
	Workshops = 1
	Money = 4000
	Married = 0
	InitialTitle = 2
	~~~~
	
There is one AI- and one PLAYER-block for each difficulty (easy 0 ... 4 hard)

### Other Changes ###

* Spirit production was moved to alchemist.

* Fruit farms now produce wine. Sugar beets were removed.

* Increased chances for city events (fire, sickness, black death). Chances are based on 
  difficulty, but never fall to zero. Chances also depend on current season, so expect 
  more fires in summer.


Known Issues
------------

* AI dynasties still seem to die out quickly.
* Trading routes do not continue after being robbed.
* The game may or may not OOS in trial situations. Avoid watching the 
  trial scene if it happens in your game. [reported fixed, not confirmed]
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

* I'd like to improve the blackmail feature. Blackmail should give access to some 
  privileges and to voting.
