table.insert(outcome_generators, function()
  -- extracted from data/scripts/items/potion.lua
  local materials = nil
  if( Random( 0, 100 ) <= 75 ) then
    if( Random( 0, 100000 ) <= 50 ) then
      potion_material = "magic_liquid_hp_regeneration"
    elseif( Random( 200, 100000 ) <= 250 ) then
      potion_material = "purifying_powder"
    else
      potion_material = random_from_array( potion_materials_magic )
    end
  else
    potion_material = random_from_array( potion_materials_standard )
  end
  
  local matname = GameTextGet("$mat_" .. potion_material)
  
  return {
    name = "Flask: " .. matname,
    desc = "Enjoy",
    func = function()
      local x, y = get_player_pos()
      -- just go ahead and assume cheatgui is installed
      local entity = EntityLoad( "data/hax/potion_empty.xml", x, y )
      AddMaterialInventoryMaterial( entity, potion_material, 1000 )
    end
  }
end)

table.insert(outcome_generators, function()
  -- spawn a random perk
  local perk = perk_list[math.random(1, #perk_list)]

  -- reroll useless perk
  while perk.id == "MYSTERY_EGGPLANT" do
    perk = perk_list[math.random(1, #perk_list)]
  end
  
  local perkname = resolve_localized_name(perk.ui_name, perk.id)
  return {
    name = "Perk: " .. perkname,
    desc = "Have fun",
    func = function()
      local x, y = get_player_pos()

      -- player might be dead
      if x ~= nil and y ~= nil then
        local perk_entity = perk_spawn( x, y - 8, perk.id )
        local players = get_players()
        if players == nil  then return end
        for i,player in ipairs(players) do
          -- last argument set to false, so you dont kill others perks if triggered inside the shop
          perk_pickup( perk_entity, player, nil, true, false )
        end
      end
    end
  }
end)

insert_constant{
  name = "Health Down",
  desc = "Unfortunate",
  func = function()
    twiddle_health(function(cur, max)
      max = max * 0.8
      cur = math.min(max, cur)
      return cur, max
    end)
  end
}

insert_constant{
  name = "Health Up",
  desc = "Amazing",
  func = function()
    twiddle_health(function(cur, max)
      return cur+1, max+1
    end)
  end
}

insert_constant{
  name = "The Gods Are Angry",
  desc = "...",
  func = function()
    spawn_something("data/entities/animals/necromancer_shop.xml", 100, 100, true, true)
  end
}

insert_constant{
  name = "A big worm",
  desc = "This could be a problem",
  func = function()
    spawn_item("data/entities/animals/worm_big.xml", 100, 100)
  end
}

insert_constant{
  name = "The biggest worm",
  desc = "oh ... oh no ... OH NO NO NO",
  func = function()
    spawn_item("data/entities/animals/worm_end.xml", 100, 150)
  end
}

insert_constant{
  name = "A couple of worms",
  desc = "That's annoying",
  func = function()
    spawn_item("data/entities/animals/worm.xml", 50, 200)
    spawn_item("data/entities/animals/worm.xml", 50, 200)
  end
}

insert_constant{
  name = "A can of worms",
  desc = "But why?",
  func = function()
    for i=1,10 do
      spawn_item("data/entities/animals/worm_tiny.xml", 50, 200)
    end
  end
}

insert_constant{
  name = "Deers",
  desc = "Oh dear!",
  func = function()
    for i=1,5 do
      spawn_something("data/entities/projectiles/deck/exploding_deer.xml", 100, 300) 
      spawn_something("data/entities/animals/deer.xml", 100, 300) 
    end
  end
}


insert_constant{
  name = "Gold rush",
  desc = "Quick, before it disappear",
  func = function()
    for i=1,30 do
      spawn_something("data/entities/items/pickup/goldnugget.xml", 30, 180) 
    end
  end
}

insert_constant{
  name = "Sea of lava",
  desc = "Now, that's hot!!",
  func = function()
    spawn_item_in_range("data/entities/projectiles/deck/sea_lava.xml", 0, 200, 20, 100, 0, 1, false)
  end
}

insert_constant{
  name = "ACID??",
  desc = "Who thought this was a good idea",
  func = function()
    local above = false
    local rand = Random(0,1)
    if rand > 0 then
      above = true
    end
    spawn_something("data/entities/projectiles/deck/circle_acid.xml", 70, 180, above, true)
  end
}

insert_constant{
  name = "FIRE FIRE",
  desc = "Hot.",
  func = function()
    local above = false
    local rand = Random(0,1)
    if rand > 0 then
      above = true
    end
    spawn_something("data/entities/projectiles/deck/circle_fire.xml", 70, 180, above, true)
  end
}

insert_constant{
  name = "Holy bombastic",
  desc = "That should clear the path",
  func = function()
    spawn_item("data/entities/projectiles/bomb_holy.xml", 130, 250, true)
  end
}

insert_constant{
  name = "Thunderstone madness",
  desc = "Careful now",
  func = function()
    for i=1,10 do
      spawn_item("data/entities/items/pickup/thunderstone.xml", 50, 250)
    end
  end
}

insert_constant{
  name = "Instant swimming pool",
  desc = "Don't forget your swimsuit",
  func = function()
    spawn_item_in_range("data/entities/projectiles/deck/sea_water.xml", 0, 0, 40, 80, 0, -1, false)
  end
}

insert_constant{
  name = "Random wand generator",
  desc = "Make good use of it",
  func = function()
    local rnd = Random(0, 1000)
    if rnd < 200 then
      spawn_item("data/entities/items/wand_level_01.xml")
    elseif rnd < 600 then
      spawn_item("data/entities/items/wand_level_02.xml")
    elseif rnd < 850 then
      spawn_item("data/entities/items/wand_level_03.xml")
    elseif rnd < 998 then
      spawn_item("data/entities/items/wand_level_04.xml")
    else
      spawn_item("data/entities/items/wand_level_05.xml")
    end
  end
}

insert_constant{
  name = "Full health",
  desc = "Chat giveth",
  func = function()
    spawn_item("data/entities/items/pickup/heart_fullhp.xml", 0, 10) 
  end
}

insert_constant{
  name = "Spell refresher",
  desc = "Because you need it",
  func = function()
    spawn_item("data/entities/items/pickup/spell_refresh.xml", 0, 10) 
  end
}
shieldrad = 10
insert_constant{
  name = "6 Shields... WHAT!?",
  desc = "but projectiles hit like a truck :)",
  func = function()
    local player = get_player()
    
    for i=1,6 do
      local x, y = get_player_pos()
      local shield = EntityLoad( "data/entities/misc/perks/shield.xml", x, y )
      
      local emitters = EntityGetComponent( shield, "ParticleEmitterComponent" ) or {};
      for _,emitter in pairs( emitters ) do
        ComponentSetValueValueRange( emitter, "area_circle_radius", shieldrad, shieldrad );
        end
      local energy_shield = EntityGetFirstComponent( shield, "EnergyShieldComponent" );
        ComponentSetValue( energy_shield, "radius", tostring( shieldrad ) );
      if shield ~= nil then EntityAddChild( player, shield ); end
      shieldrad = shieldrad + 2
    end
    local damagemodels = EntityGetComponent( player, "DamageModelComponent" )
			if( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local projectile_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "projectile" ))
					projectile_resistance = projectile_resistance * 2
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "projectile", tostring(projectile_resistance) )
				end
			end
  end
}

insert_constant{
  name = "THE MOIST MOB",
  desc = "because why not",
  func = function()
    local rnd = Random(10, 20)
      spawn_something("data/entities/animals/frog_big.xml", 30, 180, true) 
    for i=1,rnd do
      spawn_something("data/entities/animals/frog.xml", 50, 150, true) 
    end
  end
}

insert_constant{
  name = "plaGUEE rats",
  desc = "Hail the rat king",
  func = function()
    local rats = Random(20, 30)
    local plague = Random(10, 20)
    local boss = Random(1, 2)
      
    for i=1,rats do
      spawn_something("data/entities/animals/rat.xml", 30, 120, true) 
    end
    for i=1,plague do
      spawn_something("data/entities/misc/perks/plague_rats_rat.xml", 50, 160, true) 
    end
    for i=1,boss do
      spawn_something("data/entities/animals/skullrat.xml", 80, 180, true) 
    end
  end
}

insert_constant{
  name = "Bomb rush",
  desc = "You better run",
  func = function()
      async(function()
      local tnt = Random(5, 9)
      local small_bombs = Random(4, 7)
      local bombs = Random(3, 5)

      for i=1,tnt do
        spawn_item("data/entities/projectiles/tnt.xml", 0, 70) 
      end

      wait( 2 * 60 )

      for i=1,small_bombs do
        spawn_item("data/entities/projectiles/glitter_bomb.xml", 0, 60) 
      end

      wait( 4 * 60 )

      for i=1,bombs do
        spawn_item("data/entities/projectiles/bomb.xml", 0, 50) 
      end

      wait( 5 * 60 )

      spawn_item("data/entities/projectiles/bomb_holy.xml", 130, 250, true)
    end)
  end
}

insert_constant{
  name = "Secret ending",
  desc = "jebaited!",
  func = function()
      spawn_item("data/entities/projectiles/deck/tentacle_portal.xml", 0, 60, true) 
  end
}

insert_constant{
  name = "CHONKY",
  desc = "Big stomp for 2 mins!",
  func = function()
    async(function()
      local playah = get_player()
      local o_min = nil
      local o_max = nil
      local o_x = nil
      local o_y = nil
      local chardatacomp = EntityGetComponent( playah, "CharacterDataComponent" )
        if( chardatacomp ~= nil ) then
          for i,charmodel in ipairs(chardatacomp) do
            local o_min = ComponentGetValue( charmodel, "eff_hg_damage_min" )
            local o_max = ComponentGetValue( charmodel, "eff_hg_damage_max" )
            local o_x = ComponentGetValue( charmodel, "eff_hg_size_x" )
            local o_y = ComponentGetValue( charmodel, "eff_hg_size_y" )
    
            ComponentSetValue( charmodel, "eff_hg_damage_min", "80000" )
            ComponentSetValue( charmodel, "eff_hg_damage_max", "150000" )
            ComponentSetValue( charmodel, "eff_hg_size_x", "30" )
            ComponentSetValue( charmodel, "eff_hg_size_y", "10" )
            ComponentSetValue( charmodel, "destroy_ground", "1" )
          end
        end
  
    
      wait(60*120)
      local chardata = EntityGetComponent( get_player(), "CharacterDataComponent" )
      if( chardata ~= nil ) then
        for i,model in ipairs(chardata) do
  
          ComponentSetValue( model, "eff_hg_damage_min", o_min )
          ComponentSetValue( model, "eff_hg_damage_max", o_max )
          ComponentSetValue( model, "eff_hg_size_x", o_x )
          ComponentSetValue( model, "eff_hg_size_y", o_y )
        end
      end
    end)
  end
}

noitlocke = false -- maybe use GetValue/SetValue for this ?
insert_constant{
  name = "NOITLOCKE",
  desc = "is this pokiman!!?",
  func = function()
    if noitlocke then
      return
    end
    noitlocke = true
    async_loop(function()
      local wands = GetWands()
      if wands == nil then
        return
      end
      
      for _, wid in ipairs(wands) do
        local actions = GetWandSpells(wid)
        
        if actions ~= nil then
          for __, aid in ipairs(actions) do
            local action_comps = EntityGetAllComponents(aid)
            for i, c in ipairs(action_comps) do 
              if ComponentGetTypeName(c) == "ItemComponent" then
                ComponentSetValue(c, "is_frozen", "1")
              end
            end 
          end
        end
      end
      wait(120)
    end)
  end
}

insert_constant{
  name = "BOOST WANDS",
  desc = "Have fun!",
  func = function()
    local wands = GetWands()
    if wands == nil then
      return
    end
    local to_boost = Random(1, table.getn(wands))
    
    for i = 1, to_boost do
      local ability = EntityGetAllComponents( wands[i])
      local boost_speed = Random(0,1)
      local boost_recharge = Random(0,1)
      local reduce_spread = Random(0,1)
      local unshuffle = Random(0,1)
      for _, c in ipairs(ability) do
        if ComponentGetTypeName(c) == "AbilityComponent" then
          local mana_max = tonumber(ComponentGetValue(c, "mana_max"))
          local mana_charge = tonumber(ComponentGetValue(c, "mana_charge_speed"))
          local deck_capacity = tonumber(ComponentObjectGetValue( c, "gun_config", "deck_capacity"))
          mana_max = mana_max + Random(20,50)
          mana_charge = mana_charge + Random(20,50)
          deck_capacity = deck_capacity + Random(1, 5)
          ComponentSetValue(c, "mana_max", tostring(mana_max))
          ComponentSetValue(c, "mana_charge_speed", tostring(mana_charge))
          ComponentObjectSetValue( c, "gun_config", "deck_capacity", tostring(deck_capacity) )
          if boost_recharge > 0 then
            local cur_recharge = ComponentObjectGetValue( c, "gun_config", "reload_time")
            cur_recharge = cur_recharge - 20
            ComponentObjectSetValue( c, "gun_config", "reload_time", tostring(cur_recharge) )
          end
          if boost_speed > 0 then
            local cur_speed = ComponentObjectGetValue( c, "gunaction_config", "fire_rate_wait")
            cur_speed = cur_speed - 20
            ComponentObjectSetValue( c, "gunaction_config", "fire_rate_wait", tostring(cur_speed) )
          end
          if reduce_spread > 0 then
            local cur_spread = ComponentObjectGetValue( c, "gunaction_config", "spread_degrees")
            cur_spread = cur_spread - 10
            ComponentObjectSetValue( c, "gunaction_config", "spread_degrees", tostring(cur_spread) )
          end
          if unshuffle > 0 then
            cur = 0
            ComponentObjectSetValue( c, "gun_config", "shuffle_deck_when_empty", tostring(cur) )
          end
        end
      end
    end
  end
}

insert_constant{
  name = "NERF WANDS",
  desc = "Oh no.. at least it has better mana ?!",
  func = function()
    local wands = GetWands()
    if wands == nil then
      return
    end
    local to_boost = Random(1, table.getn(wands))
    
    for i = 1, to_boost do
      local ability = EntityGetAllComponents( wands[i])
      local nerf_speed = Random(0,1)
      local nerf_recharge = Random(0,1)
      local add_spread = Random(0,1)
      local shuffle = Random(0,1)
      for _, c in ipairs(ability) do
        if ComponentGetTypeName(c) == "AbilityComponent" then
          local mana_max = tonumber(ComponentGetValue(c, "mana_max"))
          local mana_charge = tonumber(ComponentGetValue(c, "mana_charge_speed"))
          mana_max = mana_max + Random(20,50)
          mana_charge = mana_charge + Random(20,50)
          ComponentSetValue(c, "mana_max", tostring(mana_max))
          ComponentSetValue(c, "mana_charge_speed", tostring(mana_charge))
          
          if nerf_recharge > 0 then
            local cur_recharge = ComponentObjectGetValue( c, "gun_config", "reload_time")
            cur_recharge = cur_recharge + 20
            ComponentObjectSetValue( c, "gun_config", "reload_time", tostring(cur_recharge) )
          end
          if nerf_speed > 0 then
            local cur_speed = ComponentObjectGetValue( c, "gunaction_config", "fire_rate_wait")
            cur_speed = cur_speed + 20
            ComponentObjectSetValue( c, "gunaction_config", "fire_rate_wait", tostring(cur_speed) )
          end
          if add_spread > 0 then
            local cur_spread = ComponentObjectGetValue( c, "gunaction_config", "spread_degrees")
            cur_spread = cur_spread + 5
            ComponentObjectSetValue( c, "gunaction_config", "spread_degrees", tostring(cur_spread) )
          end
          if shuffle > 0 then
            cur = 1
            ComponentObjectSetValue( c, "gun_config", "shuffle_deck_when_empty", tostring(cur) )
          end
        end
      end
    end
  end
}

insert_constant{
  name = "SHUFFLE",
  desc = "OOF!",
  func = function()
    local wands = GetWands()
    if wands == nil then
      return
    end
    local to_boost = Random(1, table.getn(wands))
    
    for i = 1, to_boost do
      local ability = EntityGetAllComponents( wands[i])
      for _, c in ipairs(ability) do
        if ComponentGetTypeName(c) == "AbilityComponent" then
          cur = 1
          ComponentObjectSetValue( c, "gun_config", "shuffle_deck_when_empty", tostring(cur) )
        end
      end
    end
  end
}

insert_constant{
  name = "UNSHUFFLE",
  desc = "Lucky u!",
  func = function()
    local wands = GetWands()
    if wands == nil then
      return
    end
    local to_boost = Random(1, table.getn(wands))
    
    for i = 1, to_boost do
      local ability = EntityGetAllComponents( wands[i])
      for _, c in ipairs(ability) do
        if ComponentGetTypeName(c) == "AbilityComponent" then
          cur = 0
          ComponentObjectSetValue( c, "gun_config", "shuffle_deck_when_empty", tostring(cur) )
        end
      end
    end
  end
}

barrel_entities = {
  "data/entities/props/physics_propane_tank.xml",
  "data/entities/props/physics_pressure_tank.xml",
  "data/entities/props/physics_box_explosive.xml",
  "data/entities/props/physics_barrel_oil.xml",
  "data/entities/props/physics_barrel_radioactive.xml"
}

insert_constant{
    name = "Explosives",
    desc = "Might cause explosions!",
    func = function()   
      async(function()
        for i = 1, 350 do
        local barrel = random_from_array( barrel_entities )
        local x = generate_value_in_range(1200, 20, 0)
        local y = generate_value_in_range(1200, 20, 0)
        spawn_prop(barrel, x, y)
        end
      end)
    end
}
  
insert_constant{
    name = "Dryspell",
    desc = "Don't get lit on fire!",
    func = function()
      async(function()
        local px, py = get_player_pos()
        local dry_entity = EntityLoad("data/entities/dryspell.xml", px, py)
        EntityAddChild(get_player(), dry_entity)
        wait(60*120)
        EntityKill(dry_entity)
      end)
    end
}
  