import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../horizont_theme.dart';
import '../tokens.g.dart';

/// The glyph of a product: the horizon on the lower third with its one
/// object (beech, raised hide, bus terminal, tank). Stroke 7 of 100, square
/// caps. Its baseline is the horizon, so in a `Row` with
/// `CrossAxisAlignment.baseline` it sits on the text's baseline.
class HorizontMark extends StatelessWidget {
  /// Creates the glyph of [product] at [size].
  const HorizontMark(this.product, {this.size = 24, this.color, super.key});

  /// Whose glyph.
  final HorizontProduct product;

  /// Width and height in logical pixels.
  final double size;

  /// Stroke colour; defaults to the text colour.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final stroke = color ?? HorizontTheme.of(context).colors.text;
    return Semantics(
      label: product.displayName,
      image: true,
      child: _HorizonBaseline(
        child: CustomPaint(
          size: Size.square(size),
          painter: _MarkPainter(product, stroke),
        ),
      ),
    );
  }
}

/// A mark next to a name, both on one baseline: the mark's horizon is a line
/// drawn under the word.
class HorizontLockup extends StatelessWidget {
  /// Creates a lockup of [product]'s mark and [label].
  const HorizontLockup(this.product, {required this.label, this.style, this.markColor, super.key});

  /// Whose mark.
  final HorizontProduct product;

  /// The name next to the mark.
  final String label;

  /// Style of the name; defaults to title-3.
  final TextStyle? style;

  /// Colour of the mark; defaults to the accent as text.
  final Color? markColor;

  @override
  Widget build(BuildContext context) {
    final theme = HorizontTheme.of(context);
    final s = style ?? horizontTextStyle(HzType.title3, theme.colors.text);
    final size = (s.fontSize ?? 17) * 1.15;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        HorizontMark(product, size: size, color: markColor ?? theme.colors.accentText),
        SizedBox(width: size * 0.35),
        Text(label, style: s),
      ],
    );
  }
}

/// Reports the horizon (two thirds down) as the child's alphabetic baseline.
class _HorizonBaseline extends SingleChildRenderObjectWidget {
  const _HorizonBaseline({required super.child});

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderHorizonBaseline();
}

class _RenderHorizonBaseline extends RenderProxyBox {
  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) => size.height * 2 / 3;
}

class _MarkPainter extends CustomPainter {
  _MarkPainter(this.product, this.color);

  final HorizontProduct product;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 100, size.height / 100);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.square
      ..strokeJoin = StrokeJoin.miter;
    canvas.drawPath(_path(product), paint);
    final thin = _thin(product);
    if (thin != null) canvas.drawPath(thin, paint..strokeWidth = 3.5);
  }

  /// Lines drawn at half the stroke: the tower of the town hall, set off
  /// from the walls down to the ground.
  static Path? _thin(HorizontProduct product) => switch (product) {
    HorizontProduct.kalkarKompakt => Path()
      ..moveTo(43, 26)
      ..lineTo(43, 66.7)
      ..moveTo(57, 26)
      ..lineTo(57, 66.7),
    _ => null,
  };

  static Path _path(HorizontProduct product) {
    final p = Path();
    void line(double x1, double y1, double x2, double y2) => p
      ..moveTo(x1, y1)
      ..lineTo(x2, y2);
    void poly(List<double> xy, {bool close = false}) {
      p.moveTo(xy[0], xy[1]);
      for (var i = 2; i < xy.length; i += 2) {
        p.lineTo(xy[i], xy[i + 1]);
      }
      if (close) p.close();
    }

    switch (product) {
      case HorizontProduct.regetskcob:
        line(4, 66.7, 96, 66.7);
        line(50, 66.7, 50, 48);
        p
          ..moveTo(50, 48)
          ..cubicTo(38, 48, 31, 42, 31, 33)
          ..cubicTo(31, 24, 39, 16, 50, 16)
          ..cubicTo(61, 16, 69, 24, 69, 33)
          ..cubicTo(69, 42, 62, 48, 50, 48)
          ..close();
      case HorizontProduct.jagdaufseher:
        line(4, 66.7, 96, 66.7);
        poly([36, 22, 50, 14, 64, 22]);
        poly([38, 24, 62, 24, 62, 40, 38, 40], close: true);
        line(41, 40, 33, 66.7);
        line(59, 40, 67, 66.7);
        line(37.6, 49, 62.4, 49);
        line(35, 58, 65, 58);
      case HorizontProduct.knx:
        line(4, 66.7, 35, 66.7);
        line(65, 66.7, 96, 66.7);
        poly([35, 40, 65, 40, 65, 74, 35, 74], close: true);
        line(50, 40, 50, 74);
      case HorizontProduct.panzergefecht:
        line(4, 66.7, 96, 66.7);
        poly([24, 66.7, 28, 54.7, 72, 54.7, 76, 66.7]);
        poly([40, 54.7, 40, 44, 58, 44, 58, 54.7]);
        line(58, 49, 82, 49);
      case HorizontProduct.kalkarKompakt:
        line(4, 66.7, 96, 66.7);
        poly([22, 66.7, 22, 40, 34, 26, 43, 26, 43, 22, 50, 4, 57, 22, 57, 26, 66, 26, 78, 40, 78, 66.7]);
    }
    return p;
  }

  @override
  bool shouldRepaint(_MarkPainter old) => old.product != product || old.color != color;
}
