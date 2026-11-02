"""Prepare the run notebooks for the Jupyter Book (run by site/build.sh on a copy of site/jb).

- The title cell gets links to the chapter's notebooks on JupyterLite, in place of the
  instructions for running cells
- Solution cells (they start with "% Solution") are tagged hide-cell, so they're collapsed
- Page descriptions from descriptions.yml go in the notebook metadata
- Figures, which are attachments in the notebooks, are written to figs/ (Jupyter Book
  doesn't read attachments)
"""

import base64
import glob
import os

import nbformat
import yaml

RUN = "https://allendowney.github.io/PhysicalModelingInMatlab/run/notebooks/index.html?path={0}/{1}.ipynb"
SOLUTION = "% Solution"

with open("descriptions.yml") as f:
    DESCRIPTIONS = yaml.safe_load(f)

for path in sorted(glob.glob("chap??.ipynb")):
    name = path.removesuffix(".ipynb")
    nb = nbformat.read(path, as_version=4)

    solutions = False
    for cell in nb.cells:
        for fname, data in cell.pop("attachments", {}).items():
            os.makedirs("figs", exist_ok=True)
            with open(f"figs/{fname}", "wb") as f:
                f.write(base64.b64decode(data["image/png"]))
            cell.source = cell.source.replace(f"attachment:{fname}", f"figs/{fname}")
        if cell.cell_type == "code" and cell.source.startswith(SOLUTION):
            cell.metadata.setdefault("tags", []).append("hide-cell")
            cell.metadata["mystnb"] = {"code_prompt_show": "Show solution",
                                       "code_prompt_hide": "Hide solution"}
            solutions = True

    title = nb.cells[0].source.splitlines()[0]
    links = f"[Run this chapter online]({RUN.format(name, name)})"
    if solutions:
        links += f" (or [with solutions]({RUN.format(name, name + '_soln')}))"
    nb.cells[0].source = f"{title}\n\n{links}"

    desc = DESCRIPTIONS[name]
    nb.metadata["myst"] = {"html_meta": {"description": desc}}
    nb.metadata["og:description"] = desc
    nbformat.write(nb, path)
