'''
Python script which prints the next information into a text file (a.k.a
the artifact):
i) Current date & time
OS name & version
'''

import platform
import os
from datetime import datetime

# Get current date and time
current_datetime = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

# Get OS information
os_name = platform.system()
os_version = platform.version()

print (os.environ("PWD"))
print (os.environ("PATH"))


# Compose information string
info_string = f"Current Date & Time: {current_datetime}\n"
info_string += f"OS Name: {os_name}\n"
info_string += f"OS Version: {os_version}\n"

# Write information to text file
with open("artifact.txt", "w") as file:
    file.write(info_string)

print("Information written to artifact.txt successfully.")

if not os.path.isfile("artifact.txt"):
    print('File does not exist.')

print ("file is exist: ",os.path.isfile("artifact.txt"))