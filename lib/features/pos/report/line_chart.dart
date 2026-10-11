import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../core/money.dart';

/// One point on the chart: a label for the x axis and a whole-paise value.
class ChartPoint {
  const ChartPoint(this.label, this.paise);
  final String label;
  final int paise;
}

/// A smooth line with a soft fill, drawn without any chart package. Heights are only proportions of the server's
/// numbers; the highest value is written out in words below (and read out by a screen reader).
class MoneyLineChart extends StatelessWidget {
  const MoneyLineChart({required this.points, required this.title, super.key, this.height = 200});
  final List<ChartPoint> points;
  final String title;
  final double height;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    if (points.isEmpty) return Text(l10n.posRepChartNone, style: text.bodyMedium);
    final high = points.reduce((a, b) => b.paise > a.paise ? b : a);
    final summary = l10n.posRepChartHigh(formatPaise(high.paise), high.label);
    return Semantics(
      container: true,
      label: '$title. $summary',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: height,
            child: CustomPaint(
              painter: _Painter(points: points, line: scheme.primary, fill: scheme.primaryContainer, grid: scheme.outline, label: text.bodySmall!.copyWith(color: scheme.onSurfaceVariant)),
            ),
          ),
          const SizedBox(height: 6),
          Text(summary, style: text.bodySmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _Painter extends CustomPainter {
  _Painter({required this.points, required this.line, required this.fill, required this.grid, required this.label});
  final List<ChartPoint> points;
  final Color line;
  final Color fill;
  final Color grid;
  final TextStyle label;

  void _text(Canvas c, String s, Offset at, {bool right = false, bool center = false}) {
    final tp = TextPainter(text: TextSpan(text: s, style: label), textDirection: TextDirection.ltr, maxLines: 1)..layout();
    final dx = right ? at.dx - tp.width : (center ? at.dx - tp.width / 2 : at.dx);
    tp.paint(c, Offset(dx, at.dy));
  }

  @override
  void paint(Canvas canvas, Size size) {
    const leftPad = 52.0, bottomPad = 22.0, topPad = 8.0, rightPad = 12.0;
    final w = size.width - leftPad - rightPad;
    final h = size.height - bottomPad - topPad;
    final maxV = math.max(1, points.map((p) => p.paise).reduce(math.max));
    Offset pt(int i) {
      final x = leftPad + (points.length == 1 ? w / 2 : w * i / (points.length - 1));
      final y = topPad + h - h * points[i].paise / maxV;
      return Offset(x, y);
    }

    final gridPaint = Paint()
      ..color = grid
      ..strokeWidth = 1;
    for (final f in [0.0, 0.5, 1.0]) {
      final y = topPad + h - h * f;
      canvas.drawLine(Offset(leftPad, y), Offset(size.width - rightPad, y), gridPaint);
      _text(canvas, formatPaise((maxV * f).round()), Offset(leftPad - 6, y - 7), right: true);
    }
    final pts = [for (var i = 0; i < points.length; i++) pt(i)];
    final path = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (var i = 1; i < pts.length; i++) {
      final mid = (pts[i - 1].dx + pts[i].dx) / 2;
      path.cubicTo(mid, pts[i - 1].dy, mid, pts[i].dy, pts[i].dx, pts[i].dy);
    }
    final area = Path.from(path)
      ..lineTo(pts.last.dx, topPad + h)
      ..lineTo(pts.first.dx, topPad + h)
      ..close();
    canvas.drawPath(area, Paint()..color = fill.withValues(alpha: 0.7));
    canvas.drawPath(
        path,
        Paint()
          ..color = line
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeJoin = StrokeJoin.round);
    if (pts.length <= 31) {
      for (final p in pts) {
        canvas.drawCircle(p, 4.5, Paint()..color = line);
      }
    }
    // x labels: first, middle, last (never crowded)
    final idx = {0, points.length ~/ 2, points.length - 1}.toList()..sort();
    for (final i in idx) {
      _text(canvas, points[i].label, Offset(pts[i].dx, topPad + h + 4), center: true);
    }
  }

  @override
  bool shouldRepaint(_Painter old) => old.points != points || old.line != line;
}
