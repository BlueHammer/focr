-- This is the primary barebones gamemode script and should be used to assist in initializing your game mode


-- Set this to true if you want to see a complete debug output of all events/processes done by barebones
-- You can also change the cvar 'barebones_spew' at any time to 1 or 0 for output/no output
BAREBONES_DEBUG_SPEW = true 

if GameMode == nil then
    DebugPrint( '[BAREBONES] creating barebones game mode' )
    _G.GameMode = class({})
end

-- This library allow for easily delayed/timed actions
require('timers')
-- This library can be used for advancted physics/motion/collision of units.  See PhysicsReadme.txt for more information.
require('libraries/physics')
-- This library can be used for advanced 3D projectile systems.
require('libraries/projectiles')
-- This library can be used for sending panorama notifications to the UIs of players/teams/everyone
require('libraries/notifications')
-- This library can be used for starting customized animations on units from lua
require('libraries/animations')

-- These internal libraries set up barebones's events and processes.  Feel free to inspect them/change them if you need to.
require('internal/gamemode')
require('internal/events')

-- settings.lua is where you can specify many different properties for your game mode and is one of the core barebones files.
require('settings')
-- events.lua is where you can specify the actions to be taken when any event occurs and is one of the core barebones files.
require('events')
require('duel')

--[[
  This function should be used to set up Async precache calls at the beginning of the gameplay.

  In this function, place all of your PrecacheItemByNameAsync and PrecacheUnitByNameAsync.  These calls will be made
  after all players have loaded in, but before they have selected their heroes. PrecacheItemByNameAsync can also
  be used to precache dynamically-added datadriven abilities instead of items.  PrecacheUnitByNameAsync will 
  precache the precache{} block statement of the unit and all precache{} block statements for every Ability# 
  defined on the unit.

  This function should only be called once.  If you want to/need to precache more items/abilities/units at a later
  time, you can call the functions individually (for example if you want to precache units in a new wave of
  holdout).

  This function should generally only be used if the Precache() function in addon_game_mode.lua is not working.
]]
function GameMode:PostLoadPrecache()
  DebugPrint("[BAREBONES] Performing Post-Load precache")    
  --PrecacheItemByNameAsync("item_example_item", function(...) end)
  --PrecacheItemByNameAsync("example_ability", function(...) end)

  --PrecacheUnitByNameAsync("npc_dota_hero_viper", function(...) end)
  --PrecacheUnitByNameAsync("npc_dota_hero_enigma", function(...) end)
end

--[[
  This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
  It can be used to initialize state that isn't initializeable in InitGameMode() but needs to be done before everyone loads in.
]]
function GameMode:OnFirstPlayerLoaded()
  DebugPrint("[BAREBONES] First Player has loaded")
  innateAbilityTable = {}
	
end

