def Defang_URL(url):
    return url.lower().replace("[.]", ".").replace(".", "[.]").replace("http://", "hxxp[://]").replace("https://", "hxxps[://]")


def Refang_URL(url):
    return url.lower().replace("[.]", ".").replace("hxxp[://]", "http://").replace("hxxps[://]", "https://")


URL = input("Enter the URL: ")
while True:
    op = input("Defang (D) / Refang (R): ").lower()
    if op == "d":
        URL = Defang_URL(URL)
        break
    elif op == "r":
        URL = Refang_URL(URL)
        break
    else:
        print("Wrong operation!")
print("Your URL is:", URL)
