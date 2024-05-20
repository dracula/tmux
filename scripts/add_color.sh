#!/bin/bash

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 color_name hex_value"
    exit 1
fi

color_name="$1"
hex_value="$2"

colors_file=$current_dir/colors.sh

# Validate color name is in snake_case for consistency
if ! [[ $color_name =~ ^[a-z0-9]+(_[a-z0-9]+)*$ ]]; then
    echo "Error: Color name must be in snake_case."
    exit 4
fi

# Validate hex value is a valid hex color
if ! [[ $hex_value =~ ^#[0-9a-fA-F]{6}$ ]]; then
    echo "Error: Hex value must start with '#' followed by exactly 6 hexadecimal characters."
    exit 5
fi

# Check if the color name already exists in the file
if grep -q "^${color_name}=" "$colors_file"; then
    echo "The color name $color_name already exists in $colors_file."
    exit 2
fi

# Check if the hex value already exists in the file, regardless of color name
if grep -q "='${hex_value}'$" "$colors_file"; then
    echo "The hex value $hex_value already exists in $colors_file under a different color name."
    exit 3
fi


echo -e "\t${color_name}='${hex_value}'" >> "${colors_file}"

svg_content="<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>
<!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\" \"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\">
<svg width=\"100%\" height=\"100%\" viewBox=\"0 0 31 31\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" xml:space=\"preserve\" xmlns:serif=\"http://www.serif.com/\" style=\"fill-rule:evenodd;clip-rule:evenodd;stroke-linejoin:round;stroke-miterlimit:2;\">
<path d=\"M30.54,15.87c0,-3.978 -1.58,-7.793 -4.392,-10.605c-2.813,-2.813 -6.628,-4.393 -10.606,-4.393l-0.004,-0c-3.977,-0 -7.792,1.58 -10.605,4.393c-2.812,2.812 -4.393,6.627 -4.393,10.605l0,0.004c0,3.977 1.581,7.792 4.393,10.605c2.813,2.813 6.628,4.393 10.605,4.393l0.004,-0c3.978,-0 7.793,-1.58 10.606,-4.393c2.812,-2.813 4.392,-6.628 4.392,-10.605l0,-0.004Z\" style=\"fill:${hex_value};\"/>
</svg>"

assets_dir=$current_dir/../assets/colors
svg_file="${assets_dir}/${color_name}.svg"

echo "${svg_content}" > "${svg_file}"

echo "Color ${color_name} with hex value ${hex_value} added successfully."


