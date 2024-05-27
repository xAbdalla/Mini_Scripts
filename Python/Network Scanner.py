import csv
import nmap
import tkinter as tk
from tkinter import filedialog, messagebox
from datetime import datetime

def scan_devices(ip_list, output_file):
    nm = nmap.PortScanner()
    device_info = []

    # Perform scan for each IP address
    for ip in ip_list:
        ip = ip.strip()  # Remove leading/trailing whitespace
        nm.scan(ip, arguments='-O')  # Perform OS detection
        if ip in nm.all_hosts():
            hostname = nm[ip].hostname() if 'hostname' in nm[ip] else ''
            vendor = nm[ip]['vendor'] if 'vendor' in nm[ip] else ''
            os = nm[ip]['osclass'][0]['osfamily'] if 'osclass' in nm[ip] else ''
            device_info.append({'IP': ip, 'Hostname': hostname, 'Vendor': vendor, 'OS': os})

    # Generate filename with date and time
    now = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    output_file = f"scan_results_{now}.csv"

    # Write scan results to CSV file
    with open(output_file, 'w', newline='') as csvfile:
        fieldnames = ['IP', 'Hostname', 'Vendor', 'OS']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        for device in device_info:
            writer.writerow(device)

    return output_file

def browse_file():
    filename = filedialog.askopenfilename(filetypes=[("Text files", "*.txt")])
    if filename:
        entry.delete(0, tk.END)
        entry.insert(0, filename)

def scan():
    input_file = entry.get()

    try:
        with open(input_file, 'r') as file:
            ip_list = file.readlines()
            output_file = scan_devices(ip_list, output_file)
            messagebox.showinfo('Scan Complete', f'Scan results saved to {output_file}')
    except Exception as e:
        messagebox.showerror('Error', f'An error occurred: {str(e)}')

# Create GUI
root = tk.Tk()
root.title('Network Scanner')

label = tk.Label(root, text="Select IP list file:")
label.grid(row=0, column=0)

entry = tk.Entry(root, width=50)
entry.grid(row=0, column=1)

browse_button = tk.Button(root, text="Browse", command=browse_file)
browse_button.grid(row=0, column=2)

scan_button = tk.Button(root, text="Scan", command=scan)
scan_button.grid(row=1, column=0, columnspan=3)

root.mainloop()
