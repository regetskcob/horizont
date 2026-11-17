import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../horizont_theme.dart';
import '../tokens.g.dart';

/// The glyph of a product: the horizon on the lower third with its one
/// object, taken from the product's `mark` (a `HorizontGlyph`). Stroke 7 of
/// 100, square caps. Its baseline is the horizon, so in a `Row` with
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
  const HorizontLockup(
    this.product, {
    required this.label,
    this.style,
    this.markColor,
    super.key,
  });

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
        HorizontMark(
          product,
          size: size,
          color: markColor ?? theme.colors.accentText,
        ),
        SizedBox(width: size * 0.35),
        // Wraps instead of running over the edge at large text sizes.
        Flexible(child: Text(label, style: s)),
      ],
    );
  }
}

/// Reports the horizon (two thirds down) as the child's alphabetic baseline.
class _HorizonBaseline extends SingleChildRenderObjectWidget {
  const _HorizonBaseline({required super.child});

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderHorizonBaseline();
}

class _RenderHorizonBaseline extends RenderProxyBox {
  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) =>
      size.height * 2 / 3;
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
    final glyph = product.mark;
    if (glyph == null) {
      // A product without a glyph still stands on the line.
      canvas.drawLine(const Offset(4, 66.7), const Offset(96, 66.7), paint);
      return;
    }
    canvas.drawPath(glyph.path(), paint);
    final thin = glyph.thin;
    if (thin != null) canvas.drawPath(thin(), paint..strokeWidth = 3.5);
  }

  @override
  bool shouldRepaint(_MarkPainter old) =>
      old.product != product || old.color != color;
}
