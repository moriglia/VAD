# Voice Activity Detector
University Educational Project: implementation of a Voice Activity Detector.
It has been assigned by Prof. L. Fanucci, teaching
_Electronics and Communications Systems_
for the Computer Engineering Master Courses
and _Microelectronics for Telecommunications_
for the Teleccomunications Engineering Master Courses,
both at University of Pisa. The assegnees are Mancini R. and Origlia M.

## Testing
```bash
# move to utils folder
cd hdl/utils
./generate_test.py -s samples.in -o samples.out
# type "./generate_test.py --help" for further details

# move to ghdl folder
cd ../../ghdl

make elaborate

# run simulation
ghdl -r vad_tb --fst=vad_tb.fst < samples.in | diff - samples.out

# inspect waveforms
gtkwave vad_tb.fst 2>/dev/null 1>&2 &
```

## Cleanup
```bash
# In ghdl folder
make clean
```