--[[
  This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
  It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]
function GameMode:OnAllPlayersLoaded()
  DebugPrint("[BAREBONES] All Players have loaded into the game")
  GameRules.APPLIER = CreateItem("item_duel", nil, nil)
  local unitGate1 = Entities:FindByName( nil, "cornergate1" )
  local unitGate2 = Entities:FindByName( nil, "cornergate2" )
  local unitGate3 = Entities:FindByName( nil, "cornergate3" )
  local unitGate4 = Entities:FindByName( nil, "cornergate4" )
  local unitGate5 = Entities:FindByName( nil, "bossgate1" )
  local unitGate6 = Entities:FindByName( nil, "bossgate2" )
  
  unitGate1:RemoveModifierByName("modifier_invulnerable")
  unitGate2:RemoveModifierByName("modifier_invulnerable")
  unitGate3:RemoveModifierByName("modifier_invulnerable")
  unitGate4:RemoveModifierByName("modifier_invulnerable")
  unitGate5:RemoveModifierByName("modifier_invulnerable")
  unitGate6:RemoveModifierByName("modifier_invulnerable")
  
  DUEL = false

  GameRules:GetGameModeEntity():SetModifyGoldFilter( Dynamic_Wrap( GameMode, "FilterModifyGold" ), self )
  GameRules.PlayerBountyEligibility = {}

end

--function GameMode:OnEntityKilled( keys )
--print("PRINTING KEYS")
--DeepPrintTable( keys )
--print("SOMEONE JUST DIED")
--local killer = EntIndexToHScript(keys.entindex_attacker)
--local killed = EntIndexToHScript(keys.entindex_killed)
--local killerID = killer:GetPlayerOwner():GetPlayerID()
--local stringID = tostring(killerID) 
--print(killerID)
--if killed:IsRealHero() and not(killed:IsIllusion()) and not(killed:IsReincarnating()) then
--	if GameRules.PlayerBountyEligibility[stringID] == nil then
--		GameRules.PlayerBountyEligibility[stringID] = 0
--	end
--	GameRules.PlayerBountyEligibility[stringID] = 1
--end
--end

function GameMode:FilterModifyGold( filterTable )
print("printing FILTERTAbLE")
PrintTable(filterTable)
print("someone modify gold")

--if filterTable["reason_const"] == DOTA_ModifyGold_Death then
--	return filterTable["gold"] == 0 
--end
--print("CHECKING FOR VALUE PRIOR IF")
--print(GameRules.PlayerBountyEligibility[tostring(filterTable["player_id_const"])])
if GameRules.PlayerBountyEligibility[filterTable["player_id_const"]] == nil then
	GameRules.PlayerBountyEligibility[filterTable["player_id_const"]] = 0
end

filterTable["reliable"] = 0
local playerKills = PlayerResource:GetKills(filterTable["player_id_const"])
if filterTable["reason_const"] == DOTA_ModifyGold_HeroKill then
	if filterTable["gold"] ~= 0 then
		if GameRules.PlayerBountyEligibility[filterTable["player_id_const"]] < playerKills then
			filterTable["gold"] = 500
			GameRules.PlayerBountyEligibility[filterTable["player_id_const"]] = GameRules.PlayerBountyEligibility[filterTable["player_id_const"]] + 1
		else
			filterTable["gold"] = 0
		end
	end
end

return true
end

function GameMode:OnNPCSpawned(keys)
	--print("[PMP] NPC Spawned")
	--DeepPrintTable(keys)
	local heroID = keys.entindex
	local npc = EntIndexToHScript(keys.entindex)
	local spawnPoint = Entities:FindByName( nil, "unitChecker"):GetAbsOrigin()

	if npc:IsRealHero() and npc.bFirstSpawned == nil then
		npc.bFirstSpawned = true
		table.insert(GameRules.heroList, npc)
		GameMode:ModifyStatBonuses(npc)
		
		Timers:CreateTimer( 0.03, function()
			if not npc:IsIllusion() then
				FindClearSpaceForUnit(npc, spawnPoint, false)
				SendToConsole("dota_camera_center")
			end
		return nil
		end
		)

		
		for k, v in pairs( GameRules.HeroInit ) do
			print(k)
			if npc:GetUnitName() == k then
				do v(npc)
				end
			end
		end
	end
	
	Timers:CreateTimer({
    endTime = 0.05,
    callback = function()
		local hero = EntIndexToHScript( keys.entindex )
		local model_name = ""

      -- Check if npc is hero
		if not hero:IsHero() then return end

      -- Getting model name
		if GameRules.model_lookup[ hero:GetName() ] ~= nil and hero:GetModelName() ~= GameRules.model_lookup[ hero:GetName() ] then
			model_name = GameRules.model_lookup[ hero:GetName() ]
		else
			model_name = GameRules.model_lookup[ hero:GetName() ]
		end

      -- Check if it's correct format
		
		local model = hero:FirstMoveChild()
		while model ~= nil do
			if model:GetClassname() == "dota_item_wearable" then
				model:AddEffects(EF_NODRAW) -- Set model hidden
			end
        model = model:NextMovePeer()
		end
		
		if hero:GetModelName() == "models/development/invisiblebox.vmdl" then 
		hero:SetModel( model_name )
		hero:SetOriginalModel( model_name )
		Timers:CreateTimer({
		endTime = 0.05,
		callback = function()
		hero:RespawnUnit()
		end
		})
		end
		

    end
})
    --ApplyModifier(npc, "modifier_attackable")

    -- Ignore default gold bounty

end

--[[
  This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
  gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
  is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]
function GameMode:OnGameInProgress()
  DebugPrint("[BAREBONES] The game has officially begun")
  
	Timers:CreateTimer({
    endTime = 300,
    callback = function()
	duelStart()
    end
})
  
	Timers:CreateTimer({
    endTime = 360,
    callback = function()
	local point1 = Entities:FindByName(nil, "bossspawn1"):GetAbsOrigin()
	local point2 = Entities:FindByName(nil, "bossspawn2"):GetAbsOrigin()
	local unit1 = CreateUnitByName("unit_boss_1", point1, true, nil, nil, DOTA_TEAM_NEUTRALS)
	unit1:SetHullRadius(56)
	local unit2 = CreateUnitByName("unit_boss_1a", point2, true, nil, nil, DOTA_TEAM_NEUTRALS)
	unit2:SetHullRadius(56)
    end
})

    local repeat_interval = 30 -- Rerun this timer every *repeat_interval* game-time seconds
    local start_after = 0 -- Start this timer *start_after* game-time seconds later
	local startAfter = 0
	local thinkerInterval = 2
	local unitsLocation = {}
	
	
	function SpawnCreeps1()
	local point1 = Entities:FindByName( nil, "spawner1"):GetAbsOrigin()
	local point2 = Entities:FindByName( nil, "spawner2"):GetAbsOrigin()
	local point3 = Entities:FindByName( nil, "spawner3"):GetAbsOrigin()
	local point4 = Entities:FindByName( nil, "spawner4"):GetAbsOrigin()
	local point5 = Entities:FindByName( nil, "spawner5"):GetAbsOrigin()
	local point6 = Entities:FindByName( nil, "spawner6"):GetAbsOrigin()
	local point7 = Entities:FindByName( nil, "spawner7"):GetAbsOrigin()
	local point8 = Entities:FindByName( nil, "spawner8"):GetAbsOrigin()
	local point9 = Entities:FindByName( nil, "spawner9"):GetAbsOrigin()
	local point10 = Entities:FindByName( nil, "spawner10"):GetAbsOrigin()
	local point11 = Entities:FindByName( nil, "spawner11"):GetAbsOrigin()
	local point12 = Entities:FindByName( nil, "spawner12"):GetAbsOrigin()
	
		local units_to_spawn1 = 4
    for i=1, units_to_spawn1 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_lesser_skeleton", point1+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin
		 unit:SetHullRadius(56)		 
      end)
    end
	
		local units_to_spawn2 = 4
    for i=1, units_to_spawn2 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_gnoll_hunter", point2+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin		
		 unit:SetHullRadius(56)
      end)
    end
	
		local units_to_spawn3 = 4
    for i=1, units_to_spawn3 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_spiderling", point3+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin		
		 unit:SetHullRadius(56)
      end)
    end
	
		local units_to_spawn4 = 2
    for i=1, units_to_spawn4 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_arachnid", point4+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin		
		 unit:SetHullRadius(56)
      end)
    end
	
		local units_to_spawn5 = 4
    for i=1, units_to_spawn5 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_lesser_skeleton", point5+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin		
		 unit:SetHullRadius(56)
      end)
    end
	
		local units_to_spawn6 = 4
    for i=1, units_to_spawn6 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_gnoll_hunter", point6+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin		
		 unit:SetHullRadius(56)
      end)
    end
	
		local units_to_spawn7 = 4
    for i=1, units_to_spawn7 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_spiderling", point7+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin		
		 unit:SetHullRadius(56)
      end)
    end
	
		local units_to_spawn8 = 2
    for i=1, units_to_spawn8 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_arachnid", point8+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin		
		 unit:SetHullRadius(56)
      end)
    end
	
		local units_to_spawn9 = 4
    for i=1, units_to_spawn9 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_lesser_skeleton", point9+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin		
		 unit:SetHullRadius(56)
      end)
    end
	

	local units_to_spawn10 = 4
    for i=1, units_to_spawn10 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_gnoll_hunter", point10+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin		
		 unit:SetHullRadius(56)
      end)
    end
	
		local units_to_spawn11 = 4
    for i=1, units_to_spawn11 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_spiderling", point11+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin		
		 unit:SetHullRadius(56)
      end)
    end
	
		local units_to_spawn12 = 2
    for i=1, units_to_spawn12 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_arachnid", point12+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin		
		 unit:SetHullRadius(56)
      end)
    end
