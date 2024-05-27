import os
import tkinter as tk
from tkinter import filedialog
import socket

def get_file_name(initial_directory):
    root = tk.Tk()
    root.withdraw()
    file_path = filedialog.askopenfilename(initialdir=initial_directory, title="Select File", filetypes=(("Text files", "*.txt"),))
    return file_path

def main():
    # Change the working directory to the directory where the script is located
    script_directory = os.path.dirname(os.path.abspath(__file__))
    os.chdir(script_directory)
    
    file_path = get_file_name(script_directory)
    if not file_path:
        exit()
    
    with open(file_path, 'r') as file:
        hosts = file.read().splitlines()

    total_hosts = len(hosts)
    print(f"Looking up DNS records for {total_hosts} hosts...please be patient...")
    text_results = []

    for index, indiv_host in enumerate(hosts, 1):
        print(f"Looking up host {index} of {total_hosts}")
        if indiv_host.strip() == "":
            single_text_result = f'""'
            text_results.append(single_text_result)
            continue

        try:
            host_entry = socket.gethostbyname_ex(indiv_host)
            single_text_result = f'"{host_entry[0]}"'
            if len(host_entry[2]) > 0:
                ips = ','.join(f'{address}' for address in host_entry[2])
                single_text_result += f',"{ips}"'
            text_results.append(single_text_result)
        except socket.gaierror:
            single_text_result = f'"{indiv_host}","Not Found"'
            text_results.append(single_text_result)

    save_file_name = "DNSLookup_Results.csv"
    with open(save_file_name, 'w', encoding='utf-8') as save_file:
        save_file.write('\n'.join(text_results))

    print(f"DNS Lookups completed. Results are stored in {save_file_name}")
    input("Press Enter to continue...")

if __name__ == "__main__":
    main()
