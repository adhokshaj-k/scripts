def caesar_cipher(s, shift):
    result = ""
    for c in s:
        if 'A' <= c <= 'Z':
            result += chr((ord(c) - 65 + shift) % 26 + 65)
        elif 'a' <= c <= 'z':
            result += chr((ord(c) - 97 + shift) % 26 + 97)
        else:
            result += c
    return result

encoded_string = "uYorl fa g:EpnX{5JU7H_T33_B6N1N1}N6"
decoded_string = caesar_cipher(encoded_string, 3)

print(decoded_string)