end
	
	function SpawnCreeps2()
	local point1 = Entities:FindByName( nil, "spawner1"):GetAbsOrigin()
	local point2 = Entities:FindByName( nil, "spawner2"):GetAbsOrigin()
	local point3 = Entities:FindByName( nil, "spawner3"):GetAbsOrigin()
	local point4 = Entities:FindByName( nil, "spawner4"):GetAbsOrigin()
	local point5 = Entities:FindByName( nil, "spawner5"):GetAbsOrigin()
	local point6 = Entities:FindByName( nil, "spawner6"):GetAbsOrigin()
	local point7 = Entities:FindByName( nil, "spawner7"):GetAbsOrigin()
	local point8 = Entities:FindByName( nil, "spawner8"):GetAbsOrigin()
	local point9 = Entities:FindByName( nil, "spawner9"):GetAbsOrigin()
	local point10 = Entities:FindByName( nil, "spawner10"):GetAbsOrigin()
	local point11 = Entities:FindByName( nil, "spawner11"):GetAbsOrigin()
	local point12 = Entities:FindByName( nil, "spawner12"):GetAbsOrigin()
	
	local units_to_spawn1 = 5
    for i=1, units_to_spawn1 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_skeleton", point1+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin	
		 unit:SetHullRadius(56)
      end)
    end
	
		local units_to_spawn2 = 1
    for i=1, units_to_spawn2 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_general", point1+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin	
		 unit:SetHullRadius(56)
      end)
    end
	
		local units_to_spawn3 = 5
    for i=1, units_to_spawn3 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_spellcaster", point2+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin	
		 unit:SetHullRadius(56)
      end)
    end
	
		local units_to_spawn4 = 1
    for i=1, units_to_spawn4 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_mage", point2+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin	
		 unit:SetHullRadius(56)
      end)
    end
	
		local units_to_spawn5 = 6
    for i=1, units_to_spawn5 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_rock_golem", point3+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin	
		 unit:SetHullRadius(56)
      end)
    end
	
		local units_to_spawn6 = 1
    for i=1, units_to_spawn6 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_commander", point4+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin	
		 unit:SetHullRadius(56)
      end)
    end
	
		local units_to_spawn7 = 5
    for i=1, units_to_spawn7 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_knight", point4+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin	
		 unit:SetHullRadius(56)
      end)
    end
	
		local units_to_spawn8 = 5
    for i=1, units_to_spawn8 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_spellcaster", point5+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin	
		 unit:SetHullRadius(56)
      end)
    end
	
		local units_to_spawn9 = 5
    for i=1, units_to_spawn9 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_skeleton", point6+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin	
		 unit:SetHullRadius(56)
      end)
    end
	

	local units_to_spawn10 = 5
    for i=1, units_to_spawn10 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_knight", point7+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin	
		 unit:SetHullRadius(56)
      end)
    end
	
		local units_to_spawn11 = 5
    for i=1, units_to_spawn11 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_rock_golem", point8+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin	
		 unit:SetHullRadius(56)
      end)
    end
	
		local units_to_spawn12 = 6
    for i=1, units_to_spawn12 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_rock_golem", point9+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin	
		 unit:SetHullRadius(56)
      end)
    end

		local units_to_spawn13 = 1
    for i=1, units_to_spawn13 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_commander", point10+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin	
		 unit:SetHullRadius(56)
      end)
    end	
	
		local units_to_spawn14 = 5
    for i=1, units_to_spawn14 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_knight", point10+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin	
		 unit:SetHullRadius(56)
      end)
    end	
	
		local units_to_spawn15 = 1
    for i=1, units_to_spawn15 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_general", point11+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin	
		 unit:SetHullRadius(56)
      end)
    end	
	
		local units_to_spawn16 = 5
    for i=1, units_to_spawn16 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_skeleton", point11+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin	
		 unit:SetHullRadius(56)
      end)
    end	
	
		local units_to_spawn17 = 1
    for i=1, units_to_spawn17 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_mage", point12+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin	
		 unit:SetHullRadius(56)
      end)
    end	
	
		local units_to_spawn18 = 5
    for i=1, units_to_spawn18 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_spellcaster", point12+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin	
		 unit:SetHullRadius(56)
      end)
    end	
	end
	
	function SpawnCreeps3()
	local point1 = Entities:FindByName( nil, "spawner1"):GetAbsOrigin()
	local point2 = Entities:FindByName( nil, "spawner2"):GetAbsOrigin()
	local point3 = Entities:FindByName( nil, "spawner3"):GetAbsOrigin()
	local point4 = Entities:FindByName( nil, "spawner4"):GetAbsOrigin()
	local point5 = Entities:FindByName( nil, "spawner5"):GetAbsOrigin()
	local point6 = Entities:FindByName( nil, "spawner6"):GetAbsOrigin()
	local point7 = Entities:FindByName( nil, "spawner7"):GetAbsOrigin()
	local point8 = Entities:FindByName( nil, "spawner8"):GetAbsOrigin()
	local point9 = Entities:FindByName( nil, "spawner9"):GetAbsOrigin()
	local point10 = Entities:FindByName( nil, "spawner10"):GetAbsOrigin()
	local point11 = Entities:FindByName( nil, "spawner11"):GetAbsOrigin()
	local point12 = Entities:FindByName( nil, "spawner12"):GetAbsOrigin()
	
	local units_to_spawn1 = 3
    for i=1, units_to_spawn1 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_general", point1+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin	
		 unit:SetHullRadius(56)
      end)
    end
	
		local units_to_spawn2 = 2
    for i=1, units_to_spawn2 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_primal_furbolg", point1+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin	
		 unit:SetHullRadius(56)
      end)
    end
	
		local units_to_spawn3 = 2
    for i=1, units_to_spawn3 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_death_mage", point2+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin	
		 unit:SetHullRadius(56)
      end)
    end
	
		local units_to_spawn4 = 3
    for i=1, units_to_spawn4 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_mage", point2+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin	
		 unit:SetHullRadius(56)
      end)
    end
	
		local units_to_spawn5 = 4
    for i=1, units_to_spawn5 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_mutant_golem", point3+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin	
		 unit:SetHullRadius(56)
      end)
    end
	
		local units_to_spawn6 = 3
    for i=1, units_to_spawn6 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_commander", point4+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin	
		 unit:SetHullRadius(56)
      end)
    end
	
		local units_to_spawn7 = 2
    for i=1, units_to_spawn7 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_primal_werebeast", point4+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin	
		 unit:SetHullRadius(56)
      end)
    end
	
		local units_to_spawn8 = 3
    for i=1, units_to_spawn8 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_mage", point5+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin	
		 unit:SetHullRadius(56)
      end)
    end
	
		local units_to_spawn9 = 3
    for i=1, units_to_spawn9 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_general", point6+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin	
		 unit:SetHullRadius(56)
      end)
    end
	

	local units_to_spawn10 = 3
    for i=1, units_to_spawn10 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_commander", point7+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin	
		 unit:SetHullRadius(56)
      end)
    end
	
		local units_to_spawn11 = 2
    for i=1, units_to_spawn11 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_mutant_golem", point8+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin	
		 unit:SetHullRadius(56)
      end)
    end
	
		local units_to_spawn12 = 4
    for i=1, units_to_spawn12 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_mutant_golem", point9+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin	
		 unit:SetHullRadius(56)
      end)
    end

		local units_to_spawn13 = 3
    for i=1, units_to_spawn13 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_commander", point10+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin	
		 unit:SetHullRadius(56)
      end)
    end	
	
		local units_to_spawn14 = 2
    for i=1, units_to_spawn14 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_primal_werebeast", point10+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin	
		 unit:SetHullRadius(56)
      end)
    end	
	
		local units_to_spawn15 = 3
    for i=1, units_to_spawn15 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_general", point11+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin	
		 unit:SetHullRadius(56)
      end)
    end	
	
		local units_to_spawn16 = 2
    for i=1, units_to_spawn16 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_primal_furbolg", point11+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin	
		 unit:SetHullRadius(56)
      end)
    end	
	
		local units_to_spawn17 = 3
    for i=1, units_to_spawn17 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_mage", point12+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin	
		 unit:SetHullRadius(56)
      end)
    end	
	
		local units_to_spawn18 = 2
    for i=1, units_to_spawn18 do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("unit_death_mage", point12+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
		local origin = unit:GetAbsOrigin()
		unitsLocation[unit] = origin	
		 unit:SetHullRadius(56)
      end)
    end	
	end
	
	function CheckUnit()
	local point = Entities:FindByName( nil, "unitChecker"):GetAbsOrigin()
	local unitChecker = #Entities:FindAllInSphere(point, 3200) 
	local gameTime = GameRules:GetGameTime()
	
		if unitChecker <= 300 then
			if gameTime >= 360 then
				if gameTime >= 1200 then
					SpawnCreeps3()
					repeat_interval = 120
				else
					SpawnCreeps2()
					repeat_interval = 60
				end
			else
				SpawnCreeps1()
			end
		end
	end
	
	function moveUnit()
	Timers:CreateTimer(function()
		for k,v in pairs(unitsLocation) do 
			if not k:IsAlive() or k:IsDominated() then 
					unitsLocation[k] = nil
			else
			local unitPosition = k:GetAbsOrigin()
				if unitPosition ~= v then
					local attackState = k:GetAggroTarget()
					if attackState == nil then
						k:MoveToPosition(v)
					else
						local attackTarget = attackState:GetAbsOrigin()
						local targetDistance = (attackTarget - unitPosition):Length2D()	
						if targetDistance >= 1800 then
							k:MoveToPosition(v)
						end
					end
				end
			end
		end
		end)
	end

    Timers:CreateTimer(start_after, function()
        CheckUnit()
        return repeat_interval
    end)
	
    Timers:CreateTimer(startAfter, function()
        moveUnit()
        return thinkerInterval
    end)	
	

