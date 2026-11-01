#!/bin/bash
# Build the JupyterLite site (Octave in the browser) into site/dist.
# Run from the repo root in an environment made from site/build-environment.yml.
set -euo pipefail
cd "$(dirname "$0")"

rm -rf content dist .jupyterlite.doit.db
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
jupyter lite build --contents content --output-dir dist --settings-overrides overrides.json

# The landing page (chapter list) replaces JupyterLite's root page, which only redirects.
# JupyterLite's app pages read the root page's #jupyter-config-data, so carry it over.
python - <<'END'
import re
root = open("dist/index.html").read()
config = re.search(r'<script id="jupyter-config-data".*?</script>', root, re.S).group(0)
page = open("landing.html").read().replace("</head>", config + "\n</head>", 1)
open("dist/index.html", "w").write(page)
END
# Only the landing page is worth indexing: the notebooks open in a JavaScript app.
cat > dist/sitemap.xml <<'END'
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url><loc>https://allendowney.github.io/PhysicalModelingInMatlab/</loc></url>
</urlset>
END
# Page-view counter (GreenTeaPress Task 15): one request to greenteapress.com/gh.gif
# per page view, counted from its access logs; no cookies, no third party.
COUNTER='<script>new Image().src="https://greenteapress.com/gh.gif?u="+encodeURIComponent(location.href)+"\&r="+encodeURIComponent(document.referrer)</script>'
for page in dist/lab/index.html dist/notebooks/index.html; do
    sed -i "s#</body>#$COUNTER</body>#" "$page"
done
