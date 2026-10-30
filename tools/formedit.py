"""formedit.py - set, remove or add properties of named objects in a text form file (.fmx/.dfm/.lfm).

Used for the manual layout pass of a demo (a scripted edit is reviewable and repeatable):

  python -I tools/formedit.py <form> <Object> Prop=Value [Prop=Value ...] [-Prop ...]
  python -I tools/formedit.py <form> <Object> --delete            (the object and its children)
  python -I tools/formedit.py <form> <Object> --rename NewClass   (only the class in the header line)

A value is written as given (quote strings yourself: Text="'Hello'"). FMX float properties
(Position.X, Size.Width, Margins.Left, Font.Size, ...) get the 18-digit float form when given as
plain numbers. -Prop removes a property. Collections and multi-line values other than
string lists are not edited. The file keeps its encoding and line endings.
"""

import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import formfile  # noqa: E402

FMX_FLOAT = re.compile(r"^(Position\.[XY]|Size\.(Width|Height)|Margins\.\w+|Padding\.\w+|Font\.Size|Opacity|"
                       r"Header\.Size|Footer\.Size|RotationAngle|Scale\.[XY]|TextSettings\.Font\.Size)$")


def load(path):
    raw = Path(path).read_bytes()
    bom = raw.startswith(b"\xef\xbb\xbf")
    try:
        text, enc = raw.decode("utf-8-sig"), "utf-8"
    except UnicodeDecodeError:
        text, enc = raw.decode("cp1252"), "cp1252"
    return text, enc, bom, b"\r\n" in raw


def save(path, lines, enc, bom, crlf):
    nl = "\r\n" if crlf else "\n"
    b = (nl.join(lines) + nl).encode(enc)
    Path(path).write_bytes((b"\xef\xbb\xbf" if bom else b"") + b)


def edit(path, name, sets, removes, delete=False, rename=None):
    text, enc, bom, crlf = load(path)
    lines = text.splitlines()
    root = formfile.parse(text)
    obj = next((o for o in root.walk() if o.name == name), None)
    if obj is None:
        raise SystemExit(f"{name}: not found in {path}")
    fmx = str(path).lower().endswith(".fmx")
    if delete:
        del lines[obj.start:obj.end + 1]
        save(path, lines, enc, bom, crlf)
        return
    if rename:
        lines[obj.start] = re.sub(r":\s*[\w.]+", f": {rename}", lines[obj.start], count=1)
    ind = " " * (obj.indent + 2)
    drop = set()
    newvals = {}
    for k, v in sets.items():
        if fmx and FMX_FLOAT.match(k) and re.fullmatch(r"-?\d+(\.\d+)?", v):
            v = f"{float(v):.18f}"
        newvals[k] = v
    insert = []
    for k, v in newvals.items():
        p = obj.prop(k)
        if p:
            lines[p.start] = lines[p.start].split("=")[0].rstrip() + " = " + v.split("\n")[0]
            drop.update(range(p.start + 1, p.end + 1))
            if "\n" in v:
                lines[p.start] += "\n" + "\n".join(v.split("\n")[1:])
        else:
            insert.append(f"{ind}{k} = {v}")
    for k in removes:
        p = obj.prop(k)
        if p:
            drop.update(range(p.start, p.end + 1))
    last = max([p.end for p in obj.props if "[" not in p.path] or [obj.start])
    out = []
    for i, l in enumerate(lines):
        if i not in drop:
            out.extend(l.split("\n"))
        if i == last and insert:
            out.extend(insert)
    save(path, out, enc, bom, crlf)


def main(argv):
    path, name, rest = argv[0], argv[1], argv[2:]
    sets, removes = {}, []
    delete = "--delete" in rest
    rename = None
    if "--rename" in rest:
        rename = rest[rest.index("--rename") + 1]
        rest = [r for r in rest if r not in ("--rename", rename)]
    for a in rest:
        if a == "--delete":
            continue
        if a.startswith("-") and "=" not in a:
            removes.append(a[1:])
        else:
            k, v = a.split("=", 1)
            sets[k] = v
    edit(path, name, sets, removes, delete, rename)


if __name__ == "__main__":
    main(sys.argv[1:])
