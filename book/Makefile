PDF = PhysicalModelingInMatlab4.pdf

PDFFLAGS = -dCompatibilityLevel=1.4 -dPDFSETTINGS=/prepress  \
           -dCompressPages=true -dUseFlateCompression=true  \
           -dEmbedAllFonts=true -dSubsetFonts=true -dMaxSubsetPct=100

all:
	pdflatex main
	pdflatex main
	makeindex main
	pdflatex main
	mv main.pdf $(PDF)

distrib:
	rsync -a $(PDF) ..
	cd ..; git add $(PDF)
	git commit -m "Updating PDF"
	git push
