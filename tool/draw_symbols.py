"""Draws the symbols Material Symbols lacks, in its grid and stroke.

Material Symbols Sharp at weight 300 and optical size 24 draws on a grid of
960 units with a stroke of 60 (1.5 px at 24 px), square ends, sharp joins,
the motif between about 80 and 880. Each symbol here is built from those
strokes with shapely and written as one filled outline to

  icons/symbols/<name>.svg   viewBox 0 -960 960 960, like Material's SVGs

tool/build_symbols.py takes the outlines into the subset font. The SVGs are
the source; this script only makes them reproducible. Needs shapely. Usage:

  python tool/draw_symbols.py
"""

import math
from pathlib import Path

from shapely import affinity
from shapely.geometry import LineString, Point, Polygon, box
from shapely.geometry.polygon import orient
from shapely.ops import unary_union

ROOT = Path(__file__).resolve().parent.parent
STROKE = 60


def line(*points):
    """A straight stroke with square ends."""
    return LineString(points).buffer(
        STROKE / 2, cap_style="flat", join_style="mitre", mitre_limit=10
    )


def ring(shape):
    """The outline of [shape], drawn inward."""
    return shape.difference(shape.buffer(-STROKE, join_style="mitre"))


def ellipse(cx, cy, rx, ry):
    return affinity.translate(affinity.scale(Point(0, 0).buffer(1, 128), rx, ry), cx, cy)


def arc(cx, cy, rx, ry, start, end, steps=64):
    """A stroke along an elliptic arc, angles in degrees."""
    points = [
        (cx + rx * math.cos(math.radians(start + (end - start) * i / steps)),
         cy + ry * math.sin(math.radians(start + (end - start) * i / steps)))
        for i in range(steps + 1)
    ]
    return LineString(points).buffer(STROKE / 2, cap_style="flat", join_style="round")


def basket_woven():
    """A wicker basket: round belly on a flat foot, lip, handle, woven sides."""
    belly = Polygon([
        (480 + 340 * math.cos(math.radians(a)), 520 - 400 * math.sin(math.radians(a)))
        for a in range(0, 181, 2)
    ]).intersection(box(0, 150, 960, 960))
    weave = unary_union(
        [line((x, 120), (x + 400, 520)) for x in range(-200, 900, 150)]
        + [line((x, 120), (x - 400, 520)) for x in range(100, 1300, 150)]
    )
    return unary_union([
        ring(belly),
        weave.intersection(belly.buffer(-STROKE, join_style="mitre")),
        box(90, 500, 870, 580),  # the lip, wider than the belly
        arc(480, 580, 240, 280, 0, 180),
    ])


def steak():
    """A rib-eye: the cut, a round bone, the fat along the tail."""
    cut = unary_union([ellipse(420, 560, 330, 250), ellipse(650, 340, 240, 200)])
    cut = affinity.rotate(cut.buffer(110).buffer(-110), -5, origin=(480, 480))
    x0, y0, x1, y1 = cut.bounds
    cut = affinity.translate(cut, 480 - (x0 + x1) / 2, 480 - (y0 + y1) / 2)
    fat = cut.buffer(-140).exterior.intersection(box(560, 0, 960, 960))
    return unary_union([
        ring(cut),
        fat.buffer(STROKE / 2, cap_style="flat", join_style="round"),
        Point(360, 560).buffer(100, 128).difference(Point(360, 560).buffer(42, 128)),
    ])


def svg(shape) -> str:
    """One path, y flipped into Material's viewBox; outer contours clockwise in the font."""
    parts = []
    for polygon in getattr(shape, "geoms", [shape]):
        polygon = orient(polygon, sign=-1.0)
        for r in [polygon.exterior, *polygon.interiors]:
            points = list(r.coords)[:-1]
            parts.append("M" + "L".join(f"{x:.0f} {-y:.0f}" for x, y in points) + "Z")
    return (
        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 -960 960 960" '
        f'width="24" height="24"><path d="{"".join(parts)}"/></svg>\n'
    )


SYMBOLS = {"basket_woven": basket_woven, "steak": steak}

if __name__ == "__main__":
    out = ROOT / "icons/symbols"
    out.mkdir(parents=True, exist_ok=True)
    for name, draw in SYMBOLS.items():
        (out / f"{name}.svg").write_text(svg(draw().simplify(0.6)))
        print(f"icons/symbols/{name}.svg")
