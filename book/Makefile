LATEX = latex

DVIPS = dvips

PDFFLAGS = -dCompatibilityLevel=1.4 -dPDFSETTINGS=/prepress  \
           -dCompressPages=true -dUseFlateCompression=true  \
           -dEmbedAllFonts=true -dSubsetFonts=true -dMaxSubsetPct=100

all:	book.tex
	latex book
	makeindex book
#	dvips -T 6.9in,9.8in -Ppdf -o PhysModMatlab.ps book
	dvips -Ppdf -o PhysModMatlab.ps book
	evince PhysModMatlab.ps

pdf:
	ps2pdf $(PDFFLAGS) PhysModMatlab.ps PhysModMatlab.pdf

DEST = /home/downey/public_html/greent/matlab
FILES = Makefile book.tex latexonly figs

hevea:	book.tex header.html footer.html
	rm -rf html
	mkdir html
	hevea -O -e latexonly htmlonly book
# the following line is a kludge to prevent imagen from seeing
# the definitions in latexonly
	grep -v latexonly book.image.tex > a; mv a book.image.tex
	imagen -png book
	hacha book.html
	cp up.png next.png back.png html
	mv index.html book.css book*.html book*.png *motif.gif html

distrib: 
	rm -rf tex
	mkdir tex
	rsync -a $(FILES) tex
	#rm tex/figs/*.bak
	zip -r PhysModMatlab.zip tex
	rsync -a PhysModMatlab.* html $(DEST)
	chmod -R o+r $(DEST)/*
	cd $(DEST)/..; sh back

