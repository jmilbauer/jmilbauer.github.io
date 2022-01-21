import random

games = []
with open('games.txt', 'r') as fp:
    for line in fp.readlines():
        games.append(line)

random.shuffle(games)

with open('games.txt', 'w+') as fp:
    for g in games:
        fp.write(g)
