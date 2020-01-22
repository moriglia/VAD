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
    -m,--mean m=5250                    Use the mean m for the expovariate
                                        ditribution
"""

try:
    opts, args = getopt.getopt(
        sys.argv[1:],
        "s:o:n:c:b:m:d",
        [
            "sample-file=", "stdout",
            "output-file=", "no-output",
            "sample-count=",
            "frame-count="
            "bits=",
            "mean="
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
mean = 5250  # Empirical

for opt, val in opts:
    if opt in ("-h", "--help"):
        print(usage)
        sys.exit(0)
    elif opt in ("--sample-file", "-s"):
        sample_file = val
    elif opt == "--stdout":
        sample_file = False
    elif opt in ("-o", "--output-file"):
        output_file = val
    elif opt == "--no-output":
        output_file = False
    elif opt in ("-n", "--sample-count"):
        N = int(val)
    elif opt in ("-c", "--frame-count"):
        K = int(val)
    elif opt in ("-b", "--bits"):
        bits = int(val)
    elif opt in ("-m", "--mean"):
        mean = float(val)

if sample_file:
    sf = open(sample_file, "w")

if output_file:
    of = open(output_file, "w")

threshold = N*0.05*2**(2*(bits - 1))

# For every frame ...
for k in range(K):
    energy = 0

    # ... generate N samples
    for i in range(N):
        sample = round(random.choice([-1, 1])*random.expovariate(1/mean))

        # Truncate the sample if out of range
        if sample >= 2**(bits-1):
            sample = 2**(bits - 1) - 1
        elif sample < -2**(bits - 1):
            sample = -2**(bits - 1)

        # Sum its energy contribution to the total frame energy
        energy += sample**2
        if not sample_file:
            print(sample)
        else:
            sf.write(f"{sample}\n")

    # At the end of the frame (you're another frame older)
    # write the output to the output file (if any)
    if output_file:
        of.write(f"{int(energy > threshold)}\n")

if sample_file:
    sf.close()

if output_file:
    of.close()
