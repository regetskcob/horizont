"""Writes TrueType copies of the Monaspace cuts for tools that cannot embed CFF outlines.

The Dart pdf package reads glyf outlines only, so PDFs need these .ttf files. Curves are
converted with cu2qu; names, metrics and features stay. Needs fontTools. Usage:

  python tool/otf_to_ttf.py
"""

from pathlib import Path

from fontTools.pens.cu2quPen import Cu2QuPen
from fontTools.pens.ttGlyphPen import TTGlyphPen
from fontTools.ttLib import TTFont, newTable

FONTS = Path(__file__).resolve().parent.parent / "flutter/fonts"


def convert(path: Path) -> None:
    font = TTFont(path)
    glyphs = font.getGlyphSet()
    order = font.getGlyphOrder()
    outlines = {}
    for name in order:
        pen = TTGlyphPen(glyphs)
        glyphs[name].draw(Cu2QuPen(pen, max_err=1.0, reverse_direction=True))
        outlines[name] = pen.glyph()
    glyf = newTable("glyf")
    glyf.glyphOrder = order
    glyf.glyphs = outlines
    font["glyf"] = glyf
    font["loca"] = newTable("loca")
    del font["CFF "]
    for table in ("VORG",):
        if table in font:
            del font[table]
    maxp = font["maxp"]
    maxp.tableVersion = 0x00010000
    for field in (
        "maxZones", "maxTwilightPoints", "maxStorage", "maxFunctionDefs", "maxInstructionDefs",
        "maxStackElements", "maxSizeOfInstructions", "maxComponentElements", "maxComponentDepth",
    ):
        setattr(maxp, field, 1 if field == "maxZones" else 0)
    font["post"].formatType = 2.0
    font["post"].extraNames = []
    font["post"].mapping = {}
    font["post"].glyphOrder = None
    font.sfntVersion = "\000\001\000\000"
    font.save(path.with_suffix(".ttf"))


for name in ("MonaspaceArgon-Regular.otf", "MonaspaceArgon-SemiBold.otf"):
    convert(FONTS / name)
    print(name)
