"""Cuts the text fonts of Horizont down to the letters the products write.

Literata, Mona Sans and Monaspace come with Greek, Cyrillic, Vietnamese and
many symbols. The products write German and English, so the fonts keep Latin
with its extensions (all of Western and Central Europe), punctuation, arrows,
math signs and the few marks the products draw as text (✓, ★, ●, ▲).
Flutter's web build loads every font of the manifest before its first frame,
so every kilobyte here is waiting time in the browser (Panzergefecht's game
grew by 1.1 MB gzipped with the uncut fonts).

Layout features stay (tabular figures, Monaspace's texture healing, kerning),
hinting goes: the platforms render without it at these sizes.

A cut font is a Modified Version under the SIL OFL 1.1, and Mona Sans
("Mona") and Monaspace ("Monaspace") reserve their names. So the cut files
are renamed inside: Horizont Sans, Horizont Sans Display and Horizont Mono.
Copyright, trademark, designer and licence entries stay as they are. The
families in pubspec.yaml and the CSS keep their names and file names.

Writes in place, so the range can only shrink; to widen it, start from the
original files (Literata: Google Fonts, Mona Sans and Monaspace:
github.com/githubnext) placed under flutter/fonts/ first.

  flutter/fonts/*.ttf|*.otf   cut in place
  web/fonts/*/*.woff2          written from the cut files

Needs fontTools and brotli (the .venv of tool/build_symbols.py). Usage:

  python tool/subset_fonts.py
"""

from __future__ import annotations

from pathlib import Path

from fontTools import subset
from fontTools.ttLib import TTFont

ROOT = Path(__file__).resolve().parent.parent

UNICODES = [
    (0x0020, 0x007E),  # Basic Latin
    (0x00A0, 0x017F),  # Latin-1 Supplement, Latin Extended-A
    (0x0192, 0x0192),  # ƒ
    (0x0218, 0x021B),  # Ș ș Ț ț
    (0x02C6, 0x02DD),  # spacing modifiers (circumflex, caron, breve …)
    (0x1E9E, 0x1E9E),  # ẞ
    (0x2000, 0x206F),  # General Punctuation (dashes, quotes, …, ‰, thin spaces)
    (0x2070, 0x209F),  # super- and subscripts (CO₂, m³)
    (0x20AC, 0x20AC),  # €
    (0x2116, 0x2116),  # №
    (0x2122, 0x2122),  # ™
    (0x2190, 0x2199),  # arrows
    (0x2212, 0x2212),  # minus
    (0x2215, 0x2215),  # division slash
    (0x221E, 0x221E),  # ∞
    (0x2248, 0x2248),  # ≈
    (0x2260, 0x2260),  # ≠
    (0x2264, 0x2265),  # ≤ ≥
    (0x22EF, 0x22EF),  # ⋯
    (0x23EF, 0x23EF),  # ⏯
    (0x25A0, 0x25FF),  # geometric shapes (● ○ ▲ △ ■ □)
    (0x2605, 0x2606),  # ★ ☆
    (0x2713, 0x2717),  # ✓ ✔ ✕ ✖ ✗
    (0xFB01, 0xFB02),  # fi fl
]

# Flutter file -> web file (same family, same cut).
FONTS = {
    "Literata-Light.ttf": "Literata/Literata-Light.woff2",
    "Literata-LightItalic.ttf": "Literata/Literata-LightItalic.woff2",
    "Literata-SemiBold.ttf": "Literata/Literata-SemiBold.woff2",
    "MonaSans-Regular.ttf": "MonaSans/MonaSans-Regular.woff2",
    "MonaSans-Medium.ttf": "MonaSans/MonaSans-Medium.woff2",
    "MonaSans-SemiBold.ttf": "MonaSans/MonaSans-SemiBold.woff2",
    "MonaSansDisplayExpanded-Bold.ttf": "MonaSans/MonaSansDisplayExpanded-Bold.woff2",
    "MonaSansDisplayExpanded-Black.ttf": "MonaSans/MonaSansDisplayExpanded-Black.woff2",
    "MonaspaceArgon-Regular.otf": "Monaspace/MonaspaceArgon-Regular.woff2",
    "MonaspaceArgon-SemiBold.otf": "Monaspace/MonaspaceArgon-SemiBold.woff2",
}


# Reserved name -> Horizont name, longest first.
RENAMES = [
    ("Mona Sans Display Expanded", "Horizont Sans Display"),
    ("MonaSansDisplayExpanded", "HorizontSansDisplay"),
    ("Monaspace Argon", "Horizont Mono"),
    ("MonaspaceArgon", "HorizontMono"),
    ("Mona Sans", "Horizont Sans"),
    ("MonaSans", "HorizontSans"),
    ("Monaspace", "Horizont Mono"),
]

# Name IDs that credit the original and stay: copyright, trademark,
# manufacturer, designer, description, URLs, licence.
KEEP_NAME_IDS = {0, 7, 8, 9, 10, 11, 12, 13, 14}


def renamed(text: str) -> str:
    for reserved, own in RENAMES:
        text = text.replace(reserved, own)
    return text


def rename(font: TTFont) -> None:
    """Takes the Reserved Font Names out of the names of [font]."""
    for record in font["name"].names:
        # 256 and up name features (stylistic sets), not the font.
        if record.nameID in KEEP_NAME_IDS or record.nameID >= 256:
            continue
        record.string = renamed(record.toUnicode())
    if "CFF " in font:
        cff = font["CFF "].cff
        cff.fontNames = [renamed(name) for name in cff.fontNames]
        top = cff.topDictIndex[0]
        for key in ("FullName", "FamilyName"):
            if hasattr(top, key):
                setattr(top, key, renamed(getattr(top, key)))


def cut(source: Path, target: Path, flavor: str | None) -> None:
    options = subset.Options()
    options.layout_features = ["*"]
    options.name_IDs = ["*"]
    options.name_languages = ["*"]
    options.notdef_outline = True
    options.hinting = False
    options.drop_tables += ["DSIG"]
    options.flavor = flavor
    font = TTFont(source)
    subsetter = subset.Subsetter(options)
    subsetter.populate(
        unicodes=[c for start, end in UNICODES for c in range(start, end + 1)]
    )
    subsetter.subset(font)
    rename(font)
    font.flavor = flavor
    font.save(target)


def main() -> None:
    for name, web in FONTS.items():
        source = ROOT / "flutter/fonts" / name
        before = source.stat().st_size
        cut(source, source, None)
        cut(source, ROOT / "web/fonts" / web, "woff2")
        print(
            f"{name}: {before // 1024} -> {source.stat().st_size // 1024} KB,"
            f" woff2 {(ROOT / 'web/fonts' / web).stat().st_size // 1024} KB"
        )


if __name__ == "__main__":
    main()
