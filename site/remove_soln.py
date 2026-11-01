"""Make the student version of a chapter notebook: blank the solution cells.

Usage: python site/remove_soln.py SOLUTION.ipynb STUDENT.ipynb

Cells that start with "% Solution" (written by tex2nb.py) become "% Solution goes here",
as remove_soln.py does in ModSimPy.
"""

import json
import sys

SOLUTION = "% Solution"

src, dst = sys.argv[1], sys.argv[2]
nb = json.load(open(src))
for cell in nb["cells"]:
    if cell["cell_type"] == "code" and cell["source"].startswith(SOLUTION):
        cell["source"] = SOLUTION + " goes here\n"
        cell["outputs"] = []
        cell["execution_count"] = None
with open(dst, "w") as f:
    json.dump(nb, f, indent=1, ensure_ascii=False)
    f.write("\n")
