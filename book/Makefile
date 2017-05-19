PDFFLAGS = -dCompatibilityLevel=1.4 -dPDFSETTINGS=/prepress  \
           -dCompressPages=true -dUseFlateCompression=true  \
           -dEmbedAllFonts=true -dSubsetFonts=true -dMaxSubsetPct=100

# Generate and open Postscript file (doesn't clean up temp files).
# Likely you'll need to compile three times to get table of contents
# working.
all:	book.tex
	latex book
	makeindex book
#	dvips -T 6.9in,9.8in -Ppdf -o PhysModMatlab.ps book
	dvips -Ppdf -o PhysModMatlab.ps book
	evince PhysModMatlab.ps

# Convert Postscript to pdf
pdf:
	ps2pdf $(PDFFLAGS) PhysModMatlab.ps PhysModMatlab.pdf


PDF_DEST=~/Desktop/[Allen_Downey]_Physical_Modeling_in_Matlab.pdf

# Generate the book from scratch as a pdf (using static margins); throw
# the generated pdf on the user's desktop and clean up after. Be as
# quiet as possible.
pdfbook:	book.tex
	sed 's/ass{boo/ass[oneside]{boo/g' book.tex > tempbook_.tex
	# compile three times to generate ToC and numbers formatted nicely
	latex -interaction=batchmode tempbook_
	latex -interaction=batchmode tempbook_
	latex -interaction=batchmode tempbook_
	makeindex -q tempbook_
	dvips -q -Ppdf -o PhysModMatlab.ps tempbook_
	ps2pdf -q $(PDFFLAGS) PhysModMatlab.ps $(PDF_DEST)
	rm tempbook_* PhysModMatlab.ps

# Same as pdfbook (above) but with alternating margins
altpdfbook:	book.tex
	cp book.tex tempbook_.tex
	# compile three times to generate ToC and numbers formatted nicely
	latex -interaction=batchmode tempbook_
	latex -interaction=batchmode tempbook_
	latex -interaction=batchmode tempbook_
	makeindex -q tempbook_
	dvips -q -Ppdf -o PhysModMatlab.ps tempbook_
	ps2pdf -q $(PDFFLAGS) PhysModMatlab.ps $(PDF_DEST)
	rm tempbook_* PhysModMatlab.ps


# Generate the book in HTML.
hevea:	book.tex header.html footer.html
	rm -rf html
	mkdir html
	# -fix is needed to generate example and section references properly
	hevea -fix -O -e latexonly htmlonly book
	# the following line is a kludge to prevent imagen from seeing
	# the definitions in latexonly
	grep -v latexonly book.image.tex > a; mv a book.image.tex
	imagen -png book
	hacha book.html
	cp up.png next.png back.png html
	mv index.html book.css book*.html book*.png *motif.gif html


# From here-> end: stuff for Downey's server
DEST = /home/downey/public_html/greent/matlab
FILES = Makefile book.tex latexonly figs

distrib: 
	rm -rf tex
	mkdir tex
	rsync -a $(FILES) tex
	#rm tex/figs/*.bak
	zip -r PhysModMatlab.zip tex
	rsync -a PhysModMatlab.* html $(DEST)
	chmod -R o+r $(DEST)/*
	cd $(DEST)/..; sh back

