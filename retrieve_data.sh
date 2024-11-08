#!/bin/bash

# Reading the version and size from params.yml
version=$(yq '.version' params.yml)
size=$(yq ".size.\"$version\"" params.yml)

echo "Version: $version"
echo "Size: $size"

# Use curl to fetch data from the RESTful API and save it to a temporary file
api_url="https://jsonplaceholder.typicode.com/photos?_limit=$size"
temp_file=$(mktemp)  # Create a temporary file
curl -s "$api_url" | jq . > "$temp_file"

# Check if the new data is different from the current data in datahub/data.json
if cmp -s "$temp_file" datahub/data.json; then
  echo "No changes; data has not changed"
  rm "$temp_file"  # Remove the temporary file
  exit 0
else
  echo "Data has been updated"
  mv "$temp_file" datahub/data.json  # Move the new data to datahub/data.json
fi

# Count the number of rows in datahub/data.json
row_count=$(jq length datahub/data.json)
echo "Number of rows in data.json: $row_count"

