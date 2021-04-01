dofile_once("mods/raksa/files/scripts/utilities.lua")

-- Namespaced name, because this is an actual global.
raksa_editwand_active_field = raksa_editwand_active_field or nil


function Header(text, no_margin)
  return function()
    Text(text, {color={red=155, green=173, blue=183}, y=no_margin and 0 or 3})
  end
end


function HoverTextField(field_name, text)
  return function (comp, entity)
    Horizontal(0, 0, function()
      Text(text..":")
      HoverText(tostring(ComponentGetValue2(comp, field_name)), {x=2})
    end)
  end
end


function TextField(field_name, text, tooltip)
  return function (comp, entity)
    Text(
      text..ComponentGetValue2(comp, field_name),
      { tooltip=tooltip }
    )
  end
end


function BooleanField(field_name, text, tooltip)
  return function (comp, entity)
    Checkbox({
        is_active=ComponentGetValue2(comp, field_name),
        text=text,
        tooltip=tooltip,
      },
      function() ComponentToggleValue(comp, field_name) end
    )
  end
end


function ComponentSetValueOrVec(comp, field_name, value, other, vec2_index)
  if vec2_index == 1 then
    ComponentSetValue2(comp, field_name, value, other)
  elseif vec2_index == 2 then
    ComponentSetValue2(comp, field_name, other, value)
  else
    ComponentSetValue2(comp, field_name, value)
  end
end


function NumberField(field_name, min, max, default, multiplier, tooltip, text, comp_id, ddist, decimals, vec2_index)
  local global_name = "RAKSA_NUMBERFIELD_"..field_name.."_"..tostring(vec2_index).."_"..ComponentGetTypeName(comp_id)

  -- This is stored in a Global, so that the state is kept correctly *no matter what*.
  -- Eg. changing wands, entities or reloading game
  local use_textinput = GlobalsGetBool(global_name, false)

  -- Invalid number values cannot be set into the Component, but it must be stored
  -- somewhere so that we know what to show the next frame.
  -- Eg. when the value is "" | "-" | "," | "3-3" | "...3..."
  local invalid_value = nil

  return function (comp, entity)
    local value, other = ComponentGetValue2(comp, field_name)

    if vec2_index == 2 then
      value, other = other, value
    end

    Horizontal(0, 0, function()
      Text(text, {y=-1, tooltip=tooltip})
      local _c, _rc, _h, _x, _y, width = WidgetInfo()

      local desired_distance = ddist or 25
      local distance = desired_distance - width

      Button(
        {
          x=distance,
          tooltip="Toggle accurate input",
          image="mods/raksa/files/gfx/editwand_icons/icon_number_input.png"
        },
        function()
          use_textinput = not use_textinput
          GlobalsToggleBool(global_name)
        end
      )

      if use_textinput then
        NumberInput({value=invalid_value or value}, function(new_value)
          number_value = tonumber(new_value)
          if not number_value then
            invalid_value = new_value
            return
          end

          ComponentSetValueOrVec(comp, field_name, number_value, other, vec2_index)
          invalid_value = nil
        end)
      else
        SliderBare({
            value=value,
            default=default,
            x=-2,
            min=min,
            max=max,
            width=100,
            tooltip=tooltip,
            formatting=formatting,
            decimals=decimals,
            display_multiplier=multiplier or 1,
          },
          function(new_value)
            local val = new_value
            ComponentSetValueOrVec(comp, field_name, val, other, vec2_index)
          end
        )
      end
    end)
  end
end

--

