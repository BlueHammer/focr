-- This is the entry-point to your game mode and should be used primarily to precache models/particles/sounds/etc

require('internal/util')
require('gamemode')
require('timers')
require('CosmeticLib')
require('stats')



function Precache( context )
--[[
  This function is used to precache resources/units/items/abilities that will be needed
  for sure in your game and that will not be precached by hero selection.  When a hero
  is selected from the hero selection screen, the game will precache that hero's assets,
  any equipped cosmetics, and perform the data-driven precaching defined in that hero's
  precache{} block, as well as the precache{} block for any equipped abilities.

  See GameMode:PostLoadPrecache() in gamemode.lua for more information
  ]]
	GameRules.model_lookup = {}
	GameRules.model_lookup["npc_dota_hero_storm_spirit"] = "models/enel/enel2.vmdl"
	GameRules.model_lookup["npc_dota_hero_juggernaut"] = "models/ichigo/ichigo1.vmdl"
	GameRules.model_lookup["npc_dota_hero_dragon_knight"] = "models/saber/saber.vmdl"
	GameRules.model_lookup["npc_dota_hero_kunkka"] = "models/zoro/hero_zoro_base.vmdl"
	GameRules.model_lookup["npc_dota_hero_bloodseeker"] = "models/shikinanaya/shikinanaya.vmdl"
	GameRules.model_lookup["npc_dota_hero_undying"] = "models/erenjaeger/eren.vmdl"
	GameRules.model_lookup["npc_dota_hero_dark_seer"] = "models/goku/goku.vmdl"
	GameRules.model_lookup["npc_dota_hero_riki"] = "models/naruto/naruto.vmdl"
	GameRules.model_lookup["npc_dota_hero_earthshaker"] = "models/rocklee/rocklee.vmdl"
	for k, v in pairs( GameRules.model_lookup ) do
		PrecacheResource( "model", v, context )
	end

  DebugPrint("[BAREBONES] Performing pre-load precache")

  -- Particles can be precached individually or by folder
  -- It it likely that precaching a single particle system will precache all of its children, but this may not be guaranteed
  PrecacheResource( "model", "models/development/invisiblebox.vmdl", context )
  PrecacheResource( "particle", "particles/naruto/odama_proejctile.vpcf", context )

  -- Models can also be precached by folder or individually


  -- Sounds can precached here like anything else

  -- Entire items can be precached by name
  -- Abilities can also be precached in this way despite the name
  PrecacheItemByNameSync("item_duel", context)

  -- Entire heroes (sound effects/voice/models/particles) can be precached with PrecacheUnitByNameSync
  -- Custom units from npc_units_custom.txt can also have all of their abilities and precache{} blocks precached in this way
  PrecacheUnitByNameSync("unit_spiderling", context)
  PrecacheUnitByNameSync("unit_undeads", context)
  PrecacheUnitByNameSync("unit_skeleton", context)
  PrecacheUnitByNameSync("unit_general", context)
  PrecacheUnitByNameSync("unit_commander", context)
  PrecacheUnitByNameSync("unit_knight", context)
  PrecacheUnitByNameSync("unit_mage", context)
  PrecacheUnitByNameSync("unit_rock_golem", context)
  PrecacheUnitByNameSync("unit_spellcaster", context)
  PrecacheUnitByNameSync("unit_arachnid", context)
  PrecacheUnitByNameSync("unit_death_mage", context)
  PrecacheUnitByNameSync("unit_fallen_mage", context)
  PrecacheUnitByNameSync("unit_primal_furbolg", context)
  PrecacheUnitByNameSync("unit_mutant_golem", context)
  PrecacheUnitByNameSync("unit_primal_werebeast", context)
  PrecacheUnitByNameSync("unit_infernal", context)
  PrecacheUnitByNameSync("unit_shiva", context)
  PrecacheUnitByNameSync("unit_atropos", context)
  PrecacheUnitByNameSync("unit_harpy", context)
  PrecacheUnitByNameSync("unit_elder_drake", context)
  PrecacheUnitByNameSync("unit_elder_skeleton", context)
  PrecacheUnitByNameSync("unit_ancient_demon", context)
  PrecacheUnitByNameSync("unit_ancient_behemoth", context)
  PrecacheUnitByNameSync("unit_boss_1", context)
  PrecacheUnitByNameSync("unit_boss_2", context)
  PrecacheUnitByNameSync("unit_boss_3", context)
  PrecacheUnitByNameSync("unit_boss_4", context)
  PrecacheUnitByNameSync("unit_boss_5", context)
  PrecacheUnitByNameSync("unit_boss_6", context)
  PrecacheUnitByNameSync("unit_boss_7", context)
  PrecacheUnitByNameSync("unit_boss_8", context)
  PrecacheUnitByNameSync("unit_boss_1a", context)
  PrecacheUnitByNameSync("unit_boss_2a", context)
  PrecacheUnitByNameSync("unit_boss_3a", context)
  PrecacheUnitByNameSync("unit_boss_4a", context)
  PrecacheUnitByNameSync("unit_boss_5a", context)
  PrecacheUnitByNameSync("unit_boss_6a", context)
  PrecacheUnitByNameSync("unit_boss_7a", context)
  PrecacheUnitByNameSync("unit_boss_8a", context)
end

