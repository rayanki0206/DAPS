#!/bin/bash

# Path to the CSV file
csv_file="subid.csv"

# Functional area provided as input
functional_area="$1"

# Check if CSV file exists
if [[ ! -f $csv_file ]]; then
    echo "CSV file not found: $csv_file"
    exit 1
fi

# Read subscription ID from CSV file based on functional area
subscription_id=$(awk -F ',' -v func="$functional_area" '$2 == func {print $3}' "$csv_file")

# Output selected subscription ID
if [[ -n $subscription_id ]]; then
    echo "$subscription_id"
else
    echo "Subscription ID not found for selected functional area."
fi
