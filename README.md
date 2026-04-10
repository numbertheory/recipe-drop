# RecipeDrop

**RecipeDrop** is a set of automation tools designed to transform PDF recipes into structured, valid JSON data. Using the power of the Gemini CLI, it extracts ingredients, instructions, nutritional information, and more, ensuring every output matches a strict, predefined schema.

## Quick Start

The core automation logic is located in the [`tools/`](./tools/) directory. To begin converting recipes:

1.  Gather your PDF recipes into a single folder.
2.  Install the required [dependencies](./tools/#dependencies).
3.  Run the `recipe-convert.sh` script from within that folder.

For detailed instructions on configuration, requirements, and the JSON schema, see the [Tools Documentation](./tools/).

## Features

-   **Intelligent Extraction**: Uses Gemini to accurately parse complex recipe layouts.
-   **Schema-Driven Validation**: Every JSON file is validated against a schema to ensure consistency.
-   **Robust JSON Recovery**: Includes helper scripts to extract clean JSON even from verbose model responses.
-   **Automated Batch Processing**: Simply point the tool at a folder of PDFs to begin conversion.
