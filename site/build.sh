#!/bin/bash
# Build the JupyterLite site (Octave in the browser) into site/dist.
# Run from the repo root in an environment made from site/build-environment.yml.
set -euo pipefail
cd "$(dirname "$0")"

rm -rf content dist .jupyterlite.doit.db
mkdir content
cp README.md content/
cp -r ../code/chap?? content/
shopt -s nullglob
for nb in notebooks/chap??.ipynb; do
    cp "$nb" "content/$(basename "$nb" .ipynb)/"
done

# The figure scripts save the book's figures to ../../book/figs/, which
# doesn't exist in the browser; drop those lines from the site's copies.
grep -rl "saveas(gcf, '../../book/figs/" content | xargs sed -i "/saveas(gcf, '..\/..\/book\/figs\//d"

# overrides.json: render all cells (no windowing), so long notebooks scroll smoothly
jupyter lite build --contents content --output-dir dist --settings-overrides overrides.json
