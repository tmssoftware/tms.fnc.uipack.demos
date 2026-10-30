"""formfile.py - a small reader/writer for Delphi/Lazarus text form files (.fmx, .dfm, .lfm).

parse(text) returns the root FormObject; every object keeps its property entries with the line
range they occupy, so callers can remove or rewrite single properties and objects while the rest
of the file stays byte-identical (line endings and encoding are preserved by the caller).

Collections (`Columns = < item ... end >`) are read as entries whose items carry their own
properties: an item property has the path `Columns[0].Font.Color`.
"""

import re

OBJ = re.compile(r"^(\s*)(object|inherited|inline)\s+(?:(\w+)\s*:\s*)?([\w.]+)(?:\s*\[\d+\])?\s*$")
PROP = re.compile(r"^(\s*)([\w.]+)\s*=\s*(.*)$")


class Prop:
    def __init__(self, path, value, start, end, indent):
        self.path = path          # dotted, collection items as Name[i]
        self.value = value        # first-line value text (multi-line values: the joined text)
        self.start = start        # first line index
        self.end = end            # last line index (inclusive)
        self.indent = indent

    def __repr__(self):
        return f"Prop({self.path}={self.value[:40]!r} @{self.start + 1})"


class FormObject:
    def __init__(self, name, cls, start, indent, parent=None):
        self.name = name
        self.cls = cls
        self.start = start
        self.end = None
        self.indent = indent
        self.parent = parent
        self.props = []
        self.children = []

    def walk(self):
        yield self
        for c in self.children:
            yield from c.walk()

    def prop(self, path):
        for p in self.props:
            if p.path.lower() == path.lower():
                return p
        return None

    def __repr__(self):
        return f"{self.name}: {self.cls}"


def _value_end(lines, i, value):
    """Index of the last line of a property value starting on line i."""
    v = value.strip()
    if v == "(" or (v.startswith("(") and not v.endswith(")")):
        j = i + 1
        while j < len(lines) and not lines[j].rstrip().endswith(")"):
            j += 1
        return j
    if v == "{" or (v.startswith("{") and not v.endswith("}")):
        j = i + 1
        while j < len(lines) and not lines[j].rstrip().endswith("}"):
            j += 1
        return j
    # continued string literals: 'abc' + (a value can also start on the next line)
    j = i + 1 if v == "" and i + 1 < len(lines) else i
    while lines[j].rstrip().endswith("+") and j + 1 < len(lines):
        j += 1
    return j


def parse(text):
    lines = text.splitlines()
    root = None
    stack = []
    i = 0
    coll = []  # (name, index, item_open) collection context inside the current object
    while i < len(lines):
        line = lines[i]
        s = line.strip()
        m = OBJ.match(line)
        if m and not coll:
            o = FormObject(m.group(3) or "", m.group(4), i, len(m.group(1)), stack[-1] if stack else None)
            if stack:
                stack[-1].children.append(o)
            else:
                root = o
            stack.append(o)
            i += 1
            continue
        if s == "end" and not coll:
            if stack:
                stack[-1].end = i
                stack.pop()
            i += 1
            continue
        if coll:
            # inside a collection value: item / end / end> / properties
            name, idx, open_ = coll[-1]
            if s == "item":
                coll[-1] = (name, idx + 1, True)
                i += 1
                continue
            if s in ("end", "end>"):
                if s == "end>":
                    coll.pop()
                else:
                    coll[-1] = (name, idx, False)
                i += 1
                continue
            if s.endswith(">") and s.startswith("end"):
                coll.pop()
                i += 1
                continue
        m = PROP.match(line)
        if m and stack:
            path, value = m.group(2), m.group(3)
            if value.strip() == "<":
                coll.append((path if not coll else _coll_path(coll) + "." + path, -1, False))
                i += 1
                continue
            if value.strip() == "<>":
                i += 1
                continue
            j = _value_end(lines, i, value)
            full = value if j == i else "\n".join(l.strip() for l in lines[i:j + 1])
            if coll:
                path = _coll_path(coll) + "." + path
            stack[-1].props.append(Prop(path, full, i, j, len(m.group(1))))
            i = j + 1
            continue
        i += 1
    return root


def _coll_path(coll):
    parts = []
    for name, idx, _ in coll:
        last = name.split(".")[-1] if parts else name
        parts.append(f"{last}[{max(idx, 0)}]")
    return ".".join(parts)


COLOR_PROP = re.compile(r"(^|\.)(\w*Colou?r\w*)$", re.I)
NULL_COLORS = {"clanull", "gcnull", "clnone", "-1", "536870911", "$1fffffff", "x00000000", "0"}


def is_color_prop(path):
    leaf = path.split(".")[-1]
    return bool(re.search(r"colou?r", leaf, re.I)) and not re.search(r"(Kind|Mode|Count|Scheme|Index|Name|Type|Style|Sync)$", leaf)


def color_value(value, idents):
    """Integer value of a streamed colour (cla/cl/gc ident, xAARRGGBB, $hex, decimal), or None."""
    v = value.strip()
    if not v:
        return None
    if re.fullmatch(r"-?\d+", v):
        return int(v) & 0xFFFFFFFF
    if re.fullmatch(r"x[0-9A-Fa-f]{8}", v):
        return int(v[1:], 16)
    if re.fullmatch(r"\$[0-9A-Fa-f]+", v):
        return int(v[1:], 16) & 0xFFFFFFFF
    k = v.lower()
    if k in idents:
        return int(idents[k]) & 0xFFFFFFFF
    return None
