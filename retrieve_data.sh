#!/bin/bash

# Reading the version and size from params.yml

version=$(yq '.version' params.yml)
size=$(yq ".size.\"$version\"" params.yml)

echo "version and size rad successfully"

# Use curl to fetch data from the RESTful API

api_url="https://jsonplaceholder.typicode.com/photos?_limit=$size"
curl -s "$api_url" | jq . > datahub/data.json

# Check if data is different from the current data in datahub/data.json

if cmp -s datahub/data.json datahub/data.json; then
  echo "No changes; data has not changed"
  exit 0
else
  echo "Data has been updated"
fi

