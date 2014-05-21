#!/usr/bin/python

import sys, os, re

# Render graphs at 90 DPI
pdfdpi = 150
# Render figures at a reasonable size
svgdpi = 120

imgpath = sys.argv[1]
if imgpath.endswith(".image.tex"):
    imgbase = imgpath[:-len(".image.tex")]
else:
    raise RuntimeError("Source file does not end with .image.tex")

imgfile = file(imgpath)
src = imgfile.read()
imgfile.close()

ig = "(?ms)\\\\includegraphics\\[(.*?)\\]\\{(.*?)\\}"
for imgnum, (optarg, path) in enumerate(re.findall(ig, src)):
    # Parse formatting options
    scale = 1.0
    area = None
    clip = False

    opts = optarg.split(",")
    for opt in opts:
        opt = opt.strip()
        if opt == "clip":
            clip = True
            continue

        k, v = opt.split("=")
        if k == "scale":
            scale = float(v)
        elif k == "viewport":
            area = map(int, v.split())
        else:
            raise RuntimeError("Unknown key '%s'" % k)

    if area and not clip:
        raise RuntimeError("viewport without clip")

    # Prefer the original SVG
    pathb, pathe = os.path.splitext(path)
    if pathe == ".pdf" and os.path.exists(pathb + ".svg"):
        path = pathb + ".svg"

    # Construct conversion call
    outpath = "%s%03d.png" % (imgbase, imgnum+1)
    if path.endswith(".svg"):
        args = "inkscape %s -e %s -d %d" % (path, outpath, scale * svgdpi)
        if area:
            # Convert area from points to SVG "px"
            args += " -a %d:%d:%d:%d" % tuple([x*1.25 for x in area])
    elif path.endswith(".pdf"):
        #args = "convert %s -density %d %s" % (path, dpi, outpath)
        args = "pdftoppm -r %d %s | pnmtopng > %s" % (scale * pdfdpi, path, outpath)
    else:
        raise RuntimeError("Unknown extension '%s'", path)

    print args
    if os.system(args):
        raise RuntimeError("Command failed")
