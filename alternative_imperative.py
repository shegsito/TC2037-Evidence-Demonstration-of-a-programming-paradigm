words = ["word", "internationzalization", "localization"]
result = []

for w in words: 
    if len(w) > 10:
        result.append(w[0] + str(len(w) - 2) + w[-1]) #mutable state
    else: 
        result.append(w)