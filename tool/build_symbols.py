"""Cuts Material Symbols Sharp down to the icons Horizont uses.

The upstream font is variable (FILL, GRAD, opsz, wght) and holds some 3,800
icons. The products need about a hundred, at one setting: outlined (FILL 0),
GRAD 0, optical size 24, weight 300. This pins the axes, keeps only the
glyphs of the names in icons/material-symbols.txt (by codepoint, no
ligatures: Flutter and the web address them by codepoint) and writes

  flutter/fonts/MaterialSymbolsSharp-300.ttf
  web/fonts/MaterialSymbols/MaterialSymbolsSharp-300.woff2
  icons/material-symbols.json   name -> codepoint

A line `name:fill` adds the filled form (FILL 1) of that icon as
`name_fill`, at the private-use codepoint 0xF0000 + the outlined one (star
0xf09a -> star_fill 0xff09a). Filled forms mark a state that is on (pinned,
favourite), never decoration.

What Material Symbols lacks, Horizont draws in its grid and stroke
(tool/draw_symbols.py): a name in the list with an outline in
icons/symbols/<name>.svg and a fixed codepoint in icons/symbols/codepoints,
in the private-use plane 16 (0x100000 and up), clear of Material and of
the filled forms.

Needs fontTools and brotli. Usage:

  python tool/build_symbols.py <MaterialSymbolsSharp[...].ttf> <...codepoints>

Source: https://github.com/google/material-design-icons/tree/master/variablefont
"""

import json
import sys
from pathlib import Path

from fontTools import subset
from fontTools.pens.ttGlyphPen import TTGlyphPen
from fontTools.svgLib import SVGPath
from fontTools.ttLib import TTFont
from fontTools.ttLib.tables._c_m_a_p import CmapSubtable
from fontTools.varLib import instancer

ROOT = Path(__file__).resolve().parent.parent
OWN = ROOT / "icons/symbols"


def main(font_path: str, codepoints_path: str) -> None:
    lines = [
        line.strip()
        for line in (ROOT / "icons/material-symbols.txt").read_text().splitlines()
        if line.strip() and not line.startswith("#")
    ]
    names = [line for line in lines if not line.endswith(":fill")]
    filled = [line.removesuffix(":fill") for line in lines if line.endswith(":fill")]
    table = {}
    for line in Path(codepoints_path).read_text().splitlines():
        name, code = line.split()
        table.setdefault(name, int(code, 16))
    own = {}
    for line in (OWN / "codepoints").read_text().splitlines():
        name, code = line.split()
        own[name] = int(code, 16)
    missing = [n for n in names + filled if n not in table and n not in own]
    if missing:
        sys.exit(f"not in Material Symbols: {', '.join(missing)}")
    chosen = {n: table[n] for n in names if n not in own}

    font = cut(font_path, 0, sorted(set(chosen.values())))
    added = {}  # codepoint -> (glyph name, glyph, (advance, lsb))
    if filled:
        solid = cut(font_path, 1, sorted({table[n] for n in filled}))
        solid_cmap = solid.getBestCmap()
        for name in filled:
            source = solid_cmap[table[name]]
            added[0xF0000 + table[name]] = (
                f"{name}_fill", solid["glyf"][source], solid["hmtx"][source]
            )
            chosen[f"{name}_fill"] = 0xF0000 + table[name]
    for name in names:
        if name in own:
            glyph = draw(OWN / f"{name}.svg")
            added[own[name]] = (name, glyph, (960, glyph.xMin))
            chosen[name] = own[name]
    if added:
        order = list(font.getGlyphOrder())
        for code, (name, glyph, metrics) in added.items():
            font["glyf"][name] = glyph
            font["hmtx"][name] = metrics
            if name not in order:
                order.append(name)
            for t in font["cmap"].tables:
                if t.isUnicode() and (code <= 0xFFFF or t.format == 12):
                    t.cmap[code] = name
        font.setGlyphOrder(order)
        if not any(t.format == 12 for t in font["cmap"].tables):
            # Codepoints above 0xFFFF need a format 12 subtable.
            t12 = CmapSubtable.newSubtable(12)
            t12.platformID, t12.platEncID, t12.language = 3, 10, 0
            t12.cmap = dict(font.getBestCmap())
            for code, (name, _, _) in added.items():
                t12.cmap[code] = name
            font["cmap"].tables.append(t12)
        font["maxp"].numGlyphs = len(order)

    # The JSON follows the list, the filled form right after its outline.
    chosen = {
        (f"{n.removesuffix(':fill')}_fill" if n.endswith(":fill") else n):
        chosen[f"{n.removesuffix(':fill')}_fill" if n.endswith(":fill") else n]
        for n in lines
    }

    ttf = ROOT / "flutter/fonts/MaterialSymbolsSharp-300.ttf"
    ttf.parent.mkdir(parents=True, exist_ok=True)
    font.flavor = None
    font.save(ttf)
    woff2 = ROOT / "web/fonts/MaterialSymbols/MaterialSymbolsSharp-300.woff2"
    woff2.parent.mkdir(parents=True, exist_ok=True)
    font.flavor = "woff2"
    font.save(woff2)
    (ROOT / "icons/material-symbols.json").write_text(
        json.dumps({n: f"0x{c:04x}" for n, c in chosen.items()}, indent=2) + "\n"
    )
    print(f"{len(chosen)} icons, {ttf.stat().st_size // 1024} KB ttf, "
          f"{woff2.stat().st_size // 1024} KB woff2")


def draw(svg_path: Path):
    """The glyph of an outline in icons/symbols/, flipped from SVG to font."""
    svg = SVGPath(str(svg_path), transform=(1, 0, 0, -1, 0, 0))
    pen = TTGlyphPen(None)
    svg.draw(pen)
    glyph = pen.glyph()
    glyph.recalcBounds(None)
    return glyph


def cut(font_path: str, fill: int, unicodes: list[int]) -> TTFont:
    """The font at one setting, cut to [unicodes]."""
    font = instancer.instantiateVariableFont(
        TTFont(font_path), {"FILL": fill, "GRAD": 0, "opsz": 24, "wght": 300}
    )
    options = subset.Options()
    options.layout_features = []
    options.name_IDs = ["*"]
    options.notdef_outline = True
    sub = subset.Subsetter(options)
    sub.populate(unicodes=unicodes)
    sub.subset(font)
    return font


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
