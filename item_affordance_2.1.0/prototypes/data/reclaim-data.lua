data:extend({
    {
      name = "adordance-reclaimer",
      type = "recipe-category"
    },
    {
      icon = "__base__/graphics/icons/stone-furnace.png",
      name = "adordance-reclaimer",
      order = "zzz[adordance-reclaimer]",
      place_result = "adordance-reclaimer",
      stack_size = 50,
      subgroup = "smelting-machine",
      type = "item"
    },
    {
      ingredients = {},
      name = "adordance-reclaimer",
      results = {
        {
          amount = 1,
          name = "adordance-reclaimer",
          type = "item"
        }
      },
      type = "recipe"
    },
    {
      allowed_effects = {},
          collision_box = {
            {
              -0.7,
              -0.7
            },
            {
              0.7,
              0.7
            }
          },
          corpse = "stone-furnace-remnants",
          crafting_categories = {
            "adordance-reclaimer"
          },
          crafting_speed = 1000,
          damaged_trigger_effect = {
            damage_type_filters = "fire",
            entity_name = "rock-damaged-explosion",
            offset_deviation = {
              {
                -0.5,
                -0.5
              },
              {
                0.5,
                0.5
              }
            },
            offsets = {
              {
                0,
                1
              }
            },
            type = "create-entity"
          },
          dying_explosion = "stone-furnace-explosion",
          effect_receiver = {
            uses_beacon_effects = false,
            uses_module_effects = false,
            uses_surface_effects = false
          },
          energy_source = {
            emissions_per_minute = {
              pollution = 0
            },
            type = "void"
          },
          energy_usage = "1kW",
          flags = {
            "placeable-neutral",
            "placeable-player",
            "player-creation"
          },
          graphics_set = {
            animation = {
              layers = {
                {
                  filename = "__base__/graphics/entity/stone-furnace/stone-furnace.png",
                  height = 146,
                  priority = "extra-high",
                  scale = 0.5,
                  shift = {
                    -0.0078125,
                    0.1875
                  },
                  width = 151
                },
                {
                  draw_as_shadow = true,
                  filename = "__base__/graphics/entity/stone-furnace/stone-furnace-shadow.png",
                  height = 74,
                  priority = "extra-high",
                  scale = 0.5,
                  shift = {
                    0.453125,
                    0.40625
                  },
                  width = 164
                }
              }
            },
            water_reflection = {
              orientation_to_variation = false,
              pictures = {
                filename = "__base__/graphics/entity/stone-furnace/stone-furnace-reflection.png",
                height = 16,
                priority = "extra-high",
                scale = 5,
                shift = {
                  0,
                  1.09375
                },
                variation_count = 1,
                width = 16
              },
              rotate = false
            },
            working_visualisations = {
              {
                animation = {
                  layers = {
                    {
                      draw_as_glow = true,
                      filename = "__base__/graphics/entity/stone-furnace/stone-furnace-fire.png",
                      frame_count = 48,
                      height = 100,
                      line_length = 8,
                      priority = "extra-high",
                      scale = 0.5,
                      shift = {
                        -0.0234375,
                        0.171875
                      },
                      width = 41
                    },
                    {
                      blend_mode = "additive",
                      draw_as_glow = true,
                      filename = "__base__/graphics/entity/stone-furnace/stone-furnace-light.png",
                      height = 144,
                      repeat_count = 48,
                      scale = 0.5,
                      shift = {
                        0,
                        0.15625
                      },
                      width = 106
                    }
                  }
                },
                effect = "flicker",
                fadeout = true
              },
              {
                animation = {
                  blend_mode = "additive",
                  draw_as_light = true,
                  filename = "__base__/graphics/entity/stone-furnace/stone-furnace-ground-light.png",
                  height = 110,
                  repeat_count = 48,
                  scale = 0.5,
                  shift = {
                    -0.03125,
                    1.375
                  },
                  width = 116
                },
                effect = "flicker",
                fadeout = true
              }
            }
          },
          icon = "__base__/graphics/icons/stone-furnace.png",
          icon_draw_specification = {
            scale = 0.66,
            shift = {
              0,
              -0.1
            }
          },
          impact_category = "stone",
          max_health = 1,
          minable = {
            mining_time = 0.2,
            result = "adordance-reclaimer"
          },
          mined_sound = {
            aggregation = {
              count_already_playing = true,
              max_count = 2,
              remove = true
            },
            switch_vibration_data = {
              filename = "__core__/sound/deconstruct-bricks.bnvib",
              gain = 0.32
            },
            variations = {
              {
                filename = "__base__/sound/deconstruct-bricks.ogg",
                volume = 0.8
              }
            }
          },
          name = "adordance-reclaimer",
          repair_sound = {
            {
              filename = "__base__/sound/manual-repair-simple-1.ogg",
              volume = 0.5
            },
            {
              filename = "__base__/sound/manual-repair-simple-2.ogg",
              volume = 0.5
            },
            {
              filename = "__base__/sound/manual-repair-simple-3.ogg",
              volume = 0.5
            },
            {
              filename = "__base__/sound/manual-repair-simple-4.ogg",
              volume = 0.5
            },
            {
              filename = "__base__/sound/manual-repair-simple-5.ogg",
              volume = 0.5
            }
          },
          resistances = {},
          result_inventory_size = 10,
          selection_box = {
            {
              -0.8,
              -1
            },
            {
              0.8,
              1
            }
          },
          source_inventory_size = 1,
          type = "furnace",
          working_sound = {
            fade_in_ticks = 4,
            fade_out_ticks = 20,
            sound = {
              audible_distance_modifier = 0.4,
              filename = "__base__/sound/furnace.ogg",
              modifiers = {
                {
                  type = "main-menu",
                  volume_multiplier = 1.5
                },
                {
                  type = "tips-and-tricks",
                  volume_multiplier = 1.4
                }
              },
              volume = 0.6
            }
          }
    }
})
--furnace-coal
if mods["5dim_core"] and data.raw["item-subgroup"]["furnace-coal"] then
    data.raw.item["adordance-reclaimer"].subgroup = "furnace-coal"
end