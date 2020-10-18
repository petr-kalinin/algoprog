#!/usr/bin/python3

for i in range(1, 14):
    print("%3d" % i, end="")
    for j in range(4):
        if j == 3 and i % 2 == 0:
            continue
        rating = 2.5 ** (i + j / 4)
        print("%11.2f" % rating, end="")
    print("")
