#!/bin/bash

# Determine the directory where this script is located
TOOLS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCHEMA_FILE="$TOOLS_DIR/schema.json"
EXTRACT_SCRIPT="$TOOLS_DIR/extract_json.py"

# Check if schema.json exists before starting
if [[ ! -f "$SCHEMA_FILE" ]]; then
    echo "Error: schema.json not found in $TOOLS_DIR."
    exit 1
fi

# Ensure python3, npx, node, and jq are available
if ! command -v python3 >/dev/null 2>&1 || ! command -v npx >/dev/null 2>&1 || ! command -v node >/dev/null 2>&1 || ! command -v jq >/dev/null 2>&1; then
    echo "Error: This script requires python3, npx, node, and jq to be installed."
    exit 1
fi

# Loop over all PDF files in the current directory
for file in *.pdf; do
    # Handle the case where no PDF files exist
    [[ -e "$file" ]] || { echo "No PDF files found."; break; }

    echo "Processing: $file..."

    # Extract the base name (filename without .pdf) for the output file
    output_file="${file%.pdf}.json"
    temp_file="${file%.pdf}.tmp.json"

    # Execute the gemini command
    # We use --output-format json to get a structured response and pipe to jq to get only the model's text.
    # We then use extract_json.py to extract exactly one JSON object from that text.
    # This prevents chatter or preamble from making the JSON file invalid.
    gemini --yolo --output-format json --prompt "Take the file \"$file\" and represent the recipe inside the PDF as a valid JSON file using the schema in \"$SCHEMA_FILE\". Return ONLY the JSON object. Do not include any markdown formatting, preamble, or postamble. Your response must be a single, valid JSON object that strictly adheres to the schema." 2>/dev/null | jq -r .response | python3 "$EXTRACT_SCRIPT" > "$temp_file"

    if [[ $? -ne 0 ]]; then
        echo "  Error: Failed to extract valid JSON for $file"
        rm -f "$temp_file"
        continue
    fi

    # Double-check the JSON file for mistakes when compared to schema.json
    echo "  Validating $file against schema..."
    npx --yes ajv-cli validate -s "$SCHEMA_FILE" -d "$temp_file" --errors=text > /tmp/ajv_errors 2>&1

    if [[ $? -eq 0 ]]; then
        mv "$temp_file" "$output_file"
        echo "  Successfully created and validated: $output_file"
    else
        echo "  Validation FAILED for: $file"
        echo "  Errors found:"
        cat /tmp/ajv_errors | sed 's/^/    /'
        # Move to a failed file for manual review instead of leaving an invalid result
        mv "$temp_file" "${file%.pdf}.failed.json"
        echo "  Failed output saved to ${file%.pdf}.failed.json"
    fi
done

echo "Done."
