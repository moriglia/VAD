#!/usr/bin/env python3

import random

# energy = 0 # For future use
for i in range(256):
    sample =  random.randrange(-2**15, 2**15)
    # energy += sample**2 # For future use
    print(sample)
