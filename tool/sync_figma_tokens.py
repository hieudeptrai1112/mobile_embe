#!/usr/bin/env python3
"""Save Figma token export JSON (paste MCP export output or pass --stdin)."""

import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "design_tokens" / "master_token.json"


def main() -> None:
    raw = sys.stdin.read() if "--stdin" in sys.argv else Path(sys.argv[1]).read_text()
    data = json.loads(raw)
    OUT.parent.mkdir(parents=True, exist_ok=True)
    payload = {
        "source": "https://www.figma.com/design/VtfMVehVniPRQ9BTYzQzdD/Master-Token",
        "collections": ["Global", "Alias"],
        "global": data.get("global", data),
        "floats": data["floats"],
        "strings": data["strings"],
        "lightColors": data["lightColors"],
        "darkColors": data["darkColors"],
    }
    OUT.write_text(json.dumps(payload, indent=2))
    print(f"Saved {OUT}")


if __name__ == "__main__":
    main()
