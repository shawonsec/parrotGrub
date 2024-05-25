#!/bin/bash

# Define file paths
original_file1="/usr/share/desktop-base/parrot-theme/login/background.jpg"
backup_file1="/usr/share/desktop-base/parrot-theme/login/background.jpg.back"

original_file2="/usr/share/images/desktop-base/login-background.jpg"
backup_file2="/usr/share/images/desktop-base/login-background.jpg.back"

# Prompt the user for the new lock screen background image
echo "Please enter the full path of the new lock screen background image:"
read new_image

# Check if the new image file exists
if [ ! -f "$new_image" ]; then
  echo "The file $new_image does not exist."
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

