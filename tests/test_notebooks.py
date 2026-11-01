"""Run the chapter notebooks (site/notebooks, solution versions) in GNU Octave.

Usage: python3 tests/test_notebooks.py [octave command [chapNN ...]]   (default: octave, all)

For each notebook, the code cells run in order in one Octave session, in a
copy of the chapter's code folder (as on the site). A cell that raises an
error fails the test. Cells with "checks" in their metadata (the examples
that fail on purpose, shown as text in the notebook) run their check code,
which must fail with the expected message.
"""

import json
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
OCTAVE = sys.argv[1] if len(sys.argv) > 1 else "octave"


def octave_string(s):
    return "'" + s.replace("'", "''") + "'"


def test_notebook(nb_path):
    nb = json.loads(nb_path.read_text())
    chapter = nb_path.stem
    work = Path(tempfile.mkdtemp())
    folder = work / chapter
    # In the browser, a function defined in a cell takes precedence over a file
    # of the same name in the folder, even through a handle (@name); desktop
    # Octave's handles find the file. So leave out files the notebook defines.
    defined = set()
    for cell in nb["cells"]:
        if cell["cell_type"] == "code":
            defined |= set(re.findall(r"^\s*function\s+(?:\[?[\w, ]*\]?\s*=\s*)?(\w+)", cell["source"], re.M))
    folder.mkdir()
    source = ROOT / "code" / chapter
    if source.exists():         # Chapter 1 has no code folder
        for f in source.rglob("*"):
            if f.is_file() and f.stem not in defined:
                dest = folder / f.relative_to(source)
                dest.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy(f, dest)

    # Each cell and check becomes a script file ("1;" so a file of functions is a script).
    steps = []
    for i, cell in enumerate(nb["cells"]):
        if cell["cell_type"] == "code":
            name = f"cell_{i:03d}.m"
            (folder / name).write_text("1;\n" + cell["source"] + "\n")
            steps.append(("cell", i, name, None))
        for j, check in enumerate(cell["metadata"].get("checks", [])):
            name = f"check_{i:03d}_{j}.m"
            (folder / name).write_text("1;\n" + check["code"] + "\n")
            steps.append(("check", i, name, check["error"]))

    lines = ["warning('off', 'all');",
             f"addpath({octave_string(str(ROOT / 'tests' / 'stubs'))});",
             "set(0, 'defaultfigurevisible', 'off');"]
    for kind, i, name, _ in steps:
        lines.append(f"try; source('{name}'); printf('STEP-OK {name}\\n'); "
                     f"catch e; printf('STEP-ERROR {name} %s\\n', e.message); end")
    (folder / "run_notebook.m").write_text("\n".join(lines) + "\n")

    result = subprocess.run([OCTAVE, "--no-gui", "--quiet", "--no-window-system", "run_notebook.m"],
                            cwd=folder, capture_output=True, text=True, timeout=600)
    outcome = {}
    for line in result.stdout.splitlines():
        m = re.match(r"STEP-(OK|ERROR) (\S+) ?(.*)", line)
        if m:
            outcome[m.group(2)] = (m.group(1), m.group(3))

    failures = []
    for kind, i, name, expected in steps:
        status, message = outcome.get(name, ("MISSING", ""))
        if kind == "cell" and status != "OK":
            failures.append(f"cell {i}: {status} {message}")
        if kind == "check":
            if status != "ERROR":
                failures.append(f"cell {i}: expected an error ({expected}), got {status}")
            elif expected not in message:
                failures.append(f"cell {i}: expected error containing {expected!r}, got {message!r}")
    shutil.rmtree(work)
    ncells = sum(k == "cell" for k, *_ in steps)
    nchecks = len(steps) - ncells
    print(f"{'ok  ' if not failures else 'FAIL'} {nb_path.name}: {ncells} cells, {nchecks} error checks")
    for f in failures:
        print("     " + f)
    return not failures


if __name__ == "__main__":
    notebooks = sorted((ROOT / "site" / "notebooks").glob("chap??.ipynb"))
    chapters = [a for a in sys.argv[2:]]     # optional: chap09 chap13 ...
    if chapters:
        notebooks = [nb for nb in notebooks if nb.stem in chapters]
    results = [test_notebook(nb) for nb in notebooks]
    sys.exit(0 if all(results) else 1)
