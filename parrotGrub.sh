#!/bin/bash

# Check if the themes folder exists in /usr/share/grub and delete it if it does
if [ -d /usr/share/grub/themes ]; then
    echo "Deleting existing themes folder..."
    sudo rm -rf /usr/share/grub/themes
fi

# Create the themes folder
echo "Creating themes folder..."
sudo mkdir -p /usr/share/grub/themes

# Prompt the user for the GRUB background image using zenity
background_image=$(zenity --file-selection --title="Select GRUB Background Image")

# Check if the user cancelled the selection
if [ -z "$background_image" ]; then
    echo "No image selected. Exiting..."
    exit 1
fi

# Check if the file exists
if [ ! -f "$background_image" ]; then
    echo "The selected file does not exist. Exiting..."
    exit 1
fi

# Copy the selected image to the themes folder
echo "Copying the background image to /usr/share/grub/themes/"
sudo cp "$background_image" /usr/share/grub/themes/

# Extract the image file name
background_image_name=$(basename "$background_image")

# Create the theme.txt file under the themes folder with the specified content
echo "Creating theme.txt file..."
sudo tee /usr/share/grub/themes/theme.txt > /dev/null <<EOL
# Global Property
title-text: ""
desktop-image: "$background_image_name"
desktop-color: "#2f5595"
terminal-left: "0"
terminal-top: "0"
terminal-width: "100%"
terminal-height: "100%"
terminal-border: "0"

# Show the boot menu
+ boot_menu {
  left = 25%
  top = 25%
  width = 50%
  height = 60%
  item_color = "#00BE95"
  selected_item_color = "#6100FF"
  icon_width = 0
  icon_height = 0
  item_icon_space = 10
  item_height = 36
  item_padding = 0
  item_spacing = 5
  selected_item_pixmap_style = "select_*.png"
}

# Show a countdown message using the label component
+ label {
  top = 95%
  left = 35%
  width = 30%
  align = "center"
  id = "__timeout__"
  text = "Booting in %d seconds"
  color = "#ffffff"
}
EOL

# Remove existing GRUB_THEME and GRUB_BACKGROUND lines if present
sudo sed -i '/^GRUB_THEME=/d' /etc/default/grub
sudo sed -i '/^GRUB_BACKGROUND=/d' /etc/default/grub

# Add the specified lines to the /etc/default/grub file
echo "Updating /etc/default/grub file..."
sudo tee -a /etc/default/grub > /dev/null <<EOL

#GRUB_INIT_TUNE="480 440 1"
GRUB_THEME="/usr/share/grub/themes/theme.txt"
GRUB_BACKGROUND="/usr/share/grub/themes/$background_image_name"
EOL

# Update GRUB configuration
echo "Updating GRUB configuration..."
sudo update-grub

echo "Custom GRUB theme configuration created and applied successfully."
