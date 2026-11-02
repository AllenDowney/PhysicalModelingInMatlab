#!/bin/bash
# Build the site into site/dist: the Jupyter Book (the chapters as web pages, from the
# notebooks with outputs in jb/) at the root, and JupyterLite (Octave in the browser)
# in run/. Run from the repo root in an environment made from site/build-environment.yml.
set -euo pipefail
cd "$(dirname "$0")"

rm -rf content dist jb_build .jupyterlite.doit.db
mkdir content
cp README.md content/
cp -r ../code/chap?? content/
# Chapter notebooks: the student version (solutions blanked) and the version
# with solutions, both in the chapter folder, so they can run the chapter's scripts.
shopt -s nullglob
for nb in notebooks/chap??.ipynb; do
    name=$(basename "$nb" .ipynb)
    mkdir -p "content/$name"     # Chapter 1 has no code folder
    python remove_soln.py "$nb" "content/$name/$name.ipynb"
    cp "$nb" "content/$name/${name}_soln.ipynb"
done

# The figure scripts save the book's figures to ../../book/figs/, which
# doesn't exist in the browser; drop those lines from the site's copies.
grep -rl "saveas(gcf, '../../book/figs/" content | xargs sed -i "/saveas(gcf, '..\/..\/book\/figs\//d"

# overrides.json: render all cells (no windowing), so long notebooks scroll smoothly
jupyter lite build --contents content --output-dir dist/run --settings-overrides overrides.json

# The run page (chapter list) replaces JupyterLite's root page, which only redirects.
# JupyterLite's app pages read the root page's #jupyter-config-data, so carry it over.
python - <<'END'
import re
root = open("dist/run/index.html").read()
config = re.search(r'<script id="jupyter-config-data".*?</script>', root, re.S).group(0)
page = open("landing.html").read().replace("</head>", config + "\n</head>", 1)
open("dist/run/index.html", "w").write(page)
END
# Page-view counter (GreenTeaPress Task 15): one request to greenteapress.com/gh.gif
# per page view, counted from its access logs; no cookies, no third party.
COUNTER='<script>new Image().src="https://greenteapress.com/gh.gif?u="+encodeURIComponent(location.href)+"\&r="+encodeURIComponent(document.referrer)</script>'
for page in dist/run/lab/index.html dist/run/notebooks/index.html; do
    sed -i "s#</body>#$COUNTER</body>#" "$page"
done

# The Jupyter Book, built from a copy of jb/ (prep_notebooks.py adds the run links and
# hides the solutions), into the site root
cp -r jb jb_build
(cd jb_build && python prep_notebooks.py && jupyter-book build --warningiserror .)
cp -r jb_build/_build/html/. dist/
rm -rf jb_build
# The sitemap (sphinx-sitemap) lists the book's pages; add the run page. The notebooks
# open in a JavaScript app, so they aren't worth indexing.
sed -i -e 's#PhysicalModelingInMatlab/index.html<#PhysicalModelingInMatlab/<#' -e 's#</urlset>#<url><loc>https://allendowney.github.io/PhysicalModelingInMatlab/run/</loc></url></urlset>#' dist/sitemap.xml

# The site's first version (2026-11-01) had JupyterLite at the root; forward its links.
for app in lab notebooks tree; do
    mkdir -p "dist/$app"
    cat > "dist/$app/index.html" <<END
<!doctype html>
<meta charset="utf-8">
<title>Moved</title>
<script>location.replace("../run/$app/index.html" + location.search + location.hash)</script>
<p>This page has moved to <a href="../run/$app/index.html">run/$app/</a>.</p>
END
done
