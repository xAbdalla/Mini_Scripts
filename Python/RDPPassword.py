import sys, os, getpass, subprocess

def InsertPassword(rdpfile, user, password):
    fileIn = open(rdpfile, "r", encoding="'utf_16_le")
    lines = fileIn.read().splitlines()
    fileIn.close()
    outLines = []
    bPromptCredentials = False
    bUsername = False
    bPassword = False
    for line in lines:
        if line.lower().startswith('promptcredentialonce:i:'):
            outLines.append('promptcredentialonce:i:1')
            bPromptCredentials = True
        elif line.lower().startswith('username:s:'):
            outLines.append('username:s:%s' % user)
            bUsername = True
        elif line.lower().startswith('password 51:b:'):
            outLines.append('password 51:b:%s' % password)
            bPassword = True
        elif len(line)>0:
            outLines.append(line)
    if not bPromptCredentials:
        outLines.append('promptcredentialonce:i:1')
    if not bUsername:
            outLines.append('username:s:%s' % user)
    if not bPassword:
            outLines.append('password 51:b:%s' % password)
    
    fileOut = open(rdpfile, "w", encoding="utf_16_le")
    for line in outLines:
        #fileOut.write("%s%s" % (line, os.linesep))
        fileOut.write("%s%s" % (line, '\n'))
        #print("#%s#"%line)
    fileOut.close()

def RunShell(command):
    PSEXE = r'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe'
    PSRUNCMD = "Invoke-Command -ScriptBlock "
    process = subprocess.run([PSEXE, PSRUNCMD + "{" + command + "}"], stdout = subprocess.PIPE, stderr = subprocess.PIPE, universal_newlines = True)
    #print("CMD", command)
    #print("ERR", process.stderr)
    #print("OUT", process.stdout)
    return process.stdout

print("\nRDP Password Inserter\n")
print("This script will insert the username and password into the RDP file.")
print("The password will be encrypted into byte stream and stored in the RDP file.")
print("The encrypted password can be used only on the same machine where it was created.")
print("Note: The byte stream can be decrypted, so keep the RDP file secure.")
print()

while True:
    if (len(sys.argv) != 2):
        RDP_file = input("Enter the RDP file: ")
    else:
        RDP_file = sys.argv[1]

    if not os.path.exists(RDP_file):
        print("\nFile '%s' not found.\n" % RDP_file)
        exit(1)

    if not RDP_file.lower().endswith(".rdp"):
        print("\nFile '%s' is not RDP file.\n" % RDP_file)
        exit(1)

    print("\nInserting username/password into '%s'" % RDP_file)
    username = input("Username: ")
    password = input("Password: ")

    #use this if you do not want the password to be seen while typing
    # while True:
    #     password = getpass.getpass("Password: ")
    #     password2 = getpass.getpass("Confirm Password: ")
    #     if password == password2:
    #         break
    #     else:
    #         print("Passwords do not match. Please try again.\n")

    PassCmd = "('%s' | ConvertTo-SecureString -AsPlainText -Force) | ConvertFrom-SecureString;" % password
    password = RunShell(PassCmd)

    InsertPassword(RDP_file, username, password)

    print("\nDone.\n")

    x = input("Do you want to edit another RDP file? (Y/N): ")
    if x.lower() in ["y", "yes", "1"]:
        print("="*50, end="\n\n")
        continue
    else:
        break