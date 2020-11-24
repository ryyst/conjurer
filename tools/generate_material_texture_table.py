#!/usr/bin/env python3
import sys
from datetime import date
from pathlib import Path
from xml.dom import minidom
from xml.parsers.expat import ExpatError

from PIL import Image
from PIL import ImageFont
from PIL import ImageDraw


IMAGE_SIZE = (15, 15)


def lua_path(filename):
    return "mods/raksa/files/gfx/material_icons/%s" % filename


def save_path(filename):
    return "material_icons/%s" % filename


def _to_lua(val):
    if not val:
        return "nil"
    return '"%s"' % val


def _normalize_color(color):
    """Noita uses ARGB instead of RGBA, so we gotta swap around a bit."""
    return "#%s" % (color[2:].lower())


def open_xml(path):
    try:
        return minidom.parse(path)
    except ExpatError as e:
        print("XML parsing error:", e)
        sys.exit(1)
    except FileNotFoundError as e:
        print("Error opening XML:", e)
        sys.exit(1)


def _get_texture_path(elem):
    texture = None

    maybe_graphics = list(
        filter(lambda child: child.localName == "Graphics", elem.childNodes)
    )
    graphics = maybe_graphics[0] if len(maybe_graphics) else None
    if graphics is not None:
        try:
            texture = graphics.attributes["texture_file"].value
        except KeyError:
            pass

    return texture


def _generate_simple_texture(color, name):
    # Generate an image of IMAGE_SIZE and of specified color
    filename = "%s_colorgen.png" % name
    img = Image.new("RGBA", IMAGE_SIZE, color)
    draw = ImageDraw.Draw(img)
    img.save(save_path(filename))

    return lua_path(filename)


def _replace_stem(name):
    """Return the filename in a "human readable" format."""
    return lua_path(Path(name).name)


def parse_materials_xml(xml_path):
    xml_file = open_xml(xml_path)

    cell_data = xml_file.getElementsByTagName("CellData")
    cell_data_children = xml_file.getElementsByTagName("CellDataChild")

    elements = cell_data + cell_data_children

    line_data = []
    for elem in elements:
        attrs = elem.attributes
        texture = _get_texture_path(elem)
        color = _normalize_color(attrs["wang_color"].value)
        name = attrs["name"].value

        path = (
            _replace_stem(texture) if texture else _generate_simple_texture(color, name)
        )

        line_data.append((name, path))

    return line_data


def render_biomes(biomes):
    # Sort alphabetically
    biomes = sorted(biomes, key=lambda k: k[0].lower())

    # TODO: This will still break with odd sizes, the +1 is just an
    #       emergency fix for this specific length.
    column_size = int(len(biomes) / 3) + 1
    biomes_by_columns = [
        biomes[i : i + column_size] for i in range(0, len(biomes), column_size)
    ]

    print("MATERIAL_ICONS = {")
    for col, column in enumerate(biomes_by_columns):
        for row, data in enumerate(column):
            name, path = data
            print('  ["%s"] = %s,' % (name, _to_lua(path)))
    print("}")


def resize_textures(materials_gfx):
    for path in Path(materials_gfx).iterdir():
        if path.is_file() and path.suffix == ".png":
            img = Image.open(path)
            resized = img.resize(IMAGE_SIZE, Image.NEAREST)
            resized.save(save_path(path.name))


def main(args):
    if len(args) != 2:
        print(f"Usage: generate_material_texture_table.py materials.xml materials_gfx/")
        sys.exit(1)

    materials_file, textures_path = args

    materials = parse_materials_xml(materials_file)

    resize_textures(textures_path)
    render_biomes(materials)


if __name__ == "__main__":
    main(sys.argv[1:])
