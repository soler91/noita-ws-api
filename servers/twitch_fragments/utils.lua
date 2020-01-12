function insert_constant(outcome)
    table.insert(outcome_generators, function() return outcome end)
end

function resolve_localized_name(s, default)
    if s:sub(1, 1) ~= "$" then return s end
    local rep = GameTextGet(s)
    if rep and rep ~= "" then
        return rep
    else
        return default or s
    end
end

function twiddle_health(f)
    local damagemodels =
        EntityGetComponent(get_player(), "DamageModelComponent")
    if (damagemodels ~= nil) then
        for i, damagemodel in ipairs(damagemodels) do
            local max_hp = tonumber(ComponentGetValue(damagemodel, "max_hp"))
            local cur_hp = tonumber(ComponentGetValue(damagemodel, "hp"))
            local new_cur, new_max = f(cur_hp, max_hp)
            ComponentSetValue(damagemodel, "max_hp", new_max)
            ComponentSetValue(damagemodel, "hp", new_cur)
        end
    end
end

function urand(mag) return math.floor((math.random() * 2.0 - 1.0) * mag) end

function spawn_item(path, offset_mag)
    local x, y = get_player_pos()
    local dx, dy = urand(offset_mag or 0), urand(offset_mag or 0)
    print(x + dx, y + dy)
    local entity = EntityLoad(path, x + dx, y + dy)
end

function wrap_spawn(path, offset_mag)
    return function() spawn_item(path, offset_mag) end
end

-- 0 to not limit axis, -1 to limit to negative values, 1 to limit to positive values
function generate_value_in_range(max_range, min_range, limit_axis)
    local range = (max_range or 0) - (min_range or 0)
    if (limit_axis or 0) == 0 then limit_axis = Random(0, 1) == 0 and 1 or -1 end

    return (Random(0, range) + (min_range or 0)) * limit_axis
end

function spawn_something(entity_path, min_dist, max_dist, from_above, black_hole)
    async(function()
        local x, y = get_player_pos()
        y = y + 110
        local dx = generate_value_in_range(max_dist, min_dist, 0)
        local dummy = EntityLoad("data/entities/dummy_hax.xml", x + dx, y)
        wait(20)
        local dummy_x, dummy_y = EntityGetTransform(dummy)

        EntityKill(dummy)
        if from_above then
            local rhit, rx, ry = Raytrace(dummy_x, dummy_y - 30, dummy_x,
                                          dummy_y - 190)
            if rhit then
                dummy_y = ry + 20
            else
                dummy_y = dummy_y - 170
            end
        end
        if black_hole then
            EntityLoad("data/entities/projectiles/deck/black_hole.xml", dummy_x,
                       dummy_y)
        end
        EntityLoad(entity_path, dummy_x, dummy_y)
    end)
end

function spawn_item_in_range(path, min_x_range, max_x_range, min_y_range,
                             max_y_range, limit_x_axis, limit_y_axis,
                             spawn_blackhole)
    local x, y = get_player_pos()
    local dx = generate_value_in_range(max_x_range, min_x_range, limit_x_axis)
    local dy = generate_value_in_range(max_y_range, min_y_range, limit_y_axis)

    if spawn_blackhole then
        EntityLoad("data/entities/projectiles/deck/black_hole.xml", x + dx,
                   y + dy)
    end
    local ix, iy = FindFreePositionForBody(x + dx, y + dy, 300, 300, 30)
    return EntityLoad(path, ix, iy)
end

function spawn_item(path, min_range, max_range, spawn_blackhole)
    return spawn_item_in_range(path, min_range, max_range, min_range, max_range,
                               0, 0, spawn_blackhole)
end

function GetWands()
    local childs = EntityGetAllChildren(get_player())
    local inven = nil
    if childs ~= nil then
        for _, child in ipairs(childs) do
            if EntityGetName(child) == "inventory_quick" then
                inven = child
            end
        end
    end
    local wands = {}
    if inven ~= nil then
        local items = EntityGetAllChildren(inven)
        for _, child_item in ipairs(items) do
            if EntityHasTag(child_item, "wand") then
                wands[_] = child_item
            end
        end
    end

    return wands or nil
end

function GetWandSpells(id)
    local childs = EntityGetAllChildren(id)
    local inven = {}
    if childs ~= nil then
        for _, child in ipairs(childs) do
            if EntityHasTag(child, "card_action") then
                inven[_] = child
            end
        end
    end
    return inven or nil
end

function spawn_prop(entity_path, x, y)
    async(function()
        local px, py = get_player_pos()

        local dummy = EntityLoad("data/entities/dummy_hax.xml", px + x, py + y)
        wait(60)
        local dummy_x, dummy_y = EntityGetTransform(dummy)
        EntityKill(dummy)
        local from_above = Random(0, 1)
        if from_above > 0 then
            local rhit, rx, ry = Raytrace(dummy_x, dummy_y - 35, dummy_x,
                                          dummy_y - 180)
            if rhit then
                dummy_y = ry + 25
            else
                dummy_y = dummy_y - 160
            end
        end
        EntityLoad(entity_path, dummy_x, dummy_y)
    end)
end
