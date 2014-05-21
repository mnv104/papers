# CDF of non-offset block frequencies

set output '| ps2pdf -dEPSCrop - figures/vmware-it-vdi-cdf.pdf'
set terminal postscript color eps enhanced 'Helvetica' 24
#set lmargin 4
set tmargin 0.5
set rmargin 1    # Otherwise, X axis labels get trimmed

set logscale x
# set key off
set ylabel "Fraction of deduplicated blocks"
#set xlabel "Cumulative reference count"
set xlabel "Maximum reference count"
# Make ylabel align with other graphs
set ylabel offset 1,0

unset colorbox
set cbrange [0:9]

set format y '%g%%'
set ytics out font "Helvetica,17"
set xtics out font "Helvetica,17"

set key Left reverse samplen 2

four(x)=100*x/61497555.0
eight(x)=100*x/38091978
sixteen(x)=100*x/23448677
thirtytwo(x)=100*x/14341466
sixtyfour(x)=100*x/8543555
onetwentyeight(x)=100*x/4960704
twofiftysix(x)=100*x/2845160
fivetwelve(x)=100*x/1604085
onemeg(x)=100*x/887831

endlt=1
endlw=4
midlt1=2
midlt2=5
midlw=3

plot [x=1:1000] \
     "< awk '/^ *[0-9]/{sum+=$1; print $3, sum}' data/vmware-it-vdi/offset-0/hist-1048576" using 1:(onemeg($2)) title "1MB" with lines lc palette cb 8 lt endlt lw endlw, \
     "< awk '/^ *[0-9]/{sum+=$1; print $3, sum}' data/vmware-it-vdi/offset-0/hist-0524288" using 1:(fivetwelve($2)) title "512KB" with lines lc palette cb 7 lt midlt1 lw midlw, \
     "< awk '/^ *[0-9]/{sum+=$1; print $3, sum}' data/vmware-it-vdi/offset-0/hist-0262144" using 1:(twofiftysix($2)) title "256KB" with lines lc palette cb 6 lt midlt2 lw midlw, \
     "< awk '/^ *[0-9]/{sum+=$1; print $3, sum}' data/vmware-it-vdi/offset-0/hist-0131072" using 1:(onetwentyeight($2)) title "128KB" with lines lc palette cb 5 lt midlt1 lw midlw, \
     "< awk '/^ *[0-9]/{sum+=$1; print $3, sum}' data/vmware-it-vdi/offset-0/hist-0065536" using 1:(sixtyfour($2)) title "64KB" with lines lc palette cb 4 lt midlt2 lw midlw, \
     "< awk '/^ *[0-9]/{sum+=$1; print $3, sum}' data/vmware-it-vdi/offset-0/hist-0032768" using 1:(thirtytwo($2)) title "32KB" with lines lc palette cb 3 lt midlt1 lw midlw, \
     "< awk '/^ *[0-9]/{sum+=$1; print $3, sum}' data/vmware-it-vdi/offset-0/hist-0016384" using 1:(sixteen($2)) title "16KB" with lines lc palette cb 2 lt midlt2 lw midlw, \
     "< awk '/^ *[0-9]/{sum+=$1; print $3, sum}' data/vmware-it-vdi/offset-0/hist-0008192" using 1:(eight($2)) title "8KB" with lines lc palette cb 1 lt midlt1 lw midlw, \
     "< awk '/^ *[0-9]/{sum+=$1; print $3, sum}' data/vmware-it-vdi/offset-0/hist-0004096" using 1:(four($2)) title "4KB" with lines lc palette cb 0 lt endlt lw endlw
