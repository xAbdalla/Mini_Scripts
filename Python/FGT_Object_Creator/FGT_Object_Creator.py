import time
from csv import DictReader
from tkinter import E
import paramiko
import getpass

while True:
  ip = input("Enter the FortiGate IP: ")
  username = input("Enter your username: ")
  password = getpass.getpass()
  ssh = paramiko.SSHClient()
  ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
  try:
    ssh.connect(ip, 22, username, password)
    if ssh.get_transport().is_active() == True:
      break
  except:
    print("Invalid credentials, please try again\n")
    continue

ssh_shell = ssh.invoke_shell()

print()
while True:
  filename = input("Enter your filename: ")
  try:
    with open(filename , 'r') as csv_file:
      ip_details = DictReader(csv_file)
      if "name" not in ip_details.fieldnames or "subnet" not in ip_details.fieldnames or "group" not in ip_details.fieldnames:
        print("Invalid file columns (name, subnet, and group), please edit the file headers and try again\n")
        continue
    
      print()
      print("-"*50)
      print()

      for row in ip_details:
        if "/" not in row["subnet"] and "-" not in row["subnet"] and "," not in row["subnet"]:
          subnet = row["subnet"] + "/32"
        else:
          subnet = row["subnet"]

        ssh_shell.send("config firewall address\n")
        ssh_shell.send(f"edit {row["name"]}\n")
        ssh_shell.send(f"set subnet {subnet}\n")
        ssh_shell.send("next\n")
        ssh_shell.send("end\n")
        print(f"{row["name"]} object has been created with subnet {row["subnet"]}")
        time.sleep(0.2)
        _ = ssh_shell.recv(1000).decode('utf-8')

        if row["group"] != "":
          ssh_shell.send("config firewall addrgrp\n")
          ssh_shell.send(f"edit {row["group"]}\n")
          ssh_shell.send(f"append member {row["name"]}\n")
          ssh_shell.send("next\n")
          ssh_shell.send("end\n")
          print(f"{row["name"]} object has benn added to group {row["group"]}")
          time.sleep(0.2)
          _ = ssh_shell.recv(1000).decode('utf-8')

        print("-"*50)
      break
  except Exception as e:
    print(e)
    print("Invalid filename, please try again\n")
    continue