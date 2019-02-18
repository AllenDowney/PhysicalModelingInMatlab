PDF = PhysicalModelingInMatlab3.pdf

PDFFLAGS = -dCompatibilityLevel=1.4 -dPDFSETTINGS=/prepress  \
           -dCompressPages=true -dUseFlateCompression=true  \
           -dEmbedAllFonts=true -dSubsetFonts=true -dMaxSubsetPct=100

all:
	pdflatex main.tex
	mv main.pdf $(PDF)


DEST = /home/downey/public_html/greent/matlab

distrib:
	rsync -a $(PDF) html $(DEST)
	cd $(DEST)/..; sh back