function openObstruction(eventInfo)
	local entity = eventInfo.entindex_killed
	if not (Entities:FindByName( nil, "cornergate1" ) == nil) then
		gate1 = Entities:FindByName( nil, "cornergate1" ):GetEntityIndex()
	end
	if not (Entities:FindByName( nil, "cornergate2" ) == nil) then
		gate2 = Entities:FindByName( nil, "cornergate2" ):GetEntityIndex()
	end
	if not (Entities:FindByName( nil, "cornergate3" ) == nil) then
		gate3 = Entities:FindByName( nil, "cornergate3" ):GetEntityIndex()
	end
	if not (Entities:FindByName( nil, "cornergate4" ) == nil) then
		gate4 = Entities:FindByName( nil, "cornergate4" ):GetEntityIndex()
	end
	if not (Entities:FindByName( nil, "bossgate1" ) == nil) then
		gate5 = Entities:FindByName( nil, "bossgate1" ):GetEntityIndex()
	end
	if not (Entities:FindByName( nil, "bossgate2" ) == nil) then
		gate6 = Entities:FindByName( nil, "bossgate2" ):GetEntityIndex()
	end		
	
	local ob1 = Entities:FindByName( nil, "ob1" )
	local ob2 = Entities:FindByName( nil, "ob2" )
	local ob3 = Entities:FindByName( nil, "ob3" )
	local ob4 = Entities:FindByName( nil, "ob4" )
	local ob5 = Entities:FindByName( nil, "ob5" )
	local ob6 = Entities:FindByName( nil, "ob6" )
	local ob7 = Entities:FindByName( nil, "ob7" )
	local ob8 = Entities:FindByName( nil, "ob8" )
	local ob9 = Entities:FindByName( nil, "ob9" )
	local ob10 = Entities:FindByName( nil, "ob10" )
	local ob11 = Entities:FindByName( nil, "ob11" )
	local ob12 = Entities:FindByName( nil, "ob12" )
	local ob13 = Entities:FindByName( nil, "ob13" )
	local ob14 = Entities:FindByName( nil, "ob14" )
	local ob15 = Entities:FindByName( nil, "ob15" )
	local ob16 = Entities:FindByName( nil, "ob16" )
	local ob17 = Entities:FindByName( nil, "ob17" )
	local ob18 = Entities:FindByName( nil, "ob18" )
	local ob19 = Entities:FindByName( nil, "ob19" )
	local ob20 = Entities:FindByName( nil, "ob20" )
	local ob21 = Entities:FindByName( nil, "ob21" )
	local ob22 = Entities:FindByName( nil, "ob22" )
	local ob23 = Entities:FindByName( nil, "ob23" )
	local ob24 = Entities:FindByName( nil, "ob24" )
	
	local bob1 = Entities:FindByName( nil, "bob1" )
	local bob2 = Entities:FindByName( nil, "bob2" )
	local bob3 = Entities:FindByName( nil, "bob3" )
	local bob4 = Entities:FindByName( nil, "bob4" )
	local bob5 = Entities:FindByName( nil, "bob5" )
	local bob6 = Entities:FindByName( nil, "bob6" )
	local bob7 = Entities:FindByName( nil, "bob7" )
	local bob8 = Entities:FindByName( nil, "bob8" )
	local bob9 = Entities:FindByName( nil, "bob9" )
	local bob10 = Entities:FindByName( nil, "bob10" )	
		
	if entity == gate1 then
  Timers:CreateTimer({
    endTime = 6.2,
    callback = function()
		ob1:SetEnabled(false,false)
		ob2:SetEnabled(false,false)
		ob3:SetEnabled(false,false)
		ob4:SetEnabled(false,false)
		ob5:SetEnabled(false,false)
		ob6:SetEnabled(false,false)	
    end
  })	
	elseif entity == gate2 then
  Timers:CreateTimer({
    endTime = 6.2,
    callback = function()
		ob7:SetEnabled(false,false)
		ob8:SetEnabled(false,false)
		ob9:SetEnabled(false,false)
		ob10:SetEnabled(false,false)
		ob11:SetEnabled(false,false)
		ob12:SetEnabled(false,false)	
    end
  })	
	elseif entity == gate3 then 
  Timers:CreateTimer({
    endTime = 6.2,
    callback = function()
		ob13:SetEnabled(false,false)
		ob14:SetEnabled(false,false)
		ob15:SetEnabled(false,false)
		ob16:SetEnabled(false,false)
		ob17:SetEnabled(false,false)
		ob18:SetEnabled(false,false)	
    end
  })	
	elseif entity == gate4 then
  Timers:CreateTimer({
    endTime = 6.2,
    callback = function()
		ob19:SetEnabled(false,false)
		ob20:SetEnabled(false,false)
		ob21:SetEnabled(false,false)
		ob22:SetEnabled(false,false)
		ob23:SetEnabled(false,false)
		ob24:SetEnabled(false,false)
	end
  })
	elseif entity == gate5 then
  Timers:CreateTimer({
    endTime = 6.2,
    callback = function()
		bob1:SetEnabled(false,false)
		bob2:SetEnabled(false,false)
		bob3:SetEnabled(false,false)
		bob4:SetEnabled(false,false)
		bob5:SetEnabled(false,false)
	end
  })
	elseif entity == gate6 then
  Timers:CreateTimer({
    endTime = 6.2,
    callback = function()
		bob6:SetEnabled(false,false)
		bob7:SetEnabled(false,false)
		bob8:SetEnabled(false,false)
		bob9:SetEnabled(false,false)
		bob10:SetEnabled(false,false)
	end
  })	
	end
end
-- Create the game mode when we activate
function Activate()
  GameRules.GameMode = GameMode()
  GameRules.GameMode:InitGameMode()
  ListenToGameEvent("entity_killed", openObstruction, nil)
end
