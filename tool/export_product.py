"""Packs what Horizont knows about one product, ready to move into its repo.

Horizont 2.0 keeps the guard rails (neutrals, status, type, grid, rules) and
hands the product decisions back to the products: accent, own neutrals, mark
and app icon. This writes that share for one product to a folder:

  <out>/horizont.product.json   the product's entry of tokens/horizont.json,
                                checked against the guard rails below
  <out>/mark/                   glyph and icon sources (icons/svg/<id>/)
  <out>/icons/                  the platform sets (icons/export/<id>/)

Usage: python3 tool/export_product.py <id> <out> [--check]
With --check nothing is written; the exit code says whether the product's
colours hold the contrast rules. Nothing in this repository changes.
"""

import json
import shutil
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent


def _lum(hex_color: str) -> float:
    h = hex_color.lstrip("#")
    r, g, b = (int(h[i : i + 2], 16) / 255 for i in (0, 2, 4))
    f = lambda c: c / 12.92 if c <= 0.03928 else ((c + 0.055) / 1.055) ** 2.4
    return 0.2126 * f(r) + 0.7152 * f(g) + 0.0722 * f(b)


def contrast(a: str, b: str) -> float:
    la, lb = sorted((_lum(a), _lum(b)), reverse=True)
    return (la + 0.05) / (lb + 0.05)


def check(product: dict, neutral: dict) -> list[str]:
    """The guard rails for a product's accent, per brightness."""
    problems = []
    for mode in ("light", "dark"):
        a = product[mode]
        grounds = dict(neutral[mode])
        if mode == "dark" and "neutralDark" in product:
            grounds.update(product["neutralDark"])
        for ground in ("bg", "surface", "sunken"):
            c = contrast(a["accent-text"], grounds[ground])
            if c < 4.5:
                problems.append(f"{mode}: accent-text on {ground} is {c:.2f}:1, needs 4.5:1")
        c = contrast(a["on-accent"], a["accent"])
        if c < 4.5:
            problems.append(f"{mode}: on-accent on accent is {c:.2f}:1, needs 4.5:1")
        c = contrast(grounds["text"], a["accent-tint"])
        if c < 4.5:
            problems.append(f"{mode}: text on accent-tint is {c:.2f}:1, needs 4.5:1")
    return problems


def main() -> int:
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    only_check = "--check" in sys.argv
    if len(args) < (1 if only_check else 2):
        print(__doc__)
        return 2
    tokens = json.loads((ROOT / "tokens/horizont.json").read_text())
    pid = args[0]
    product = tokens["color"]["product"].get(pid)
    if product is None:
        print(f"unknown product {pid!r}; known: {', '.join(tokens['color']['product'])}")
        return 2
    problems = check(product, tokens["color"]["neutral"])
    for p in problems:
        print(f"{pid}: {p}")
    if only_check:
        return 1 if problems else 0
    out = Path(args[1])
    out.mkdir(parents=True, exist_ok=True)
    doc = {"id": pid, "horizont": tokens["version"], **product}
    (out / "horizont.product.json").write_text(json.dumps(doc, ensure_ascii=False, indent=2) + "\n")
    for src, dst in ((ROOT / "icons/svg" / pid, out / "mark"), (ROOT / "icons/export" / pid, out / "icons")):
        if src.is_dir():
            shutil.copytree(src, dst, dirs_exist_ok=True)
    print(f"{pid}: written to {out}")
    return 1 if problems else 0


if __name__ == "__main__":
    sys.exit(main())
