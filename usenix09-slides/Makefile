SVGS := figures/cpu.svg figures/disk.svg figures/server-onevm.svg \
	figures/server-vms.svg figures/file.svg figures/onevm.svg \
	figures/pool.svg figures/server-novm.svg

CVDPDFS := figures/copied-vs-dedup-0.pdf figures/copied-vs-dedup-1.pdf \
	figures/copied-vs-dedup-2.pdf

SVGPDFS = $(SVGS:.svg=.pdf)

all: slides.pdf

# Figure conversion is really touchy (both gnuplot and inkscape), so
# you have to explicitly invoke this rule to update generated figures
touchy-figures: $(CVDPDFS) $(SVGPDFS) overlays
.PHONY: touchy-figures

overlays ovldefs.tex:
	mkdir -p overlays
	./mkoverlays > ovldefs.tex
.PHONY: overlays

$(CVDPDFS): figures/copied-vs-dedup.gnuplot
	gnuplot $<

$(SVGPDFS): %.pdf: %.svg
	inkscape --export-pdf=$@ $<

#
# Non-touchy stuff
#

slides.pdf: slides.tex figdefs.tex
	rubber --pdf -Wrefs -Wboxes $<
.PHONY: slides.pdf

figdefs.tex: mkfigdefs
	./$< > $@
