import os, sys, re

labelFont = "Helvetica,17"
if len(sys.argv) == 2:
    pdfOut = sys.argv[1]
else:
    pdfOut = None

gpPipe = os.popen("gnuplot", "w")

def gp(str):
    print >> gpPipe, str
    if not pdfOut:
        print str

def setPdfOutput(filename):
    assert filename.endswith(".pdf")
    gp("set output '| ps2pdf -dEPSCrop - %s'" % filename)
    gp("set terminal postscript color eps enhanced 'Helvetica' 24")
    #gp("set lmargin 4")
    gp("set tmargin 0.5")
    gp("set rmargin 1")

def setXLabels(title, labels):
    gp('set xrange [0:%d]' % len(labels))
    gp('set xtics (%s)' % ",".join('"" %d' % n for n in range(len(labels)+1)))
    gp('set xtics nomirror out')
    for i, l in enumerate(labels):
        gp('set label %d "%s" at %g, graph -0.05, 0 centre norotate font "%s"'
           % (i+1,l,i+0.5,labelFont))
    gp('set xlabel "%s"' % title)

def setYLabels(title, fmt):
    gp('set yrange [0:*]')
    gp('set format  y "%s"' % (fmt))
    # gp('set ytics out format "%s" font "%s"' % (fmt, labelFont))
    gp('set ytics out font "%s"' % (labelFont))
    gp('set ylabel "%s"' % title)

def setPalette(defs):
    gp('set palette defined (%s)' % ",".join('%d "%s"' % (g,c) for g,c in defs))
    gp('unset colorbox')

def plot(series, colMargin):
    plots = []
    data = []
    boxwidth = (1.0 - colMargin)/len(series)
    for i, (label, points) in enumerate(series):
        offset = i*boxwidth + colMargin/2 + boxwidth/2
        style = "boxes fill solid 1.0 border -1 lc palette frac %g" % \
            (float(i)/(len(series)-1))
        plots.append('"-" using ($0+%g):1:(%g) title "%s" with %s' %
                     (offset, boxwidth, label, style))
        data.append("".join("%g\n" % p for p in points) + "e")
    gp('plot %s\n%s' % (",".join(plots), "\n".join(data)))

def getSeries(basename):
    points = []
    for n in range(0,9):
        path = "%s%07d" % (basename, 4096<<n)
        for line in file(path):
            m = re.match("Total From: ([0-9]+), Total To: ([0-9]+),", line)
            if m:
                fr, to = int(m.group(1)), int(m.group(2))
                points.append(100 * (1 - float(to)/float(fr)))
                break
        else:
            raise RuntimeError("Could not find counts in %s" % path)
    return points

if pdfOut:
    setPdfOutput(pdfOut)

setXLabels("Block size",
           ['%dKB' % (4<<n) for n in range(0,8)] + ["1MB"])
setYLabels("Reduction in storage space", "%g%%")
setPalette([(0, "#3990c4"), (1, "#b3d6eb")])

gp('set key Left reverse samplen 1 width -5')

series = [("DeDe",
           getSeries("data/vmware-it-vdi/offset-0/hist-")),
          ("Realigned partitions",
           getSeries("data/vmware-it-vdi/offset-3584/hist-")),
          ("Linked clones only",
           getSeries("data/vmware-it-vdi/linkedstats/linked-"))]
plot(series, 0.2)

gpPipe.flush()
if not pdfOut:
    raw_input()
if gpPipe.close():
    raise RuntimeError, "Gnuplot process returned non-zero"
