# Fixes the font issue on Brave browser
# Matt Rudge
# June 2021

import json
import os

BASE_PATH = os.environ.get("GITPOD_REPO_ROOT")

with open(f"{BASE_PATH}/.vscode/settings.json", "r+") as f:
    content = json.loads(f.read())

    if "terminal.integrated.fontFamily" not in content:
        content["terminal.integrated.fontFamily"] = "Menlo"
    else:
        content.pop("terminal.integrated.fontFamily")

    f.seek(0, os.SEEK_SET)
    f.write(json.dumps(content))
    f.truncate()
