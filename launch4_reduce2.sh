#!/bin/bash
source init.sh
(./compare_reduce2.sh 0 4 > out0.txt) &
(./compare_reduce2.sh 1 4 > out1.txt) &
(./compare_reduce2.sh 2 4 > out2.txt) &
(./compare_reduce2.sh 3 4 > out3.txt) &

