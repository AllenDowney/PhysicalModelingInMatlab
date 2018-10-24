# Ubuntu (18.04) commands executed in order to make "Physical Modeling In MATLAB"
```bash
sudo apt install make
sudo apt install texlive-latex-base  # this is probably implied by the below command
sudo apt-get install texlive-latex-extra
sudo apt-get install hevea
# below 3 commands for documentation are optional
sudo apt-get install hevea-doc  
sudo apt install texlive-latex-base-doc
sudo apt-get install texlive-fonts-recommended-doc texlive-latex-extra-doc
# 
sudo apt install git
sudo updatedb
locate dvips35.map  #the output of this command confirms the path used below.
locate config.ps  #the output of this command confirms the file to copy and edit below
sudo cp /usr/share/texlive/texmf-dist/dvips/config/config.ps /usr/share/texlive/texmf-dist/dvips/config/config.orig.ps
sudo gedit /usr/share/texlive/texmf-dist/dvips/config/config.ps
# following instructions at  https://askubuntu.com/questions/409697/latex-dvips-font-problem-ubuntu-13-04
# - add the line 'p +/usr/share/texlive/texmf-dist/fonts/map/dvips/tetex/dvips35.map' (no quotes)
# - at the end of the file and then save and exit gedit.
sudo updmap-sys
git clone https://github.com/AllenDowney/PhysicalModelingInMATLAB.git
cd book
make pdfbook

