#!/usr/bin/env python3
from sys import stdin, stdout, exit
import emoji

ourinput = stdin.read()

for ch in ourinput:
    if emoji.is_emoji(ch):
        stdout.write(emoji.demojize(ch))
    else:
        stdout.write(ch)
stdout.write('\n')
exit(0)