end




-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:InitGameMode()
  GameMode = self
  DebugPrint('[BAREBONES] Starting to load Barebones gamemode...')
  GameRules.heroList = {}
  GameRules:SetCustomGameSetupTimeout( 60 )

  -- Call the internal function to set up the rules/behaviors specified in constants.lua
  -- This also sets up event hooks for all event handlers in events.lua
  -- Check out internals/gamemode to see/modify the exact code
  GameMode:_InitGameMode()
  ListenToGameEvent('npc_spawned', Dynamic_Wrap(GameMode, 'OnNPCSpawned'), self)

  -- Commands can be registered for debugging purposes or as functions that can be called by the custom Scaleform UI
  Convars:RegisterCommand( "duel_on", Dynamic_Wrap(GameMode, 'ToggleDuelON'), "Toggling duel on", FCVAR_CHEAT )
  Convars:RegisterCommand( "duel_off", Dynamic_Wrap(GameMode, 'ToggleDuelOFF'), "Toggling duel off", FCVAR_CHEAT )
  Convars:RegisterCommand( "duel_check", Dynamic_Wrap(GameMode, 'CheckDuel'), "checking duel state", FCVAR_CHEAT )
  Convars:RegisterCommand( "camera2000", Dynamic_Wrap(GameMode, 'setCamera1'), "setting camera to 2000", FCVAR_CHEAT )  
  Convars:RegisterCommand( "camera2700", Dynamic_Wrap(GameMode, 'setCamera2'), "setting camera to 2700", FCVAR_CHEAT )  
  DebugPrint('[BAREBONES] Done loading Barebones gamemode!\n\n')
