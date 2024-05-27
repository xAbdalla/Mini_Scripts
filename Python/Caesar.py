def encrypt(text, s):
    result = ""
    # transverse the plain text
    for i in range(len(text)):
        char = text[i]
        # Encrypt uppercase characters in plain text
        if char.isupper():
            result += chr((ord(char) + s - 65) % 26 + 65)
        # Encrypt lowercase characters in plain text
        elif char.islower():
            result += chr((ord(char) + s - 97) % 26 + 97)
        else:
            result += char
    return result


# check the above function
text = input("Enter your text")
s = 13  # ROT13

for s in range(27):
    if "flag" in encrypt(text, s):
        print("Plain Text : " + text)
        print("Shift pattern : " + str(s))
        print("Cipher: " + encrypt(text, s))
        break
