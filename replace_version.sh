#!/bin/bash

# Get old and new versions
read -p "Enter old software version (major.minor.patch): " old_version
read -p "Enter new software version (major.minor.patch): " new_version

# Check if versions are valid
if ! [[ $old_version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ || $new_version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Invalid version format. Please enter in major.minor.patch format."
  exit 1
fi

# Replace versions in Markdown files
find . -name "*.md" -not -name "CHANGELOG.md" -print0 | xargs -0 sed -i "" "s/$old_version/$new_version/g"

echo "Replaced version $old_version with $new_version in all Markdown files."
