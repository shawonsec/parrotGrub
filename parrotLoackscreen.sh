#!/bin/bash

# Check if zenity is installed
if ! command -v zenity &> /dev/null; then
  echo "zenity could not be found. Please install zenity to use this script."
  exit 1
fi

# Define file paths
original_file1="/usr/share/desktop-base/parrot-theme/login/background.jpg"
backup_file1="/usr/share/desktop-base/parrot-theme/login/background.jpg.back"

original_file2="/usr/share/images/desktop-base/login-background.jpg"
backup_file2="/usr/share/images/desktop-base/login-background.jpg.back"

# Prompt the user to select the new lock screen background image
new_image=$(zenity --file-selection --title="Select New Lock Screen Background Image" --file-filter="Images | *.jpg *.jpeg *.png")

# Check if the user cancelled the dialog
if [ $? -ne 0 ]; then
  echo "No file selected. Exiting."
  exit 1
fi

# Check if the new image file exists
if [ ! -f "$new_image" ]; then
  echo "The selected file does not exist."
  exit 1
fi

# Create backups of the original images
echo "Creating backups..."
sudo cp "$original_file1" "$backup_file1"
sudo cp "$original_file2" "$backup_file2"

# Replace the original images with the new image
echo "Replacing the original images with the new image..."
sudo cp "$new_image" "$original_file1"
sudo cp "$new_image" "$original_file2"

echo "Lock screen background images have been updated successfully."

exit 0