SUPPORTED_COMPONENTS = {
  SpriteComponent = function(component)
    return {
      name = "Sprite",
      desc = "Graphical properties of the entity",
      --special = TextField("image_file", ""),
      props = {
        component = component,
        height=155,
        fields = {
          Header("Rendering", true),
          HoverTextField("image_file", "Image file path"),
          NumberField("alpha", 0, 1, 0, 100, nil, "alpha", component, 28, true),
          NumberField("z_index", -150, 150, 0, 1, "0 = world grid, -1 = enemies, -1.5 = items in world, player = 0.6", "z-index", component, 28),
          BooleanField("emissive", "Emissive", "Emissive rendering mode"),
          BooleanField("additive", "Additive", "Additive rendering mode"),
          BooleanField("visible", "Visible"),
          BooleanField("fog_of_war_hole", "Fog of war hole", "Should the alpha channel of this texture puncture a hole in the fog of war.\nNote: doesn't work with together emissive"),
          BooleanField("smooth_filtering", "Smooth filtering"),
          Header("Offset"),
          NumberField("offset_x", -49, 50, 0, 1, "Sprite X offset", "x", component, 10),
          NumberField("offset_y", -49, 50, 0, 1, "Sprite Y offset", "y", component, 10),
          function (comp, entity)
            -- Required for many properties of sprites to properly update.
            -- Run every frame the SpriteComponent settings are open; if we start seeing
            -- problems: go through the hurdle of coding it into each property setting
            -- individually.
            EntityRefreshSprite(entity, comp)
          end,
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
          Header("Settings", true),
          BooleanField("is_emitting", "Is Emitting"),
          BooleanField("create_real_particles", "Create real particles", "creates these particles in the grid, if that happens velocity and lifetime are ignored"),
          BooleanField("emit_real_particles", "Emit real particles", "this creates particles that will behave like particles, but work outside of the screen"),
          BooleanField("emit_cosmetic_particles", "Emit cosmetic particles", "Particles have collisions, but no other physical interactions with the world.\nThe particles are culled outside camera region."),
          BooleanField("cosmetic_force_create", "Cosmetic force create", "cosmetic particles are created inside grid cells"),
          BooleanField("collide_with_grid", "Collide with grid", "for cosmetic particles, if 1 the particles collide with grid and only exist in screen space"),
          BooleanField("collide_with_gas_and_fire", "Collide with gas/fire", "does it collide with gas and fire, works with create_real_particles and raytraced images"),
          BooleanField("is_trail", "Is trail", "if set, will do a trail based on the previous position and current position"),
          Header("Rendering"),
          BooleanField("render_back", "Render back", "for cosmetic particles, if they are rendered on front or in the back..."),
          BooleanField("render_on_grid", "Render on grid", "if set, particle render positions will be snapped to cell grid"),
          BooleanField("fade_based_on_lifetime", "Fade based on lifetime", "if set, particle's position in its lifetime will determine the rendering alpha"),
          BooleanField("draw_as_long", "Draw as long", "if set, particle will rendered as a trail along it's movement vector"),
          BooleanField("set_magic_creation", "Magic creation effect", "if set will do the white glow effect"),
          Header("Velocity"),
          NumberField("x_vel_min", -100, 100, 0, 1, "Min X Velocity", "x min ", component),
          NumberField("x_vel_max", -100, 100, 0, 1, "Max X Velocity", "x max", component),
          NumberField("y_vel_min", -100, 100, 0, 1, "Min Y Velocity", "y min ", component),
          NumberField("y_vel_max", -100, 100, 0, 1, "Max Y Velocity", "y max", component),
          Header("Position offset"),
          NumberField("x_pos_offset_min", -20, 20, 0, 1, "Min X Pos Offset", "x min ", component),
          NumberField("x_pos_offset_max", -20, 20, 0, 1, "Min Y Pos Offset", "x max", component),
          NumberField("y_pos_offset_min", -20, 20, 0, 1, "Max X Pos Offset", "y min ", component),
          NumberField("y_pos_offset_max", -20, 20, 0, 1, "Max Y Pos Offset", "y max", component),
          Header("Emission interval frames"),
          NumberField("emission_interval_min_frames", 0, 100, 5, 1, "Emission interval min frames", "min ", component),
          NumberField("emission_interval_max_frames", 0, 100, 10, 1, "Emission interval max frames", "max", component),
          Header("Count"),
          NumberField("count_min", 0, 200, 5, 1, "Count Min", "min ", component),
          NumberField("count_max", 0, 200, 5, 1, "Count Max", "max", component),
          Header("Lifetime"),
          NumberField("lifetime_min", 0, 120, 5, 1, "Lifetime Min", "min ", component),
          NumberField("lifetime_max", 0, 120, 5, 1, "Lifetime Max", "max", component),
          Header("Airflow"),
          NumberField("airflow_force", 0, 6, 0, 1, "Airflow force", "force", component, nil, true),
          NumberField("airflow_time", 0, 10, 1, 1, "Airflow time", "time ", component, nil, true),
          NumberField("airflow_scale", 0, 10, 1, 1, "Airflow scale", "scale", component, nil, true),
          Header("Misc."),
          NumberField("friction", 0, 10, 0, 1, "Friction", "fric.", component),
          NumberField("attractor_force", 0, 100, 0, 1, "Attractor force", "attr.", component),
          NumberField("emission_chance", 0, 100, 100, 1, "Emission chance", "chance", component),
        }
      }
    }
  end,
  HitboxComponent = function(component)
    return {
      name = "Hitbox",
      desc = "",
      props = {
        component = component,
        height=170,
        fields = {
          Header("Settings", true),
          BooleanField("is_player", "Is player"),
          BooleanField("is_enemy", "Is enemy"),
          BooleanField("is_item", "Is item"),
          NumberField("damage_multiplier", 0, 10, 1, 1, "Damage multiplier. For eg. making headshots hurt more.", "mult.", component, 20, true),
          Header("Hitbox aabb size"),
          NumberField("aabb_min_x", -100, 100, -5, 1, "Hitbox min x", "min x", component),
          NumberField("aabb_max_x", -100, 100, 5, 1, "Hitbox max x", "max x", component),
          NumberField("aabb_min_y", -100, 100, -5, 1, "Hitbox min y", "min y", component),
          NumberField("aabb_max_y", -100, 100, 5, 1, "Hitbox max y", "max y", component),
          Header("Hitbox aabb offset"),
          NumberField("offset", -50, 50, 0, 1, "Hitbox offset", "x", component, 10, false, 1),
          NumberField("offset", -50, 50, 0, 1, "Hitbox offset", "y", component, 10, false, 2),
        }
      }
    }
  end,
}



