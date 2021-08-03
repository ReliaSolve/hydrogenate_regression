#!/bin/bash
source init.sh
(./compare.sh 0 > out0.txt) &
(./compare.sh 1 > out1.txt) &
(./compare.sh 2 > out2.txt) &
(./compare.sh 3 > out3.txt) &
(./compare.sh 4 > out4.txt) &
(./compare.sh 5 > out5.txt) &
(./compare.sh 6 > out6.txt) &
(./compare.sh 7 > out7.txt) &

