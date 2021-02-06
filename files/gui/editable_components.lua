dofile_once("mods/raksa/files/scripts/utilities.lua")

function CompSlider(field_name, min, max, default, multiplier, tooltip)
  return function (comp, entity)
    Slider({
        text="",
        value=ComponentGetValue2(comp, field_name) * multiplier,
        default=default,
        min=min*multiplier,
        max=max*multiplier,
        width=100,
        tooltip=tooltip,
        --tooltip_desc="Warning: Things can quickly turn sour with high numbers",
      },
      function(new_value)
        local val = new_value / multiplier
        ComponentSetValue2(comp, field_name, val)
        --EntityRefreshSprite(entity, comp)
      end
    )
  end
end

function CompCheckbox(field_name, text, tooltip)
  return function (comp, entity)
    Checkbox({
        is_active=ComponentGetValue2(comp, field_name),
        text=text,
        tooltip=tooltip,
      },
      function()
        ComponentToggleValue(comp, field_name)
        --EntityRefreshSprite(entity, comp)
      end
    )
  end
end

SUPPORTED_COMPONENTS = {
  SpriteComponent = function(component)
    return {
      name = "Sprite",
      desc = "Graphical properties of the entity",
      props = {
        component = component,
        fields = {
          CompSlider("alpha", 0, 1, 0, 100, "alpha"),
          --CompCheckbox("emissive", "Emissive", "Emissive rendering mode"),
          --CompCheckbox("additive", "Additive", "Additive rendering mode"),
        }
      }
    }
  end,
  ParticleEmitterComponent = function(component)
    return {
      name = "Particle Emitter",
      desc = "",
      props = {
        component = component,
        fields = {
          CompSlider("x_vel_min", -100, 100, 0, 1, "Min X Velocity"),
          CompSlider("x_vel_max", -100, 100, 0, 1, "Max X Velocity"),
          CompSlider("y_vel_min", -100, 100, 0, 1, "Min Y Velocity"),
          CompSlider("y_vel_max", -100, 100, 0, 1, "Max Y Velocity"),
          CompSlider("x_pos_offset_min", -20, 20, 0, 1, "Min X Pos Offset"),
          CompSlider("y_pos_offset_min", -20, 20, 0, 1, "Max X Pos Offset"),
          CompSlider("x_pos_offset_max", -20, 20, 0, 1, "Min Y Pos Offset"),
          CompSlider("y_pos_offset_max", -20, 20, 0, 1, "Max Y Pos Offset"),
          CompSlider("emission_interval_min_frames", 0, 100, 5, 1, "Emission interval min frames"),
          CompSlider("emission_interval_max_frames", 0, 100, 10, 1, "Emission interval max frames"),
          CompSlider("count_min", 0, 200, 5, 1, "Count Min"),
          CompSlider("count_max", 0, 200, 5, 1, "Count Max"),
        }
      }
    }
  end
}