end



-- This is an example console command
function GameMode:ToggleDuelON()
  print( 'Duel state on' )
  local cmdPlayer = Convars:GetCommandClient()
  if cmdPlayer then
    local playerID = cmdPlayer:GetPlayerID()
    if playerID ~= nil and playerID ~= -1 then
      -- Do something here for the player who called this command
      local point = Entities:FindByName( nil, "redDuel1"):GetAbsOrigin()
	  FindClearSpaceForUnit(Convars:GetCommandClient(), point, false)
	  DUEL = true
    end
  end

  print( '*********************************************' )
end

function GameMode:setCamera1()
  print('setting camera distance 2000')
  local cmdPlayer = Convars:GetCommandClient()
  if cmdPlayer then
    local playerID = cmdPlayer:GetPlayerID()
    if playerID ~= nil and playerID ~= -1 then
      -- Do something here for the player who called this command
		GameRules:GetGameModeEntity():SetCameraDistanceOverride(2000)
    end
  end

  print( '*********************************************' )
end

function GameMode:setCamera2()
  print('setting camera distance 2000')
  local cmdPlayer = Convars:GetCommandClient()
  if cmdPlayer then
    local playerID = cmdPlayer:GetPlayerID()
    if playerID ~= nil and playerID ~= -1 then
      -- Do something here for the player who called this command
		GameRules:GetGameModeEntity():SetCameraDistanceOverride(2700)
    end
  end

  print( '*********************************************' )
end

function GameMode:ToggleDuelOFF()
	print("Duel state off")
	DUEL = false
end

function GameMode:CheckDuel()
	if DUEL then
		print("Duel is on!")
	else
		print("Duel is off")
	end
end

