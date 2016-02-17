function Heal(event)
    event.caster:GetPlayerOwner():GetAssignedHero():Heal(event.heal_amount, event.caster)
end

--[[ ============================================================================================================
	Author: Rook, with help from Noya
	Date: February 2, 2015
	Returns a reference to a newly-created illusion unit.
================================================================================================================= ]]
function create_illusion(keys, illusion_origin, illusion_incoming_damage, illusion_outgoing_damage, illusion_duration)	
	local player_id = keys.caster:GetPlayerID()
	local caster_team = keys.caster:GetTeam()
	
	local illusion = CreateUnitByName(keys.caster:GetUnitName(), illusion_origin, true, keys.caster, nil, caster_team)  --handle_UnitOwner needs to be nil, or else it will crash the game.
	illusion:SetPlayerID(player_id)
	illusion:SetControllableByPlayer(player_id, true)

	--Level up the illusion to the caster's level.
	local caster_level = keys.caster:GetLevel()
	for i = 1, caster_level - 1 do
		illusion:HeroLevelUp(false)
	end

	--Set the illusion's available skill points to 0 and teach it the abilities the caster has.
	illusion:SetAbilityPoints(0)
	for ability_slot = 0, 15 do
		local individual_ability = keys.caster:GetAbilityByIndex(ability_slot)
		if individual_ability ~= nil then 
			local illusion_ability = illusion:FindAbilityByName(individual_ability:GetAbilityName())
			if illusion_ability ~= nil then
				illusion_ability:SetLevel(individual_ability:GetLevel())
			end
		end
	end

	--Recreate the caster's items for the illusion.
	for item_slot = 0, 5 do
		local individual_item = keys.caster:GetItemInSlot(item_slot)
		if individual_item ~= nil then
			local illusion_duplicate_item = CreateItem(individual_item:GetName(), illusion, illusion)
			illusion:AddItem(illusion_duplicate_item)
		end
	end
	
	-- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle 
	illusion:AddNewModifier(keys.caster, keys.ability, "modifier_illusion", {duration = illusion_duration, outgoing_damage = illusion_outgoing_damage, incoming_damage = illusion_incoming_damage})
	
	illusion:MakeIllusion()  --Without MakeIllusion(), the unit counts as a hero, e.g. if it dies to neutrals it says killed by neutrals, it respawns, etc.  Without it, IsIllusion() returns false and IsRealHero() returns true.

	return illusion
end

--[[ ============================================================================================================
	Author: Rook
	Date: February 2, 2015
	Called after Manta Style's brief invulnerability period ends.  Creates some illusions.
	
	Modified by DaringDan (for a single illusion with no invulnerability period)
	Date: January 14, 2016
================================================================================================================= ]]
function cloneorb_datadriven_on_spell_start(keys)
	keys.caster:EmitSound("DOTA_Item.Manta.Activate")
	local caster_origin = keys.caster:GetAbsOrigin()
	
	--Illusions are created to the North, South, East, or West of the hero (obviously, both cannot be created in the same direction).
	local illusion1_direction = RandomInt(1, 4)
	
	local illusion1_origin = nil
	
	if illusion1_direction == 1 then  --North
		illusion1_origin = caster_origin + Vector(0, 100, 0)
	elseif illusion1_direction == 2 then  --South
		illusion1_origin = caster_origin + Vector(0, -100, 0)
	elseif illusion1_direction == 3 then  --East
		illusion1_origin = caster_origin + Vector(100, 0, 0)
	else  --West
		illusion1_origin = caster_origin + Vector(-100, 0, 0)
	end
	
	--Create the illusions.
	local illusion1 = nil
	illusion1 = create_illusion(keys, illusion1_origin, 200, -100, 20)
	
	--Reset our illusion origin variables because CreateUnitByName might have slightly changed the origin so that the unit won't be stuck.
	illusion1_origin = illusion1:GetAbsOrigin()
	
	--Make it so all of the units are facing the same direction.
	local caster_forward_vector = keys.caster:GetForwardVector()
	illusion1:SetForwardVector(caster_forward_vector)
	
	--Randomize the positions of the illusions and the real hero.
	local hero_random_origin = RandomInt(1, 3)
	local illusion1_random_origin = (RandomInt(1, 2) + hero_random_origin) % 3  --This will ensure that this variable will be different from hero_random_origin.
	
	if hero_random_origin == 1 then
		keys.caster:SetAbsOrigin(caster_origin)
		illusion1:SetAbsOrigin(illusion1_origin)
	else
		keys.caster:SetAbsOrigin(illusion1_origin)
		illusion1:SetAbsOrigin(caster_origin)
	end
	
	--Set the health and mana values to those of the real hero.
	local caster_health = keys.caster:GetHealth()
	local caster_mana = keys.caster:GetMana()
	illusion1:SetHealth(caster_health)
	illusion1:SetMana(caster_mana)
end

--[[
	Author: Ractidous
	Date: 29.01.2015.
	Hide caster's model.
]]
function HideCaster(event)
	event.caster:AddNoDraw()
end

--[[
	Author: Ractidous
	Date: 29.01.2015.
	Show caster's model.
]]
function ShowCaster(event)
	event.caster:RemoveNoDraw()
end

function OnAttackedLog(event)
	local attacker = event.attacker
	local log = event.target

	log.attacker = attacker
	log:SetHealth(0)

	event.caster:RemoveModifierByName("modifier_kawamari_log_form_caster_datadriven")
	log:RemoveModifierByName("modifier_kawamari_log_form_datadriven")
end

function OnDestroyLog(event)
	local log = event.target

	if log:GetHealth() == 0 then
		event.caster:SetAbsOrigin(log.attacker:GetAbsOrigin())
		FindClearSpaceForUnit(event.caster, log.attacker:GetAbsOrigin(), false)
	end

	event.caster:AddNewModifier(event.caster, nil, "modifier_kawamari_log_explode_datadriven", {})
	event.caster:RemoveModifierByName("modifier_kawamari_log_explode_datadriven")
	log:ForceKill( false )
	log:AddNoDraw()
end