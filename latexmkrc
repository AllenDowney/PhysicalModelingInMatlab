# html generation
$pdflatex = "pdflatex -shell-escape -synctex=1 %O %S; htlatex %S \"htlatex/htlatex.cfg,MyFonts,NoFonts\" \"\" \"\" -shell-escape > output.txt";

$clean_ext .= ' 4ct 4tc idv lg tmp xref';
$clean_full_ext .= ' css html';


####### Default Overleaf latexmkrc settings --
## need to re-include them if providing own
## latexmkrc file. See https://www.overleaf.com/help/216-how-does-overleaf-compile-my-project

# support for the glossaries package:
add_cus_dep('glo', 'gls', 0, 'makeglossaries');
add_cus_dep('acn', 'acr', 0, 'makeglossaries');
sub makeglossaries {
system("makeglossaries \"$_[0]\"");
}

# support for the nomencl package:
add_cus_dep('nlo', 'nls', 0, 'makenlo2nls');
sub makenlo2nls {
system("makeindex -s nomencl.ist -o \"$_[0].nls\" \"$_[0].nlo\"");
}

# from the documentation for V. 2.03 of asymptote:
sub asy {return system("asy \"$_[0]\"");}
add_cus_dep("asy","eps",0,"asy");
add_cus_dep("asy","pdf",0,"asy");
add_cus_dep("asy","tex",0,"asy");

# metapost rule from http://tex.stackexchange.com/questions/37134
add_cus_dep('mp', '1', 0, 'mpost');
sub mpost {
  my $file = $_[0];
  my ($name, $path) = fileparse($file);
  pushd($path);
  my $return = system "mpost $name";
  popd();
  return $return;
}