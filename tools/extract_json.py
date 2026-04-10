import json
import sys


def extract_json(text):
    # Find the first { and the last }
    start = text.find("{")
    end = text.rfind("}")
    if start != -1 and end != -1:
        json_str = text[start : end + 1]
        try:
            # Validate JSON
            data = json.loads(json_str)
            return json.dumps(data, indent=2)
        except json.JSONDecodeError:
            # If basic extraction fails, try to find the outermost valid JSON object
            # by scanning from start to end
            for i in range(end, start, -1):
                try:
                    candidate = text[start : i + 1]
                    data = json.loads(candidate)
                    return json.dumps(data, indent=2)
                except json.JSONDecodeError:
                    continue
    return None


if __name__ == "__main__":
    content = sys.stdin.read()
    extracted = extract_json(content)
    if extracted:
        print(extracted)
    else:
        sys.exit(1)
