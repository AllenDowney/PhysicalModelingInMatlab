"""Convert a chapter of the book (LaTeX) to a Jupyter notebook for the Octave site.

Usage: python site/tex2nb.py CHAPTER AUX OUTPUT
  e.g. python site/tex2nb.py 9 book/main.aux site/notebooks/chap09.ipynb

CHAPTER is the chapter number; AUX is main.aux from a build of the book (for
the numbers of figures, sections and listings); OUTPUT is the notebook.
Edits for a chapter (cells to add, blocks to skip, solutions) go in site/notebooks/chapNN.json.
The output is the solution version; remove_soln.py makes the student version.

Prose becomes markdown cells (through pandoc), code listings become Octave
code cells, figures are embedded as PNG attachments, and output the book
shows (results, error messages) becomes static text, since running the
cell produces it.
"""

import base64
import json
import re
import subprocess
import sys
import tempfile
import textwrap
from pathlib import Path

BOOK = Path(__file__).resolve().parent.parent / "book"

KERNELSPEC = {"name": "xoctave", "display_name": "Octave (xoctave)", "language": "octave"}

# Blocks of book output that start like this are error messages.
# Solution cells start with this line (as "# Solution" in Allen's Python books).
SOLUTION = "% Solution"

ERROR_STARTS = ("Error", "error:", "Not enough", "Output argument", "Undefined")


def read_labels(aux_path):
    """Map each label to (number, title) from main.aux."""
    labels = {}
    pattern = re.compile(r"\\newlabel\{([^}]*)\}\{\{([^}]*)\}\{[^}]*\}\{(.*?)\}\{[^}]*\}")
    for line in Path(aux_path).read_text().splitlines():
        m = pattern.match(line)
        if m:
            labels[m.group(1)] = (m.group(2), m.group(3))
    return labels


def strip_comments(text):
    """Remove LaTeX comments (unescaped % to end of line), outside code."""
    return re.sub(r"(?<!\\)%.*", "", text)


def split_blocks(tex):
    """Split chapter source into ('text', s), ('code', s, caption) and ('figure', s) blocks."""
    pattern = re.compile(
        r"\\begin\{(code|lstlisting|stdout|figure)\}(\[[^\]]*\])?\n?(.*?)\\end\{\1\}", re.S
    )
    blocks = []
    pos = 0
    for m in pattern.finditer(tex):
        if m.start() > pos:
            blocks.append(("text", strip_comments(tex[pos:m.start()])))
        kind, opts, body = m.group(1), m.group(2) or "", m.group(3)
        if kind == "figure":
            blocks.append(("figure", body))
        else:
            caption = re.search(r"caption=\{(.*?)\}", opts)
            label = re.search(r"label=\{(.*?)\}", opts)
            blocks.append(("code", body.rstrip(), caption and caption.group(1), label and label.group(1)))
        pos = m.end()
    blocks.append(("text", strip_comments(tex[pos:])))
    return blocks


def fix_refs(text, labels):
    """Replace \\ref, \\pageref and \\nameref with numbers and titles."""
    def num(key):
        return labels.get(key, ("??", ""))[0]

    def title(key):
        return labels.get(key, ("", "??"))[1]

    # "on page~\pageref{x}" and "from page~\pageref{x}" -> "in Section N"
    text = re.sub(r"\bon page~\\pageref\{([^}]*)\}", lambda m: f"in Section {num(m.group(1))}", text)
    text = re.sub(r"\bpage~\\pageref\{([^}]*)\}", lambda m: f"Section {num(m.group(1))}", text)
    text = re.sub(r"\\nameref\{([^}]*)\}", lambda m: title(m.group(1)), text)
    text = re.sub(r"\\ref\{([^}]*)\}", lambda m: num(m.group(1)), text)
    return text


