import 'dart:ui';

import 'package:flutter/foundation.dart';

/// The glyph of a product as drawn by `HorizontMark`: paths in a box of
/// 100 by 100 with the horizon at 66.7, stroked 7 wide with square caps.
///
/// A product draws its own glyph and hands it to its `HorizontProduct`:
///
/// ```dart
/// Path _mailbox() => Path()
///   ..moveTo(4, 66.7)
///   ..lineTo(96, 66.7)
///   …;
///
/// const glyph = HorizontGlyph(_mailbox);
/// ```
///
/// The rules of the drawing stay Horizont's: the line on the lower third,
/// one object on it, no fills.
@immutable
class HorizontGlyph {
  /// Creates a glyph from [path] and, for details, [thin]. Both are
  /// top-level or static functions, so the glyph can be `const`.
  const HorizontGlyph(this.path, {this.thin});

  /// The strokes at full width (7 of 100), the horizon included.
  final Path Function() path;

  /// Strokes at half the width (3.5 of 100), for a seam or a tower that
  /// has to stand off from the walls; null for most glyphs.
  final Path Function()? thin;
}

/// The glyphs Horizont still draws itself. Only [regetskcob] stays; the
/// others move to their products with 2.0.
abstract final class HorizontGlyphs {
  /// The beech on the line.
  static const regetskcob = HorizontGlyph(_regetskcob);

  /// The raised hide.
  static const jagdaufseher = HorizontGlyph(_jagdaufseher);

  /// The bus terminal sitting in the line.
  static const knx = HorizontGlyph(_knx);

  /// The tank in side view.
  static const panzergefecht = HorizontGlyph(_panzergefecht);

  /// The town hall of Kalkar, its tower in the thin stroke.
  static const kalkarKompakt = HorizontGlyph(_kalkarKompakt, thin: _kalkarKompaktThin);

  /// The signpost with two arms.
  static const gemarkung = HorizontGlyph(_gemarkung);

  /// The mailbox on its post, the flag raised; the door seam is thin.
  static const landbote = HorizontGlyph(_landbote, thin: _landboteThin);

  /// The seed sack on the line, seeds scattered to every side.
  static const streuwerk = HorizontGlyph(_streuwerk);
}

void _line(Path p, double x1, double y1, double x2, double y2) => p
  ..moveTo(x1, y1)
  ..lineTo(x2, y2);

void _poly(Path p, List<double> xy, {bool close = false}) {
  p.moveTo(xy[0], xy[1]);
  for (var i = 2; i < xy.length; i += 2) {
    p.lineTo(xy[i], xy[i + 1]);
  }
  if (close) p.close();
}

Path _horizon() => Path()
  ..moveTo(4, 66.7)
  ..lineTo(96, 66.7);

Path _regetskcob() {
  final p = _horizon();
  _line(p, 50, 66.7, 50, 48);
  return p
    ..moveTo(50, 48)
    ..cubicTo(38, 48, 31, 42, 31, 33)
    ..cubicTo(31, 24, 39, 16, 50, 16)
    ..cubicTo(61, 16, 69, 24, 69, 33)
    ..cubicTo(69, 42, 62, 48, 50, 48)
    ..close();
}

Path _jagdaufseher() {
  final p = _horizon();
  _poly(p, [36, 22, 50, 14, 64, 22]);
  _poly(p, [38, 24, 62, 24, 62, 40, 38, 40], close: true);
  _line(p, 41, 40, 33, 66.7);
  _line(p, 59, 40, 67, 66.7);
  _line(p, 37.6, 49, 62.4, 49);
  _line(p, 35, 58, 65, 58);
  return p;
}

Path _knx() {
  final p = Path();
  _line(p, 4, 66.7, 35, 66.7);
  _line(p, 65, 66.7, 96, 66.7);
  _poly(p, [35, 40, 65, 40, 65, 74, 35, 74], close: true);
  _line(p, 50, 40, 50, 74);
  return p;
}

Path _panzergefecht() {
  final p = _horizon();
  _poly(p, [24, 66.7, 28, 54.7, 72, 54.7, 76, 66.7]);
  _poly(p, [40, 54.7, 40, 44, 58, 44, 58, 54.7]);
  _line(p, 58, 49, 82, 49);
  return p;
}

Path _kalkarKompakt() {
  final p = _horizon();
  _poly(p, [22, 66.7, 22, 40, 34, 26, 43, 26, 43, 22, 50, 4, 57, 22, 57, 26, 66, 26, 78, 40, 78, 66.7]);
  return p;
}

Path _kalkarKompaktThin() {
  final p = Path();
  _line(p, 43, 26, 43, 66.7);
  _line(p, 57, 26, 57, 66.7);
  return p;
}

Path _gemarkung() {
  final p = _horizon();
  _line(p, 50, 66.7, 50, 22);
  _poly(p, [50, 28, 70, 28, 75, 33, 70, 38, 50, 38]);
  _poly(p, [50, 44, 30, 44, 25, 49, 30, 54, 50, 54]);
  return p;
}

Path _streuwerk() {
  final p = _horizon();
  _poly(p, [20, 66.7, 23, 43, 29, 35, 38, 35, 44, 43, 47, 66.7]);
  for (final (x, y) in const [(9.0, 46.0), (30.0, 22.0), (48.0, 18.0), (62.0, 30.0), (78.0, 44.0)]) {
    _line(p, x, y, x + 1, y);
  }
  return p;
}

Path _landbote() {
  final p = _horizon();
  _line(p, 50, 66.7, 50, 46);
  p
    ..moveTo(22, 46)
    ..lineTo(22, 37)
    ..arcToPoint(const Offset(31, 28), radius: const Radius.circular(9))
    ..lineTo(65, 28)
    ..arcToPoint(const Offset(74, 37), radius: const Radius.circular(9))
    ..lineTo(74, 46)
    ..close();
  _line(p, 66, 28, 66, 13.5);
  _line(p, 66, 13.5, 76, 13.5);
  return p;
}

Path _landboteThin() {
  final p = Path();
  _line(p, 32, 31, 32, 43);
  return p;
}
