import itertools, sys, random

dictionary_file = "simpledict.txt"
game_file = 'games_test.txt'

dlc = 0

minlen = 3
maxlen = 12

tsize = 1
bsize = 4
lsize = 4
rsize = 3
lettercount = tsize + bsize + lsize + rsize


def find_arrangement(a,b):
    global dlc
    seq = a + b[1:]
    nexts = zip(seq, seq[1:])
    if any([q == s for (q,s) in nexts]):
        dlc = dlc + 1
        return []

    letters = set(a + b)
    tsides = map(set, itertools.combinations(letters, tsize))
    bsides = map(set, itertools.combinations(letters, bsize))
    lsides = map(set, itertools.combinations(letters, lsize))
    rsides = map(set, itertools.combinations(letters, rsize))

    for tt in tsides:
        for bb in bsides:
            x = tt.union(bb)
            if len(x) != tsize + bsize:
                continue
            for ll in lsides:
                y = x.union(ll)
                if len(y) != tsize + bsize + lsize:
                    continue
                for rr in rsides:
                    z = y.union(rr)
                    if len(z) != tsize + bsize + lsize + rsize:
                        continue
                    tops = [(sym, 't') for sym in tt]
                    bots = [(sym, 'b') for sym in bb]
                    lefts = [(sym, 'l') for sym in ll]
                    rights = [(sym, 'r') for sym in rr]
                    locs = dict(tops + bots + lefts + rights)
                    if test_arrangement(a,b,locs):
                        return [tt, bb, ll, rr]
    print("None for", a, b)
    return []

def test_arrangement(a,b,charlocs):
    seq = a + b[1:]
    sideseq = [charlocs[x] for x in seq]
    nexts = zip(sideseq, sideseq[1:])
    return all([a != b for (a,b) in nexts])

words = []
with open(dictionary_file, 'rb') as fp:
    for line in fp.readlines():
        w = line.strip().lower()
        if len(w) > minlen and len(w) < maxlen:
            words.append(w)



twelvewords = []
for _ in range(20):
    random.shuffle(words)
    maxFind = 1
    found = 0
    for a in words:
        for b in words:
            if (a[-1] != b[0]):
                continue
            letters = set(a + b)
            if len(letters) == lettercount:
                twelvewords.append((a,b))
                found += 1
            if found == maxFind:
                break;
        if found == maxFind:
            break;

games = []
for a,b in twelvewords:
    arr = find_arrangement(a,b)
    if len(arr) != 0:
        line = ""
        random.shuffle(arr)
        for side in arr:
            side = list(side)
            random.shuffle(side)
            for letter in side:
                line += letter.upper()
            line += '\t'
        line += "{}\t{}".format(a,b)
        games.append(line)
print(len(games))

with open(game_file, 'a+') as fp:
    for g in games:
        fp.write("{}\n".format(g))

print("Added {} games.".format(len(games)))