def preprocess(text, labels):
    """Rewrite the book's own macros into plain LaTeX that pandoc understands."""
    text = re.sub(r"\\index\{(?:[^{}]|\{[^{}]*\})*\}", "", text)
    text = re.sub(r"\\label\{[^}]*\}", "", text)
    text = fix_refs(text, labels)
    text = re.sub(r"\\lstinline\{([^}]*)\}", r"\\texttt{\1}", text)
    text = re.sub(r"\\lstinline\|([^|]*)\|", r"\\texttt{\1}", text)
    text = re.sub(r"\\mcode\{([^}]*)\}", r"\\texttt{\1}", text)
    units = {r"\celsius": "°C", r"\meter": "m", r"\second": "s", r"\minute": "min",
             r"\kilogram": "kg", r"\hour": "h", r"\per": "/", r"\radian": "rad",
             r"\newton": "N", r"\degree": "°"}

    def si(m):
        unit = m.group(2)
        for k, v in units.items():
            unit = unit.replace(k, v)
        unit = unit.replace(" ", "")
        sep = "" if unit.startswith("°") else " "
        return f"{m.group(1)}{sep}{unit}"

    text = re.sub(r"\\SI\{([^}]*)\}\{([^}]*)\}", si, text)
    text = text.replace(r"\begin{ex}", r"\textbf{Exercise.}").replace(r"\end{ex}", "")
    text = text.replace(r"\begin{eqnarray*}", r"\begin{align*}").replace(r"\end{eqnarray*}", r"\end{align*}")
    text = re.sub(r"&=&", "&=", text)
    return text


def to_markdown(tex):
    """Convert a chunk of LaTeX to markdown with pandoc."""
    result = subprocess.run(
        ["pandoc", "-f", "latex", "-t", "markdown-smart-raw_tex-raw_attribute", "--wrap=none",
         "--shift-heading-level-by=1"],
        input=tex, capture_output=True, text=True, check=True,
    )
    return result.stdout.strip()


def split_code(body):
    """Split a code block into (code, output): code is runnable, output is what the book shows."""
    lines = body.split("\n")
    if any(l.startswith(">> ") for l in lines):
        code = [l[3:] for l in lines if l.startswith(">> ")]
        output = [l for l in lines if not l.startswith(">> ")]
        return "\n".join(code), "\n".join(output).strip()
    if lines and lines[0].strip().startswith(ERROR_STARTS):
        return "", body
    # trailing lines that are just numbers are results, e.g. "Y(end)" then "2.0751e+03"
    code = list(lines)
    output = []
    while code and re.fullmatch(r"\s*[-+0-9.e]+\s*", code[-1]):
        output.insert(0, code.pop())
    return "\n".join(code).rstrip(), "\n".join(output)


def figure_png(body, labels, out_dir):
    """Render a figure's EPS to PNG; return (markdown, attachments)."""
    m = re.search(r"\\includegraphics(\[[^\]]*\])?\{([^}]*)\}", body)
    caption = re.search(r"\\caption\{(.*)\}", body)
    label = re.search(r"\\label\{([^}]*)\}", body)
    eps = BOOK / m.group(2)
    name = eps.stem + ".png"
    png = Path(out_dir) / name
    subprocess.run(["gs", "-q", "-dSAFER", "-dEPSCrop", "-sDEVICE=png16m", "-r110",
                    "-o", str(png), str(eps)], check=True)
    data = base64.b64encode(png.read_bytes()).decode()
    number = labels.get(label.group(1), ("?", ""))[0] if label else "?"
    cap = to_markdown(preprocess(caption.group(1), labels)) if caption else ""
    md = f"![Figure {number}](attachment:{name})\n\n*Figure {number}: {cap}*"
    return md, {name: {"image/png": data}}


def markdown_cell(source, attachments=None):
    cell = {"cell_type": "markdown", "metadata": {}, "source": source}
    if attachments:
        cell["attachments"] = attachments
    return cell


def code_cell(source, tags=None):
    return {"cell_type": "code", "execution_count": None,
            "metadata": {"tags": tags} if tags else {}, "outputs": [], "source": source}


