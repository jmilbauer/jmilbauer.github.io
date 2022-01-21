alphabet = 'abcdefghijklmnopqrstuvwxyz'

with open('2of12inf.txt', 'r') as fp:
    with open('simpledict.txt', 'w+') as fp2:
        for line in fp.readlines():
            line = line.strip().lower()
            good = True
            for l in line:
                if l not in alphabet:
                    good = False
            if good:
                fp2.write("{}\n".format(line))