-- AIAttackComponent #MAYBE
-- AbilityComponent #MAYBE #MAYBE
-- AdvancedFishAIComponent #MAYBE
-- AnimalAIComponent #MAYBE
-- BlackHoleComponent #MAYBE
-- BossDragonComponent #MAYBE
-- CameraBoundComponent #MAYBE #MAYBE
-- CellEaterComponent #MAYBE
-- CharacterDataComponent #MAYBE #MAYBE #MAYBE
-- CharacterPlatformingComponent #MAYBE #MAYBE #MAYBE
-- DamageModelComponent #MAYBE
-- DamageNearbyEntitiesComponent #MAYBE
-- EnergyShieldComponent #MAYBE
-- ExplodeOnDamageComponent #MAYBE
-- GenomeDataComponent #MAYBE
-- HitboxComponent #MAYBE
-- InteractableComponent #MAYBE #MAYBE
-- ItemChestComponent #MAYBE
-- ItemComponent #MAYBE
-- LaserEmitterComponent #MAYBE
-- LifetimeComponent #MAYBE #MAYBE
-- LightComponent #MAYBE
-- MaterialInventoryComponent #MAYBE #MAYBE #MAYBE
-- MaterialSuckerComponent #MAYBE #MAYBE
-- ParticleEmitterComponent #MAYBE
-- PathFindingComponent #MAYBE
-- PhysicsAIComponent #MAYBE
-- PhysicsThrowableComponent #MAYBE #MAYBE
-- PlatformShooterPlayerComponent #MAYBE #MAYBE #MAYBE #MAYBE
-- PotionComponent #MAYBE
-- SpriteComponent #MAYBE
-- SpriteOffsetAnimatorComponent #MAYBE
-- SpriteParticleEmitterComponent #MAYBE
-- TorchComponent #MAYBE
-- VelocityComponent #MAYBE
-- VerletPhysicsComponent #MAYBE
-- WormAIComponent #MAYBE
-- WormComponent #MAYBE #MAYBE