def convert(chapter, aux, nb_path):
    labels = read_labels(aux)
    tex = (BOOK / f"chap{chapter:02d}.tex").read_text()
    edits_path = Path(nb_path).with_suffix(".json")
    edits = json.loads(edits_path.read_text()) if edits_path.exists() else {}
    after = {int(k): v for k, v in edits.get("after", {}).items()}
    # Code that fails on purpose is shown as text, with a check that the tests run.
    errors = {int(k): v for k, v in edits.get("errors", {}).items()}
    checks = {int(k): v for k, v in edits.get("checks", {}).items()}
    show_octave = {}   # block number -> Octave error messages to show after it
    for n, e in list(errors.items()) + [(n, c) for n, cs in checks.items() for c in cs]:
        if "show_after" in e:
            show_octave.setdefault(e["show_after"], []).append(e["error"])
    static = set(edits.get("static", []))
    prepend = {int(k): v for k, v in edits.get("prepend", {}).items()}

    cells = []
    title = re.search(r"\\chapter\{([^}]*)\}", tex).group(1)
    tex = tex.replace(r"\chapter{" + title + "}", "")
    cells.append(markdown_cell(
        f"# {chapter}. {title}\n\n"
        f"*Physical Modeling in MATLAB* by Allen B. Downey. "
        f"Run each code cell in order with Shift+Enter; you can change the code and run it again."))

    tmp = tempfile.mkdtemp()
    text_buf = []
    ncode = 0

    def flush():
        md = to_markdown(preprocess("".join(text_buf), labels)) if text_buf else ""
        text_buf.clear()
        # start a new cell at each heading, so a section's text begins its own cell
        for part in re.split(r"\n(?=#{1,6} )", md):
            if part.strip():
                cells.append(markdown_cell(part.strip()))

    for block in split_blocks(tex):
        if block[0] == "text":
            text_buf.append(block[1])
            continue
        flush()
        if block[0] == "figure":
            md, att = figure_png(block[1], labels, tmp)
            cells.append(markdown_cell(md, att))
            continue
        _, body, caption, label = block
        ncode += 1
        if caption:
            number = labels.get(label, ("?", ""))[0] if label else "?"
            cells.append(markdown_cell(f"*Listing {number}: {caption}*"))
        code, output = split_code(textwrap.dedent(body))
        if ncode in static:
            code, output = "", textwrap.dedent(body)
        if code and ncode in prepend:
            code = prepend[ncode] + "\n" + code
        if code and ncode in errors:
            cell = markdown_cell("```\n" + code + "\n```")
            cell["metadata"]["checks"] = [{"code": code, "error": errors[ncode]["error"]}]
            cells.append(cell)
        elif code:
            cells.append(code_cell(code))
        if ncode in checks:
            cells[-1]["metadata"]["checks"] = [{"code": c["code"], "error": c["error"]} for c in checks[ncode]]
        # Running the cell shows its result; keep only error messages, which differ in MATLAB.
        if ncode in static:
            cells.append(markdown_cell("```\n" + output + "\n```"))
        elif output and output.lstrip().startswith(ERROR_STARTS):
            cells.append(markdown_cell("In MATLAB, the error message is:\n\n```\n" + output + "\n```"))
        for message in show_octave.get(ncode, []):
            cells.append(markdown_cell("In Octave, it is:\n\n```\nerror: " + message + "\n```"))
        for extra in after.get(ncode, []):
            if isinstance(extra, dict) and "markdown" in extra:
                cells.append(markdown_cell(extra["markdown"]))
            else:
                cells.append(code_cell(extra))
    flush()
    # Solutions come from files in code/; remove_soln.py blanks them for the student version.
    for sol in edits.get("solutions", []):
        source = (BOOK.parent / sol["file"]).read_text()
        source = "\n".join(l for l in source.splitlines() if "saveas(gcf, '../../book/figs/" not in l)
        cells.append(code_cell(SOLUTION + "\n\n" + source.strip()))
        if "call" in sol:
            cells.append(code_cell(SOLUTION + "\n\n" + sol["call"]))

    nb = {"cells": cells,
          "metadata": {"kernelspec": KERNELSPEC,
                       "language_info": {"name": "octave", "file_extension": ".m"}},
          "nbformat": 4, "nbformat_minor": 5}
    for i, c in enumerate(nb["cells"]):
        c["id"] = f"c{i:03d}"
    Path(nb_path).write_text(json.dumps(nb, indent=1, ensure_ascii=False) + "\n")
    print(f"{nb_path}: {len(cells)} cells, {ncode} code blocks")


if __name__ == "__main__":
    convert(int(sys.argv[1]), sys.argv[2], sys.argv[3])
