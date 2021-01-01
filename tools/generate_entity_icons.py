#!/usr/bin/env python3
import sys
from datetime import date
from pathlib import Path
from xml.dom import minidom
from xml.parsers.expat import ExpatError

from PIL import Image
from PIL import ImageFont
from PIL import ImageDraw

from inputs.pickups import PICKUPS
from inputs.props import PROPS
from inputs.animals import CUSTOM_ANIMALS


IMAGE_SIZE = (16, 16)


def mod_path(destination, filename):
    return "mods/raksa/files/%s/%s" % (destination, filename)


def save_path(path, filename):
    return "%s/%s" % (path, filename)


def path_to_mod_path(destination, any_other_path):
    return mod_path(destination, Path(any_other_path).name)


def _to_lua(val):
    if not val:
        return "nil"
    return '"%s"' % val


def open_xml(xml_path, entity_path):
    try:
        return minidom.parse(xml_path)
    except ExpatError as e:
        print(f"{entity_path}: XML parsing error: {e}")
    except FileNotFoundError as e:
        print(f"{entity_path}: Error opening XML: {e}")


def parse_image_xml(entity_path, data_path):
    # Extracted data never has the main folder name
    entity_path = str(entity_path).replace("data/", "")
    xml_path = str(Path(data_path) / Path(entity_path))

    xml_file = open_xml(xml_path, entity_path)

    attr = xml_file.documentElement.attributes.get("filename")
    if not attr:
        print(f"{entity_path}: No `filename` in sprite XML")
        sys.exit(1)

    anims = xml_file.getElementsByTagName("RectAnimation")
    width, height = None, None
    for anim in anims:
        anim_name_attr = xml_file.documentElement.attributes.get("default_animation")
        anim_name = anim_name_attr.value if anim_name_attr else "default"

        if anim.attributes["name"].value == anim_name:
            width = int(anim.attributes["frame_width"].value)
            height = int(anim.attributes["frame_height"].value)
            break

    return (attr.value, width, height)


def find_possible_entity_sprites(xml_file):
    # TODO: Recurse into <Base> entities
    elements = xml_file.getElementsByTagName
    usual_elements = (
        elements("SpriteComponent")
        + elements("PixelSpriteComponent")
        + elements("PhysicsImageShapeComponent")
        + elements("AbilityComponent")
    )

    sprite = ""
    for elem in usual_elements:
        attrs = elem.attributes
        attr = attrs.get("image_file") or attrs.get("sprite_file")
        if attr:
            sprite = attr
            break

    return sprite


def parse_entity_xmls(entity, data_path):
    entity_path = entity["path"]
    image_path = entity.get("image")
    width, height = None, None  # None means we use whole image

    def full_image_path(_p):
        return Path(data_path) / str(_p).replace("data/", "")

    if image_path:
        return (full_image_path(image_path), width, height, Path(entity_path))

    xml_path = Path(data_path) / Path(entity_path)
    xml_file = open_xml(str(xml_path), entity_path)
    if not xml_file:
        return (image_path, width, height, Path(entity_path))

    sprite = find_possible_entity_sprites(xml_file)

    if sprite:
        image_path = Path(sprite.value)
        if image_path.suffix == ".xml":
            image_path, width, height = parse_image_xml(image_path, data_path)

        image_path = full_image_path(image_path)
    else:
        # Rare cases:
        # - Inheritance, where a path is not explicitly defined in the child
        # - Sprite is not defined in xml at all, but Lua (see: Vasta)
        print(f"{entity_path}: No image_file defined in XML")
        return (image_path, width, height, Path(entity_path))

    return (image_path, width, height, Path(entity_path))


def generate_icons_from_sprites(images, save_location):
    WIDTH, HEIGHT = IMAGE_SIZE

    for image_data in images:
        image_path, width_override, height_override, entity_path = image_data

        if image_path is None:
            print(f"{entity_path}: Failed to find sprite")
            continue

        if not image_path.is_file():
            print(f"{image_path}: Not a valid image file")
            continue

        # Create a copy for thumbnail()
        img = Image.open(image_path).copy()

        # Only the first frame as the image, incase of animation sheets.
        if width_override and height_override:
            img = img.crop([0, 0, width_override, height_override])

        # Trim out any transparency from edges.
        img = img.crop(img.getbbox())

        # This does a lot of nice resize-scaling magic for us.
        img.thumbnail(IMAGE_SIZE, Image.NEAREST)

        # Create a correct sized transparent icon, and paste the thumbnail
        # nicely middle-aligned to it.
        bg = Image.new("RGBA", IMAGE_SIZE, "#00000000")

        x = (WIDTH - img.width) // 2
        y = (HEIGHT - img.height) // 2
        bg.paste(img, (x, y))

        # Save the result and discard our original wip img object.
        bg.save(save_path(save_location, image_path.name))


def render_list_to_lua(items, save_location, img_mod_location):
    with open(save_location, "w+") as f:
        print("_GENERATED = {", file=f)
        for item in items:
            image_path, _, _, xml_path = item
            name = xml_path.stem.replace("_", " ").capitalize()
            if image_path:
                image_path = path_to_mod_path("gfx/" + img_mod_location, image_path)

            print(
                "  {",
                "    name=%s," % _to_lua(name),
                "    path=%s," % _to_lua("data/" + str(xml_path)),
                "    image=%s," % _to_lua(image_path),
                "  },",
                file=f,
                sep="\n",
            )
        print("}", file=f)


def main(args):
    if len(args) != 1:
        print(f"Usage: generate_entity_icons.py extracted_data/")
        sys.exit(1)

    data_path = args[0]

    # TODO: Change this hardcoded crap into JSON input parsing
    print("\nGenerating pickups...")
    images = [parse_entity_xmls(entity, data_path) for entity in PICKUPS]
    generate_icons_from_sprites(images, "../files/gfx/pickup_icons")
    render_list_to_lua(images, "../files/scripts/lists/_pickups.lua", "pickup_icons")

    print("\nGenerating props...")
    images = [parse_entity_xmls(entity, data_path) for entity in PROPS]
    generate_icons_from_sprites(images, "../files/gfx/prop_icons")
    render_list_to_lua(images, "../files/scripts/lists/_props.lua", "prop_icons")

    print("\nGenerating animals...")
    images = [parse_entity_xmls(entity, data_path) for entity in CUSTOM_ANIMALS]
    generate_icons_from_sprites(images, "../files/gfx/animal_icons")
    render_list_to_lua(images, "../files/scripts/lists/_animals.lua", "animal_icons")

    print("Done.")


if __name__ == "__main__":
    main(sys.argv[1:])
