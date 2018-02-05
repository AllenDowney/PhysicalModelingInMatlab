PDF = Physical_Modeling_In_MATLAB.pdf

PDFFLAGS = -dCompatibilityLevel=1.4 -dPDFSETTINGS=/prepress  \
           -dCompressPages=true -dUseFlateCompression=true  \
           -dEmbedAllFonts=true -dSubsetFonts=true -dMaxSubsetPct=100

# Generate a PDF of the book for electronic viewing and print; also
# generate an HTML version of the book.
all:	pdfbook pdfprintbook hevea

# Generate the book from scratch as a PDF (using static margins)
pdfbook:	book.tex
	# Search and replace a few things in the tex file for static
	# margins; note that this is somewhat sensitive to changes in the code
	sed -e 's/\%left=/left=/g' \
	-e 's/\%right=/right=/g' \
	-e 's/inner=/\%inner=/g' \
	-e 's/outer=/\%outer=/g' \
	-e 's/\%oneside/oneside/g' \
	book.tex > tempbook_.tex
	# Compile three times to generate ToC and numbers formatted nicely
	latex -interaction=batchmode tempbook_
	makeindex -q tempbook_
	latex -interaction=batchmode tempbook_
	latex -interaction=batchmode tempbook_
	dvips -q -Ppdf -o PhysModMatlab.ps tempbook_
	ps2pdf -q $(PDFFLAGS) PhysModMatlab.ps $(PDF)
	rm tempbook_* PhysModMatlab.ps

# Same as pdfbook (above) but for print instead of electronic viewing;
# margins alternate and chapters always start on right side (cf.
# left) of page.
pdfprintbook:	book.tex
	cp book.tex tempbook_.tex
	# Compile three times to generate ToC and numbers formatted nicely
	latex -interaction=batchmode tempbook_
	makeindex -q tempbook_
	latex -interaction=batchmode tempbook_
	latex -interaction=batchmode tempbook_
	dvips -q -Ppdf -o PhysModMatlab.ps tempbook_
	ps2pdf -q $(PDFFLAGS) PhysModMatlab.ps Physical_Modeling_In_MATLAB_print.pdf
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
	# Clean up
	rm book.haux book.htoc book.image.out.ps book.image.tex


# From here-> end: stuff for Downey's server
DEST = /home/downey/public_html/greent/matlab
FILES = Makefile book.tex latexonly figs

distrib:
	rm -rf tex
	mkdir tex
	rsync -a $(FILES) tex
	#rm tex/figs/*.bak
	#zip -r PhysModMatlab.zip tex
	rsync -a $(PDF) html $(DEST)
	chmod -R o+r $(DEST)/*
	cd $(DEST)/..; sh back

