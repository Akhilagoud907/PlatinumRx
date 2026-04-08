def remove_duplicates(s):
    # Handle invalid input
    if not isinstance(s, str):
        return "Invalid input"

    result = ""

    for char in s:
        if char not in result:
            result += char

    return result


# Test cases
print(remove_duplicates("AKHILA"))   # AKHIL
print(remove_duplicates("hello"))    # helo
print(remove_duplicates(""))         # ""
print(remove_duplicates("aaaa"))     # a
print(remove_duplicates("AaAa"))     # Aa
print(remove_duplicates("a a b!"))   # a b!