#!/usr/bin/env python3

import random
import getopt
import sys


usage = f"""{sys.argv[0]} [ -s|--sample-file <sample_file> |--stdout ]
    [ -o|--output-file <output_file> | --no-output ]
    [ -n|--sample-count n]
    [ -c|--frame-count k]
    [ -b|--bits b]

    -s,--sample-file <sample_file>      Output the samples to <sample_file>
    --stdout                            Output data to stdin (default)
                                        (overwrites the previous options)
    -o,--output-file <output_file>      Print expected results to <output_file>
    --no-output                         Do not print expected results (default)
                                        (overwrites the previous options)
    -n,--sample-count n=256             Generate n samples per frame
    -c,--frame-count k=1                Generate samples for k frames
    -b,--bits b=16                      Generate samples in C2 on b bits
"""

try:
    opts, args = getopt.getopt(
        sys.argv[1:],
        "s:o:n:c:b:",
        [
            "sample-file=", "stdout",
            "output-file=", "no-output",
            "sample-count=",
            "frame-count="
            "bits="
        ]
    )
except getopt.GetoptError as err:
    print(usage)
    sys.exit(2)

sample_file = False
output_file = False
N = 256
K = 1
bits = 16
for opt, val in opts:
    if opt in ("-h", "--help"):
        print(usage)
        sys.exit(0)
    if opt in ("--sample-file", "-s"):
        sample_file = val
    if opt == "--stdout":
        sample_file = False
    if opt in ("-o", "--output-file"):
        output_file = val
    if opt == "--no-output":
        output_file = False
    if opt in ("-n", "--sample-count"):
        N = int(val)
    if opt in ("-c", "--frame-count"):
        K = int(val)
    if opt in ("-b", "--bits"):
        bits = int(val)

if sample_file:
    sf = open(sample_file, "w")

if output_file:
    of = open(output_file, "w")

# For every frame
for k in range(K):
    energy = 0
    for i in range(N):
        sample = random.randrange(-2**(bits - 1), 2**(bits - 1))
        energy += sample**2
        if sample_file:
            sf.write(f"{sample}\n")
        else:
            print(sample)
    if output_file:
        of.write(f"{int(energy > N*0.05*2**(2*(bits - 1)))}\n")
