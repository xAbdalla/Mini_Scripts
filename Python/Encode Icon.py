from base64 import b64encode
import sys
import pyperclip

filename = input("Enter the path to the icon file: ")
with open(filename, "rb") as f:
    pyperclip.copy(b64encode(f.read()).decode("ascii"))
    print("Copied to clipboard.")
    input("Press enter to exit.")
