-- Big furnace prototype and item definition
require("scripts.luaMacros")

local function create_bigfurnace(name, energy, speed)
    local bigfurnace = util.table.deepcopy(data.raw.furnace["electric-furnace"])
    local icon = "__WhistleStopFactories__/graphics/icons/big-furnace.png"

    bigfurnace.name = name
    bigfurnace.icon = icon
    bigfurnace.localised_name = {"entity-name.big-furnace"}

    bigfurnace.minable = nil
    bigfurnace.fast_replaceable_group = nil
    bigfurnace.dying_explosion = "big-explosion"

    bigfurnace.collision_box = {{-8.1, -8.1}, {8.1, 8.1}}
    bigfurnace.selection_box = {{-8.8, -9}, {8.8, 9}}
    bigfurnace.drawing_box = {{-8.8, -8.8}, {8.8, 8.8}}

    bigfurnace.crafting_categories = {"big-smelting"}
    bigfurnace.crafting_speed = speed

    bigfurnace.energy_usage = energy
    bigfurnace.module_specification.module_slots = 6
    bigfurnace.map_color = {r=199, g=103, b=247}
    bigfurnace.scale_entity_info_icon = true

    -- Set this to an assembling machine type
    bigfurnace.type = "assembling-machine"
    bigfurnace.result_inventory_size = nil
    bigfurnace.source_inventory_size = nil
    bigfurnace.ingredient_count = 1

    bigfurnace.create_ghost_on_death = false
    bigfurnace.flags = {"placeable-neutral", "placeable-player", "player-creation", "not-deconstructable", "not-blueprintable"}
    bigfurnace.collision_mask = bigfurnace.collision_mask or {"item-layer", "object-layer", "player-layer", "water-tile"}
    table.insert(bigfurnace.collision_mask, "resource-layer")
    table.insert(bigfurnace.resistances, {percent=100, type="poison"})  -- Prevent termite damage

    local function fluidBox(type, position)
        retvalue = {
                production_type = type,
                pipe_picture = assembler3pipepictures(),
                pipe_covers = pipecoverspictures(),
                base_area = 10,
                pipe_connections = {{ type=type, position=position }},
                secondary_draw_orders = { north = -1 }
            }
        if type == "input" then
            retvalue.base_level = -1
        else
            retvalue.base_level = 1
        end
        return retvalue
    end

    bigfurnace.fluid_boxes = {
        fluidBox("input", {-9, 0})
    }

    -- Scale graphics by a factor and correct animation speed
    -- local function bumpUp(animation, factor)
    --     animation.shift = util.table.deepcopy(animation.shift)
    --     animation.shift[1] = animation.shift[1] * factor   
    --     animation.shift[2] = animation.shift[2] * factor

    --     animation.scale = (animation.scale or 1) * factor
    --     animation.animation_speed = 0.01
    -- end

    -- local scaleFactor = 5.4
    -- for k,v in pairs(bigfurnace.animation.layers) do
    --     bumpUp(v, scaleFactor)
    --     bumpUp(v.hr_version, scaleFactor)
    -- end
    -- for k,v in pairs(bigfurnace.working_visualisations) do
    --     bumpUp(v.animation, scaleFactor)
    --     bumpUp(v.animation.hr_version, scaleFactor)
    -- end

    adjustVisuals(bigfurnace, 5.4, 1/20)

    data.raw["assembling-machine"][name] = bigfurnace

    local bigfurnace_item = util.table.deepcopy(data.raw.item["electric-furnace"])

    bigfurnace_item.name = name
    bigfurnace_item.icon = icon
    bigfurnace_item.order = "d[" .. name .. "]"
    bigfurnace_item.place_result = name

    data.raw.item[name] = bigfurnace_item
end

return create_bigfurnace