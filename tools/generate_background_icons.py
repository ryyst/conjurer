#!/usr/bin/env python3
import sys
from datetime import date
from pathlib import Path
import json

from PIL import Image
from PIL import ImageFont
from PIL import ImageDraw


IMAGE_SIZE = (16, 16)


def mod_path(destination, filename):
    return "mods/raksa/files/%s/%s" % (destination, filename)


def save_path(path, filename):
    return "%s/%s" % (path, filename)


def path_to_mod_path(destination, any_other_path):
    return mod_path(destination, Path(any_other_path))


def _to_lua(val):
    if not val:
        return "nil"
    return '"%s"' % val


def generate_icons_from_sprites(images, data_path, output_path):
    WIDTH, HEIGHT = IMAGE_SIZE

    for i, image in enumerate(images):
        path = Path(data_path, image["path"])
        if image.get("skip"):
            continue

        if not path.is_file():
            # print(f"{path}: Not a valid image file")
            continue

        # Create a copy for thumbnail()
        img = Image.open(path).copy()

        # Only the first frame as the image, incase of animation sheets.
        # if width_override and height_override:
        #    img = img.crop([0, 0, width_override, height_override])

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
        bg.save(save_path(output_path, f"{i}_{path.name}"))


def get_image_offsets(image_path, data_path):
    full_path = Path(data_path, image_path)
    img = Image.open(full_path)

    try:
        offset_x, offset_y, _, __ = img.convert("RGBA").getbbox()
        print(full_path, offset_x, offset_y, _, __)
    except TypeError:
        print("Error getting bbox of %s" % image_path)
        return 0, 0
    return offset_x, offset_y


def render_list_to_lua(images, data_path, save_location, output_path):
    with open(save_location, "w+") as f:
        print("_GENERATED = {", file=f)
        for i, image in enumerate(images):
            path = Path(image["path"])
            name = path.stem.replace("_", " ").capitalize()

            if image.get("skip"):
                print("Skipping image:", name)
                continue

            if path:
                image_path = path_to_mod_path(output_path, f"{i}_{path.name}")

            offset_x, offset_y = get_image_offsets(path, data_path)

            print(
                "  {",
                "    name=%s," % _to_lua(name),
                "    image=%s," % _to_lua(image_path),
                "    spawn_func=spawn_img(%s, %s, %s),"
                % (_to_lua("data/" + str(path)), offset_x, offset_y),
                "  },",
                file=f,
                sep="\n",
            )
        print("}", file=f)


def main(args):
    if len(args) != 1:
        print(f"Usage: generate_entity_icons.py input_manifest.json")
        sys.exit(1)

    json_file = args[0]

    with open(json_file, "r") as f:
        manifest = json.load(f)

    data_path = manifest["extracted_game_data_path"]
    output_file = manifest["output_lua_path"]
    output_path = manifest["output_image_directory"]
    images = manifest["data"]

    print("\nGenerating backgrounds...")
    generate_icons_from_sprites(images, data_path, "../files/" + output_path)
    render_list_to_lua(images, data_path, output_file, output_path)

    print("Done.")


if __name__ == "__main__":
    main(sys.argv[1:])
