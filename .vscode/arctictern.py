"""
arctictern.py
A little script that does a big migration
"""

import json
import os
import requests
import shutil
import subprocess
import sys
from os.path import exists

COLOURS = {"red": "\033[31m",
           "blue": "\033[34m",
           "green": "\033[32m",
           "reset": "\033[0m",
           "bold": "\033[1m"}

BASE_URL = "https://raw.githubusercontent.com/Code-Institute-Org/gitpod-full-template/main/"
CURRENT_VERSION = 1.0
THIS_VERSION = 1.0


UPGRADE_FILE_LIST = [{"filename": ".vscode/settings.json",
                      "url": ".vscode/settings.json"
                      },
                     {"filename": ".vscode/launch.json",
                      "url": ".vscode/launch.json"
                      },
                     {"filename": ".gitpod.yml",
                      "url": ".gitpod.yml"
                      },
                     {"filename": ".gitpod.dockerfile",
                      "url": ".gitpod.dockerfile"
                      },
                     {"filename": ".vscode/heroku_config.sh",
                      "url": ".vscode/heroku_config.sh"
                      },
                     {"filename": ".vscode/init_tasks.sh",
                      "url": ".vscode/init_tasks.sh"
                      },
                     {"filename": ".vscode/uptime.sh",
                      "url": ".vscode/uptime.sh"
                      },
                     {"filename": ".vscode/make_url.py",
                      "url": ".vscode/make_url.py"
                     },
                     {"filename": ".vscode/arctictern.py",
                      "url": ".vscode/arctictern.py"
                     }]

FINAL_LINES = "\nexport POST_UPGRADE_RUN=1\nsource ~/.bashrc\n"


def get_versions():

    if exists(".vscode/version.txt"):
        with open(".vscode/version.txt", "r") as f:
            THIS_VERSION = float(f.read().strip())
    else:
        with open(".vscode/version.txt", "w") as f:
            f.write(str(THIS_VERSION))
    
    r = requests.get(BASE_URL + ".vscode/version.txt")
    CURRENT_VERSION = float(r.content)

    return {"this_version": THIS_VERSION,
            "current_version": CURRENT_VERSION}

def needs_upgrade():
    """
    Checks the version of the current template against
    this version.
    Returns True if upgrade is needed, False if not.
    """

    versions = get_versions()
    
    print(f"Upstream version: {versions['current_version']}")
    print(f"Local version: {versions['this_version']}")

    return versions["current_version"] > versions["this_version"]


def write_version():

    versions = get_versions()

    with open(".vscode/version.txt", "w") as f:
        f.write(str(versions["current_version"]))


def build_post_upgrade():

    r = requests.get(BASE_URL + ".vscode/upgrades.json")
    upgrades = json.loads(r.content.decode("utf-8"))
    content = ""

    for k,v in upgrades.items():
        if float(k) > THIS_VERSION:
            print(f"Adding version changes for {k} to post_upgrade.sh")
            content += v

    if content:
        content += FINAL_LINES
        with open(".vscode/post_upgrade.sh", "w") as f:
            f.writelines(content)
    
    print("Built post_upgrade.sh. Restart your workspace for it to take effect.")


def process(file, suffix):
    """
    Replaces and optionally backs up the files that
    need to be changed.
    Arguments: file - a path and filename
               suffix - the suffix to the BASE_URL
    """

    if file == ".gitpod.dockerfile" or file == ".gitpod.yml":
        try:
            shutil.copyfile(file, f"{file}.tmp")
        except FileNotFoundError:
            pass

    with open(file, "wb") as f:
        r = requests.get(BASE_URL + suffix)
        f.write(r.content)

    if exists(f"{file}.tmp"):
        result = os.system(f"diff -q {file} {file}.tmp > /dev/null")
        if result != 0:
            os.remove(f"{file}.tmp")
            return True
    
    return False


def start_migration():
    """
    Calls the process function and
    renames the directory
    """
    push_and_recreate = False

    if not os.path.isdir(".vscode"):
        print("Creating .vscode directory")
        os.mkdir(".vscode")

    for file in UPGRADE_FILE_LIST:
        print(f"Processing: {file['filename']}")
        result = process(file["filename"], file["url"])
        if result == True:
            push_and_recreate = True
    
    if push_and_recreate:
        write_version()

    if needs_upgrade() and not push_and_recreate:
        build_post_upgrade()

    print("Changes saved.")
    print("Please add, commit and push to GitHub.")
    print("You may need to stop and restart your workspace for")
    print("the changes to take effect.\n")

    if push_and_recreate:
        print(f"{COLOURS['red']}{COLOURS['bold']}*** IMPORTANT INFORMATION ***{COLOURS['reset']}")
        print("The files used to create this workspace have been updated")
        print("Please download any files that are in .gitignore and")
        print("recreate this workspace by clicking on the Gitpod button")
        print("in GitHub. Then, upload your saved files again.\n")


if __name__ == "__main__":

    print(f"\n🐦 {COLOURS['blue']}{COLOURS['bold']}ArcticTern version 0.3{COLOURS['reset']}")
    print("CI Template Migration Utility")
    print("-----------------------------")
    print("Upgrades the workspace to the latest version.\n")

    if input("Start? Y/N ").lower() == "y":
        start_migration()
    else:
        sys.exit("Migration cancelled by the user")
