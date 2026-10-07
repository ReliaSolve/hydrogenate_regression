#!/bin/bash
source init.sh
(./compare_reduce2.sh 0 > out0.txt) &
(./compare_reduce2.sh 1 > out1.txt) &
(./compare_reduce2.sh 2 > out2.txt) &
(./compare_reduce2.sh 3 > out3.txt) &
(./compare_reduce2.sh 4 > out4.txt) &
(./compare_reduce2.sh 5 > out5.txt) &
(./compare_reduce2.sh 6 > out6.txt) &
(./compare_reduce2.sh 7 > out7.txt) &

