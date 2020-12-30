# The Conjurer Extension System

The mod has been built to be easily extendable by other mods. You can add items
to any of the basic lists straight from your own mod, via the following ways:


## Entities

Add a custom tab to the entity panel:
```lua
-- init.lua
--
if ModIsEnabled("raksa") then
  ModLuaFileAppend(
    "mods/raksa/files/scripts/lists/entity_categories.lua",
    "path/to/my_entities.lua"
  )
end


-- my_entities.lua
--
table.insert(ALL_ENTITIES, {
  name="The Category Pane Name",
  desc="Voluntary tooltip description",
  icon="path/to/category_icon.png",
  icon_off="path/to/category_icon_off.png",  -- The greyed-out unselected variant
  entities={
    {
      name="My Entity",
      desc="Voluntary tooltip description",
      path="path/to/my/entity.xml",
      image="path/to/my/entity_icon.png",  -- This should be a 16*16px icon
      post_processor=function(entity, x, y)
        -- Do anything you want with the entity or its location after it's spawned.
      end
    },
    {
      name="My Second entity",
      path="path/to/my/entity2.xml",
      image="path/to/my/entity_icon2.png",  -- This should be a 16*16px icon
    },
    -- ... and so on
  },
})
```


## Materials

Add a custom tab to the materials panel:
```lua
-- init.lua
--
if ModIsEnabled("raksa") then
  ModLuaFileAppend(
    "mods/raksa/files/scripts/lists/material_categories.lua",
    "path/to/my_materials.lua"
  )
end

-- my_materials.lua
--
table.insert(ALL_MATERIALS, {
  name="My Custom Materials",
  desc="Voluntary extra info",
  icon="path/to/category_icon.png",
  icon_off="path/to/category_icon_off.png",  -- The greyed-out unselected variant
  materials={
    {
      image="path/to/my/material_icon.png",  -- This should be a 16*16px icon
      name="My Custom Material",
      id="fire"  -- The material ID. Must match exactly materials.xml
    },
    {
      image="path/to/my/material_icon2.png",
      name="My Another Custom Material",
      id="material_something"
    },
  }
})
```


## Brushes

Add custom brushes to the brush selection. No tabs (yet).

```lua
-- init.lua
--
if ModIsEnabled("raksa") then
  ModLuaFileAppend(
    "mods/raksa/files/scripts/lists/brushes.lua",
    "path/to/my_brushes.lua"
  )
end


-- my_brushes.lua
--
table.insert(BRUSHES, {
  name="My Custom Hexagonal Filler Brush",
  desc="Voluntary extra description",
  offset_x=2,  -- Manual reticle offset, because not all reticles want to be centered.
  offset_y=2,
  reticle_file="path/to/my/reticle2.png",
  brush_file="path/to/my/brush2.png",
  icon_file="path/to/my/icon.png",
  click_to_use=true,  -- Should the brush activate upon holding or clicking. Voluntary, defaults to false.
  action=function(material, brush, x, y)
    -- Voluntary function, if you want to override the basic drawing
    -- mechanism entirely. Works with either setting on click_to_use.

    GamePrint("Active material: " .. active_material)
    GamePrint("Brush name: " .. brush.name)
    GamePrint("Mouse: "..tostring(x)..", "..tostring(y))
  end,
  release_action=function(material, brush, x, y)
    -- Voluntary function, if you want to give drawing function an extra
    -- action upon releasing the hold/click.
    GamePrint("Active material: " .. active_material)
    GamePrint("Brush name: " .. brush.name)
    GamePrint("Mouse: "..tostring(x)..", "..tostring(y))
  end
})

table.insert(BRUSHES, {
  name="My Custom 5px Brush",
  offset_x=4,
  offset_y=4,
  reticle_file="path/to/my/reticle2.png",
  brush_file="path/to/my/brush2.png",
  icon_file="path/to/my/icon.png",
})
```
