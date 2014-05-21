# CDF of non-offset block frequencies

set output '| ps2pdf -dEPSCrop - figures/copied-vs-dedup.pdf'
set terminal postscript color eps enhanced 'Helvetica' 24
#set lmargin 4
set tmargin 0.5
set rmargin 1

set ytics out font "Helvetica,17"
set xtics out font "Helvetica,17"

set key Left reverse samplen 2

# set key off
set ylabel "Average boot time (secs)"
set xlabel "# VMs booting concurrently"
set xrange [1:20]
set pointsize 2
# Original: #3990c4 #507515 #8cc63e
plot "data/copied-vs-dedup/copied-vs-dedup.data" using 1:2 title "Fully copied" with linespoints lw 4 lc rgb "#1c4862" pt 3, \
     "data/copied-vs-dedup/copied-vs-dedup.data" using 1:3 title "Cold dedup" with linespoints lw 4 lt 1 lc rgb "#283a0a" pt 1, \
     "data/copied-vs-dedup/copied-vs-dedup.data" using 1:4 title "Warm dedup" with linespoints lw 4 lt 3 lc rgb "#46631f" pt 4
