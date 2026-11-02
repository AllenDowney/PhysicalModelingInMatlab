"""Run the chapter notebooks in desktop Octave and save them with their outputs, for the Jupyter Book.

Usage: python site/run_notebooks.py [--force | --check] [chapNN ...]   (default: all chapters)

Run it locally, in the PhysicalModelingInMatlab env (Octave and octave_kernel), and commit
the results in site/jb/. Each notebook in site/notebooks/ (the solution version) runs in a
copy of its chapter's code folder, as tests/test_notebooks.py does. The output notebook
records a hash of its inputs (the notebook and the chapter's code), and a chapter is only
rerun when they change, since the plots come out a little different every run.

--force   rerun even if the inputs haven't changed
--check   run nothing; exit 1 if any output notebook is missing or out of date (used in CI)
"""

import hashlib
import re
import shutil
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SOURCE = ROOT / "site" / "notebooks"
OUTPUT = ROOT / "site" / "jb"
STUBS = ROOT / "tests" / "stubs"


def input_hash(nb_path):
    """Hash of the notebook and every file in its chapter's code folder."""
    h = hashlib.sha256(nb_path.read_bytes())
    folder = ROOT / "code" / nb_path.stem
    if folder.exists():
        for f in sorted(folder.rglob("*")):
            if f.is_file():
                h.update(str(f.relative_to(folder)).encode())
                h.update(f.read_bytes())
    return h.hexdigest()


def stored_hash(out_path):
    if not out_path.exists():
        return None
    import json
    return json.loads(out_path.read_text())["metadata"].get("pmm", {}).get("inputs")


def run(nb_path, out_path, digest):
    import nbformat
    from nbclient import NotebookClient

    nb = nbformat.read(nb_path, as_version=4)
    chapter = nb_path.stem
    work = Path(tempfile.mkdtemp())
    # In the browser, a function defined in a cell takes precedence over a file of the
    # same name; in desktop Octave a handle finds the file. Leave those files out.
    defined = set()
    for cell in nb.cells:
        if cell.cell_type == "code":
            defined |= set(re.findall(r"^\s*function\s+(?:\[?[\w, ]*\]?\s*=\s*)?(\w+)", cell.source, re.M))
    source = ROOT / "code" / chapter
    if source.exists():         # Chapter 1 has no code folder
        for f in source.rglob("*"):
            if f.is_file() and f.stem not in defined:
                dest = work / f.relative_to(source)
                dest.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy(f, dest)
                # The figure scripts save the book's figures to ../../book/figs/
                if f.suffix == ".m":
                    text = dest.read_text()
                    kept = [l for l in text.splitlines(True) if "saveas(gcf, '../../book/figs/" not in l]
                    dest.write_text("".join(kept))

    # A setup cell (animations don't wait), removed after the run
    setup = nbformat.v4.new_code_cell(f"addpath('{STUBS}');")
    nb.cells.insert(0, setup)
    nb.metadata.kernelspec = {"name": "octave", "display_name": "Octave", "language": "octave"}
    client = NotebookClient(nb, timeout=600, kernel_name="octave", record_timing=False,
                            resources={"metadata": {"path": str(work)}})
    client.execute()
    nb.cells.pop(0)
    shutil.rmtree(work)

    for cell in nb.cells:
        if cell.cell_type == "code":
            for out in cell.outputs:
                if out.output_type == "stream":
                    out.text = out.text.replace("\r\n", "\n")
    nb.metadata["pmm"] = {"inputs": digest}
    nbformat.write(nb, out_path)


def main(args):
    force = "--force" in args
    check = "--check" in args
    chapters = [a for a in args if not a.startswith("--")]
    notebooks = sorted(SOURCE.glob("chap??.ipynb"))
    if chapters:
        notebooks = [nb for nb in notebooks if nb.stem in chapters]

    stale = []
    for nb_path in notebooks:
        out_path = OUTPUT / nb_path.name
        digest = input_hash(nb_path)
        if not force and stored_hash(out_path) == digest:
            print(f"up to date  {nb_path.name}")
            continue
        if check:
            print(f"OUT OF DATE {nb_path.name}")
            stale.append(nb_path.name)
            continue
        print(f"running     {nb_path.name}", flush=True)
        run(nb_path, out_path, digest)
    if stale:
        print("Rerun python site/run_notebooks.py and commit site/jb/.")
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
