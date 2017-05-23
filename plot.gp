# output to png with decent font and image size
set terminal png font "Arial,15" size 1920,1080
set output "progress.png"

#set terminal wxt lw 2 fontscale 2

set title "Processing progress over time"
set xlabel "Time (ms)"
set ylabel "Items processed"
set key top left # put labels in top-left corner

# limit x range to 15.000 ms instead of dynamic one, must-have
# when generating few graphs that will be later compared visually
#set xrange [0:15000]

# plot series (see below for explanation)
# plot [file] with [line type] ls [line style id] [title ...  | notitle]

plot  "progress-select.log"    with steps   ls 1 lw 5 title "Select",\
      "progress-download.log"  with lines   ls 2 lw 5 title "Download",\
      "progress-extract.log"   with lines   ls 3 lw 5 title "Extract",\
      "progress-index.log"     with steps   ls 4 lw 5 title "Index"

#pause 1
#reread
