import os
import tkinter as tk
from tkinter import filedialog, messagebox
import socket
import threading
import subprocess
from datetime import datetime


def get_file_name():
    file_path = filedialog.askopenfilename(title="Select File", filetypes=(("Text files", "*.txt"), ("All files", "*.*")))
    return file_path


def perform_dns_lookup(file_path):
    if not file_path:
        return

    with open(file_path, 'r') as file:
        hosts = file.read().splitlines()

    total_hosts = len(hosts)
    results = []

    for index, indiv_host in enumerate(hosts, 1):
        if indiv_host.strip() == "":
            results.append(("", "", ""))
            continue

        try:
            host_entry = socket.gethostbyname_ex(indiv_host)
            hostname = host_entry[0]
            ip_addresses = ', '.join(host_entry[2])
            pingable = is_pingable(ip_addresses.split(',')[0])  # Check if the first IP address is pingable
            results.append((hostname, ip_addresses, pingable))
        except socket.gaierror:
            results.append((indiv_host, "", "Not Pingable"))
    
    save_results(results, script_directory)
    return results


def is_pingable(ip_address):
    try:
        subprocess.check_output(["ping", "-n", "1", ip_address], stderr=subprocess.STDOUT, timeout=2)
        return "Pingable"
    except subprocess.CalledProcessError as e:
        print("Ping failed with error:", e.output.decode())
        return "Not Pingable"
    except subprocess.TimeoutExpired:
        return "Timeout"
    except Exception as e:
        print("An error occurred:", str(e))
        return "Error"


def save_results(results, script_directory):
    now = datetime.now()
    timestamp = now.strftime("%Y-%m-%d_%H-%M-%S")
    save_file_name = os.path.join(script_directory, f"DNSLookup_Results_{timestamp}.csv")
    with open(save_file_name, 'w', encoding='utf-8') as save_file:
        save_file.write("Hostname,IP Addresses,Ping\n")
        for hostname, ip_addresses, pingable in results:
            save_file.write(f'"{hostname}","{ip_addresses}","{pingable}"\n')
    messagebox.showinfo("Success", f"DNS Lookups completed. Results are stored in {save_file_name}")


def perform_lookup_thread():
    file_path = file_path_entry.get()
    threading.Thread(target=perform_dns_lookup, args=(file_path,)).start()


def browse_file():
    file_path_entry.delete(0, tk.END)
    file_path_entry.insert(0, get_file_name())


# Hide console window
root = tk.Tk()

script_directory = os.path.dirname(os.path.abspath(__file__))

root.title("DNS Lookup")

file_path_label = tk.Label(root, text="Select File:")
file_path_label.grid(row=0, column=0, padx=5, pady=5)

file_path_entry = tk.Entry(root, width=50)
file_path_entry.grid(row=0, column=1, padx=5, pady=5)

browse_button = tk.Button(root, text="Browse", command=browse_file)
browse_button.grid(row=0, column=2, padx=5, pady=5)

perform_button = tk.Button(root, text="Perform DNS Lookup", command=perform_lookup_thread)
perform_button.grid(row=1, column=0, columnspan=3, padx=5, pady=5)

root.mainloop()
