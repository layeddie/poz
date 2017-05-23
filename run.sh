#!/bin/bash

set -e

for i in 1 2 3 4 5 6 7; do
  echo "Example ${i}"
  mix run -e "Example${i}.run"
  gnuplot plot.gp
  mv "progress.png" "progress${i}.png"
done
