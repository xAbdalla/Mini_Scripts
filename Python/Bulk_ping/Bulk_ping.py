import os

input_file = "ping_list.txt"
output_file = "ping_output.csv"

if not os.path.exists(input_file):
    print("Input file not found")
    exit()

with open(input_file) as file:
    ip_list = file.read()
    ip_list = ip_list.splitlines()
    # print(ip_list[:])

if not ip_list:
    print("No IP addresses found in the input file")
    exit()

with open(output_file, "w") as file:
    file.write("IP,Status\n")

for ip in ip_list:
    response = os.popen(f"ping -n 2 {ip} ").read()

    if " TTL=" not in response:
        # print(response)
        f = open(output_file, "a")
        f.write(str(ip) + ',down\n')
        print(f"DOWN\t'{ip}'")
        f.close()
    else:
        # print(response)
        f = open(output_file, "a")
        f.write(str(ip) + ',up\n')
        print(f"UP  \t'{ip}'")
        f.close()

    # print("=" * 30)

# with open(output_file) as file:
#     output = "\t".join(file.read().split(",")).upper()

# print(output)
