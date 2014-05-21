# CDF of non-offset block frequencies

set terminal postscript color eps enhanced 'Helvetica' 32 size 6,3.5
#set lmargin 4
set tmargin 2
# Try to balance graph in the center
set rmargin 4

set ytics nomirror in font "Helvetica,24"
set xtics nomirror in font "Helvetica,24"
set border 3

set key left Left reverse samplen 2

# set key off
set title "VDI \"boot storm\""
set ylabel "Average boot time (secs)"
set xlabel "# VMs booting concurrently"
set xrange [1:20]
set yrange [0:90]
set pointsize 2

set output '| ps2pdf -dEPSCrop - figures/copied-vs-dedup-0.pdf'
# Give it something to plot
plot 1/0 title ""

set output '| ps2pdf -dEPSCrop - figures/copied-vs-dedup-1.pdf'
plot "data/copied-vs-dedup/copied-vs-dedup.data" using 1:2 title "Full copies" with linespoints lw 6 lc rgb "#3990c4" pt 7

set output '| ps2pdf -dEPSCrop - figures/copied-vs-dedup-2.pdf'
replot "data/copied-vs-dedup/copied-vs-dedup.data" using 1:3 title "Deduplicated" with linespoints lw 6 lt 1 lc rgb "#8cc63e" pt 7
