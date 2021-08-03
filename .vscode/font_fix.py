# Fixes the font issue on Brave browser
# Matt Rudge
# August 2021

import json
import os

BASE_PATH = os.environ.get("GITPOD_REPO_ROOT")

with open(f"{BASE_PATH}/.vscode/settings.json", "r+") as f:
    content = json.loads(f.read())

    if "terminal.integrated.fontFamily" not in content:
        print("Adding wider and higher font settings")
        content["terminal.integrated.lineHeight"] = 1.2
        content["terminal.integrated.letterSpacing"] = 2
    else:
        print("Wider and higher font settings already added!")

    f.seek(0, os.SEEK_SET)
    f.write(json.dumps(content))
    f.truncate()
