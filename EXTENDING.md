# The Conjurer Extension System

The mod has been built to be easily extendable by other mods. You can add items to any of the basic lists
straight from your own mod, via the following ways:


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
  name="My Custom Hexagonal Brush",
  desc="Voluntary extra description",
  offset_x=2,  -- The reticle offset.
  offset_y=2,
  reticle_file="path/to/my/reticle2.png",
  brush_file="path/to/my/brush2.png",
  icon_file="path/to/my/icon.png",
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
