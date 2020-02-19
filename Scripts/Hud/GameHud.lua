function Init()

   -- InGame Menus
  this:AddPanel("InGameMenu","cl_StartMenuPanel","gui/menu/ingamemenu.gui",false)
  this:AddPanel("InGameQuit","cl_StartMenuPanel","gui/menu/ingame_quitgame.gui",false)
  this:AddPanel("InGameBack","cl_StartMenuPanel","gui/menu/ingame_quitgame.gui",false)
	this:AddPanel("ChatWindow","cl_ChatPanel","gui/Hud/panel_chat.gui",false)	
	this:AddPanel("WorldDeleteSheet", "cl_MessageBox","GUI/Menu/panel_delete_world.gui",false)
	this:AddPanel("SelectSaveGame","cl_StartMenuPanel","gui/menu/SelectSaveGame.gui", false)
 	this:AddPanel("RestartWarning","cl_StartMenuPanel","gui/menu/restartwarning.gui", false) 	
 	this:AddPanel("Options_Gfx","cl_StartMenuPanel","gui/menu/options_gfx.gui", false)
 	this:AddPanel("Options_Game","cl_StartMenuPanel","gui/menu/options_game.gui", false)
 	this:AddPanel("Options_Sound","cl_StartMenuPanel","gui/menu/options_sound.gui", false)
 	this:AddPanel("WorldOverwriteSheet", "cl_MessageBox","GUI/Menu/panel_overwrite_world.gui",false)
 	this:AddPanel("SavingSheet","cl_MessageBox","gui/Menu/panel_saving.gui",false)
 	this:AddPanel("OptionsSheet","cl_OptionsSheet","gui/Menu/savegame.gui",false)
 	
 	--this:AddPanel("TestPanel","cl_TestPanel","gui/Hud/panel_test.gui",false)
 	this:AddPanel("PausePanel","cl_PausePanel","gui/Hud/panel_pause.gui",false)
 	 	
 	this:AddPanel("SystemMessagePanel","cl_InfoPanel","gui/Hud/panel_systemmessage.gui",true,true)
 	this:AddPanel("QuickMessagePanel","cl_InfoPanel","gui/Hud/panel_quickmessage.gui",true,true)
 	
 	this:AddPanel("ClientListPanel","cl_ClientListPanel","gui/Menu/clientlist.gui",false)
 	
 	-- tutorial
 	--this:AddPanel("TutorialPanel","cl_TutorialPanel","gui/hud/panel_tutorial.gui", false)
 	
 	-- onscreen help
 	this:AddPanel("Guide","cl_GuidePanel","gui/hud/panel_guide.gui", false)

 	this:AddPanel("HelpCharacters","cl_OnscreenHelpPanel","gui/Hud/Helppanels/characters.gui",false)
	this:AddPanel("HelpSkill","cl_OnscreenHelpPanel","gui/Hud/Helppanels/skill.gui",false)
 	this:AddPanel("HelpItems","cl_OnscreenHelpPanel","gui/Hud/Helppanels/items.gui",false)
 	this:AddPanel("HelpBuildings","cl_OnscreenHelpPanel","gui/Hud/Helppanels/buildings.gui",false)
 	this:AddPanel("HelpUpgrades","cl_OnscreenHelpPanel","gui/Hud/Helppanels/upgrades.gui",false)
 	this:AddPanel("HelpCarts","cl_OnscreenHelpPanel","gui/Hud/Helppanels/carts.gui",false)
 	this:AddPanel("HelpMeasures","cl_OnscreenHelpPanel","gui/Hud/Helppanels/measures.gui",false)
 	this:AddPanel("HelpOffices","cl_OnscreenHelpPanel","gui/Hud/Helppanels/offices.gui",false)
 	this:AddPanel("HelpSettlement","cl_OnscreenHelpPanel","gui/Hud/Helppanels/settlement.gui",false)
 	this:AddPanel("HelpText","cl_OnscreenHelpPanel","gui/Hud/Helppanels/text.gui",false)
 	this:AddPanel("HelpShip","cl_OnscreenHelpPanel","gui/Hud/Helppanels/ship.gui",false)
 	
	-- Messagebox will be shown at this z-range
 	 	 	
 	this:AddPanel("ContextMenu","cl_ContextMenu","",false)
 	
 	-- sheets
 	this:AddPanel("SheetNavi","cl_SheetNavigation","gui/Hud/sheet_navi.gui",false)
 	this:AddPanel("SheetHeader","cl_SheetHeader","gui/Hud/sheet_header.gui",false)
 	
 	this:AddPanel("Connection2","cl_InventoryPanel","gui/Hud/panel_connection_02.gui",false)
 	this:AddPanel("InventorySheet","cl_InventorySheet","gui/Hud/panel_inventorysheet.gui",false)
 	this:AddPanel("TransportSheet","cl_TransportSheet","gui/Hud/panel_transportsheet.gui",false)
 	this:AddPanel("ShipSheet","cl_ShipSheet","gui/Hud/panel_shipsheet.gui",false)
 	this:AddPanel("Connection1","cl_InventoryPanel","gui/Hud/panel_connection_01.gui",false)
 	this:AddPanel("Connection3","cl_InventoryPanel","gui/Hud/panel_connection_03.gui",false)
 	this:AddPanel("StoreSheet","cl_StoreSheet","gui/Hud/panel_storesheet.gui",false)
 	this:AddPanel("ProductionSheet","cl_ProductionSheet","gui/Hud/panel_productionsheet.gui",false)
 	this:AddPanel("MarketInventorySheet","cl_MarketInventorySheet","gui/Hud/panel_marketinventory2.gui",false)
 	this:AddPanel("BuildBuildingPatron","cl_BuildBuildingSheet","gui/Hud/panel_buildbuildingsheet_workshop.gui",false)
	this:AddPanel("BuildBuildingArtisan","cl_BuildBuildingSheet","gui/Hud/panel_buildbuildingsheet_workshop.gui",false)
	this:AddPanel("BuildBuildingScholar","cl_BuildBuildingSheet","gui/Hud/panel_buildbuildingsheet_workshop.gui",false)
	this:AddPanel("BuildBuildingChiseler","cl_BuildBuildingSheet","gui/Hud/panel_buildbuildingsheet_workshop.gui",false)
	this:AddPanel("BuildBuildingMisc","cl_BuildBuildingSheet","gui/Hud/panel_buildbuildingsheet_workshop.gui",false)
		
 	-- Buttons have to be above of the sheets. Map has to be above of buttons. News have to be above the buttons
 	--this:AddPanel("MiniMapPanel","cl_MiniMapPanel","gui/Hud/panel_minimap.gui")
 	this:AddPanel("IndoorMapPanel","cl_IndoorMap","gui/Hud/panel_indoormap.gui")
 	
 	this:AddPanel("NewsPanel","cl_NewsPanel","gui/Hud/panel_news.gui",true)
	this:AddPanel("ActionsPanel","cl_ActionsPanel2","gui/Hud/panel_actions2.gui")
	this:AddPanel("MeasureMessagePanel","cl_MeasureMessagePanel","gui/Hud/panel_measuremessage.gui",true,true)
	
	
 		
 	-- start sheets
 	this:AddPanel("AdministrateDiplomacySheet", "cl_AdministrateDiplomacySheet", "gui/Hud/panel_diplomacy.gui",false)
	this:AddPanel("ImportantPersons", "cl_OverviewImportantPersonsSheet", "gui/Hud/panel_importantpersons.gui",false)
	this:AddPanel("OverviewBuildings","cl_OverviewBuildingsSheet","gui/Hud/panel_overviewbuildings2.gui",false)
	
	-- added for buildings for sale
	this:AddPanel("OverviewBuildingsForSaleSheet","cl_OverviewBuildingsForSaleSheet","gui/Hud/panel_overviewbuildingsforsale.gui",false)
	
	this:AddPanel("BuildingUpgradeSheet","cl_BuildingUpgradeTreePanel","gui/Hud/panel_upgradesheet.gui",false)
 	this:AddPanel("ShowCreditSheet","cl_CreditSheet","gui/Hud/panel_takecredit_final.gui", false)
	this:AddPanel("ChangeAppearancePanel","cl_ChangeAppearancePanel","gui/Hud/panel_changeappearance.gui", false)
 	this:AddPanel("_AdministrateBuilding","cl_AdministrateBuilding","gui/Hud/panel_AdministrateBuilding.gui", false)
 	this:AddPanel("_UpgradeShipSheet", "cl_UpgradeShipSheet", "gui/Hud/panel_upgradeship.gui",false)
	--this:AddPanel("MessageBoxPanel","cl_MessageBoxPanel","gui/Hud/panel_messagebox.gui",false)
	
		
	this:AddPanel("_BuildingLevelTreeSheet","cl_BuildingLevelTreePanel","gui/Hud/panel_buildinglevelup.gui",false)
	this:AddPanel("DynastyStatusSheet","cl_DynastyStatusSheet","gui/Hud/panel_dynastystatussheet.gui",false)
	
	this:AddPanel("DiarySheet","cl_DiarySheet","gui/Hud/panel_diarysheet.gui",false)
	this:AddPanel("DatebookSheet","cl_DatebookSheet","gui/Hud/panel_datebooksheet.gui",false)
	this:AddPanel("EvidenceSheet","cl_MemorySheet","gui/Hud/panel_evidencesheet.gui",false)
	this:AddPanel("QuestbookSheet","cl_QuestbookSheet","gui/Hud/panel_questbooksheet.gui",false)
	
	this:AddPanel("AbilitySheet","cl_AbilitySheet","gui/Hud/panel_abilitysheet.gui",false)
	this:AddPanel("CharacterSheet","cl_CharacterSheet","gui/Hud/panel_charactersheet.gui",false)
	this:AddPanel("FamilyTreeSheet","cl_FamilyTreeSheet","gui/Hud/panel_familytreesheet.gui",false)
	this:AddPanel("MapSheet","cl_MapSheet","gui/Hud/panel_mapsheet.gui",false)
	this:AddPanel("_MessageFilterSheet","cl_MessageFilterSheet","gui/Hud/panel_messagefiltersheet.gui",false)
	this:AddPanel("_BuyCartSheet","cl_BuyCartSheet","gui/Hud/panel_buycart.gui",false)
	this:AddPanel("_BuyShipSheet","cl_BuyCartSheet","gui/Hud/panel_buyship.gui",false)
    this:AddPanel("_CityLawsSheet","cl_CityLawsSheet","gui/Hud/panel_citylaws.gui",false)
    this:AddPanel("_CityScheduleSheet","cl_CityScheduleSheet","gui/Hud/panel_cityschedule.gui",false)
	
	this:AddPanel("StatisticsBalanceLast","cl_BalanceSheet","gui/Hud/panel_balancesheet2.gui",false)
	this:AddPanel("StatisticsBalanceTotal","cl_BalanceSheet","gui/Hud/panel_balancesheet2.gui",false)	
	this:AddPanel("StatisticsSheetGold","cl_StatisticsSheet","gui/Hud/panel_statisticsheet.gui",false)
	this:AddPanel("StatisticsSheetAsset","cl_StatisticsSheet","gui/Hud/panel_statisticsheet.gui",false)
	this:AddPanel("StatisticsSheetSkill","cl_StatisticsSheet","gui/Hud/panel_statisticsheet.gui",false)
	this:AddPanel("StatisticsSheetAlign","cl_StatisticsSheet","gui/Hud/panel_statisticsheet.gui",false)
	this:AddPanel("StatisticsSheetPoints","cl_StatisticsSheet","gui/Hud/panel_statisticsheet.gui",false)
	
	this:AddPanel("_PamphletSheet","cl_PamphletSheet","gui/Hud/panel_pamphletsheet.gui",false)
	
	-- end sheets
	
	this:AddPanel("CharactersPanel","cl_CharactersPanel","gui/Hud/panel_characters.gui")
	this:AddPanel("ProgressPanel","cl_ProgressPanel","gui/Hud/panel_loverprogress.gui",false)
	this:AddPanel("MFDPanel","cl_MFD","gui/Hud/panel_mfd.gui")
	this:AddPanel("HirePanel","cl_HirePanel","gui/Hud/panel_treesheet.gui", false)
	

    -- Cutscene Panels
    this:AddPanel("TrialPanel","cl_TrialPanel","gui/Hud/panel_charge.gui",false,true)
    this:AddPanel("OfficeApplicationPanel","cl_OfficeApplicationPanel","gui/Hud/panel_officeapplication.gui",false,true)
    this:AddPanel("OfficeDepositionPanel","cl_OfficeDepositionPanel","gui/Hud/panel_officedeposition.gui",false,true)
    
	
	
	
	this:AddPanel("ImpactIconPanel","cl_ImpactIconPanel","gui/Hud/panel_impacticon.gui")
	
	-- Header
	this:AddPanel("HeaderName","cl_DatePanel","gui/Hud/panel_header_name.gui")  	
	this:AddPanel("HeaderSeason","cl_DatePanel","gui/Hud/panel_header_season.gui")  
	this:AddPanel("HeaderMoney","cl_DatePanel","gui/Hud/panel_header_money.gui")  
	this:AddPanel("HeaderDecorator","cl_StaticPanel","gui/Hud/panel_header_leiste.gui")
	
	this:AddPanel("RenderViewPanel","cl_RenderViewPanel","gui/Hud/panel_3dview.gui",true)
	this:AddPanel("MultiselectionPanel","cl_MultiselectionPanel","gui/Hud/panel_multiselection.gui")
	
	this:AddPanel("CountdownPanel","cl_CountdownPanel","gui/Hud/panel_countdown.gui",true,false)
	
	this:AddPanel("QuestlogPanel","cl_QuestlogPanel","gui/Hud/panel_questlog.gui",false)
	this:AddPanel("NPCPanel","cl_NPCPanel","gui/Hud/panel_npc.gui")
	--this:AddPanel("MessagePanel","cl_MessagePanel","gui/Hud/panel_message.gui")
	
		-- body
	this:AddPanel("ButtonPanelLeft","cl_ButtonPanel","gui/Hud/panel_down_left.gui")
	this:AddPanel("ButtonPanelRight","cl_ButtonPanel","gui/Hud/panel_down_right.gui")
	this:AddPanel("ButtonPanelDecorator","cl_StaticPanel","gui/Hud/panel_down_middle.gui")
	
	
	this:AddPanel("DialogPanel","cl_DialogPanel","gui/Hud/panel_dialog.gui",true,true)
	
	this:AddPanel("StatusPanel","cl_StatusPanel","",true,true)
	
	this:AddPanel("LetterBoxPanel","cl_LetterBoxPanel","gui/Hud/panel_letterbox.gui",false,true)
	
	this:AddPanel("UserInputPanel","cl_UserInputPanel","",true,true)
	
	-- define Tabgroups
	-- BuildBuildin
	this:AddSheetToTabGroup("BuildBuilding","BuildBuildingPatron","@L_CHARACTERS_1_CLASSES_patron_NAME_+0")
	this:AddSheetToTabGroup("BuildBuilding","BuildBuildingArtisan","@L_CHARACTERS_1_CLASSES_artisan_NAME_+0")
	this:AddSheetToTabGroup("BuildBuilding","BuildBuildingScholar","@L_CHARACTERS_1_CLASSES_scholar_NAME_+0")
	this:AddSheetToTabGroup("BuildBuilding","BuildBuildingChiseler","@L_CHARACTERS_1_CLASSES_chiseler_NAME_+0")
	this:AddSheetToTabGroup("BuildBuilding","BuildBuildingMisc","@L_BUILDBUILDING_MISC_+0")
	this:SetTabGroupHeader("BuildBuilding","@L_BUILDBUILDING_+1")
	
	-- Statistics
	this:AddSheetToTabGroup("Statistics","StatisticsBalanceLast","@L_BALANCE_PANELNAMES_+0")
	this:AddSheetToTabGroup("Statistics","StatisticsBalanceTotal","@L_BALANCE_PANELNAMES_+1")		
	this:AddSheetToTabGroup("Statistics","StatisticsSheetGold","@L_GAMESTATISTICS_FINANCE_+0")
	this:AddSheetToTabGroup("Statistics","StatisticsSheetAsset","@L_GAMESTATISTICS_ASSETS_+0")
	this:AddSheetToTabGroup("Statistics","StatisticsSheetSkill","@L_GAMESTATISTICS_SKILLLEVEL_+0")
	this:AddSheetToTabGroup("Statistics","StatisticsSheetAlign","@L_GAMESTATISTICS_ALIGNMENT_+0")
	this:AddSheetToTabGroup("Statistics","StatisticsSheetPoints","@L_GAMESTATISTICS_POINTS_+0")
	this:SetTabGroupHeader("Statistics","@L_GAMESTATISTICS_HEADLINE_+0")
		
	-- DiarySheet
	this:AddSheetToTabGroup("Diary","DiarySheet" 		,"@L_DIARY_+0")
	this:AddSheetToTabGroup("Diary","DatebookSheet" 	,"@L_DATEBOOK_+0")
	this:AddSheetToTabGroup("Diary","EvidenceSheet"		,"@L_EVIDENCES_+0")
	this:AddSheetToTabGroup("Diary","QuestbookSheet","@L_QUESTBOOK_+0")
	this:SetTabGroupHeader("Diary","@L_DIARY_+1")
	
	-- character sheet
	this:AddSheetToTabGroup("Character","CharacterSheet","@L_CHARACTER_+0")
	this:AddSheetToTabGroup("Character","AbilitySheet","@L_ABILITIES_+0")
	this:AddSheetToTabGroup("Character","FamilyTreeSheet","@L_BLOODLINE_HEADLINE_+0")
	this:SetTabGroupHeader("Character","@L_DYNASTY_+1")
	
	-- important units sheet
	this:AddSheetToTabGroup("Important","ImportantPersons","@L_IMPORTANTPERSONS_HEAD_+0")
	this:AddSheetToTabGroup("Important","OverviewBuildings","@L_INTERFACE_OVERVIEWBUILDINGS_HEAD_+0")
	this:SetTabGroupHeader("Important","@L_INTERFACE_IMPORTANT_+1")
		
end

function CleanUp() 	
end

