#!/bin/bash
# Watch for hydrogenate jobs that go over 10GB of virtual memory use
# and kill them.

while [ 1 ]
do
  jobs=`ps -e -o vsize,pid,command | grep hydrogenate.py`
  echo "Checking"
  echo "$jobs" | while IFS= read -r line
  do
    # Check for a line that is using more than 10GB of virtual memory
    size=`echo $line | awk '{ print $1 }'`
    if [ "$size" -gt "10000000" ]
    then
      pid=`echo $line | awk '{ print $2 }'`
      echo "  Job $pid has size $size, killing"
      kill $pid
    fi
  done

  sleep 5
done

