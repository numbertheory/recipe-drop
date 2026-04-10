# RecipeDrop Tools

This directory contains scripts for automatically converting PDF recipes into structured JSON data using the Gemini CLI.

## Contents

-   **`recipe-convert.sh`**: The main driver script. It iterates over all PDF files in the current directory, sends them to Gemini for processing, and validates the resulting JSON.
-   **`extract_json.py`**: A Python helper script that reliably extracts the raw JSON object from the model's response, stripping away any preamble or postamble.
-   **`schema.json`**: The JSON Schema used to validate the output. It ensures consistency across all extracted recipes.

## Dependencies

Before running the conversion script, ensure you have the following installed:

1.  **[Gemini CLI](https://github.com/google/gemini-cli)**: Used to process the PDFs.
2.  **`jq`**: Used for parsing the Gemini CLI's JSON output.
3.  **`python3`**: Used by `extract_json.py`.
4.  **`node` / `npx`**: Used to run `ajv-cli` for schema validation.

## Usage

1.  Place the PDF recipes you want to convert in a directory.
2.  Ensure you have authenticated with the Gemini CLI.
3.  Run the script from the directory containing your PDFs:

    ```bash
    bash /path/to/tools/recipe-convert.sh
    ```

The script will:
-   Process each `.pdf` file.
-   Generate a `.json` file for each successful conversion.
-   Generate a `.failed.json` file if the output fails validation against `schema.json`.

## Schema

The extracted JSON follows a strict schema including:
-   **Recipe Metadata**: Title, difficulty, prep time, servings.
-   **Nutrition**: Calories, carbs, fat, protein, sodium.
-   **Ingredients**: List of required items.
-   **Equipment**: List of required tools.
-   **Instructions**: Step-by-step cooking guide.
