# Simple utility for creating the Cloudinary URL from a
# cloudinary_python.txt file
# Matt Rudge, November 2021

import re

with open("cloudinary_python.txt") as f:
    content = f.readlines()

cloud_name = re.findall(r"['](.*?)[']",content[15])[0]
api_key = re.findall(r"['](.*?)[']",content[16])[0]
api_secret = re.findall(r"['](.*?)[']",content[17])[0]

print(f"cloudinary://{api_key}:{api_secret}@{cloud_name}")
