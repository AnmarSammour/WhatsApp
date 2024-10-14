import 'package:flutter/material.dart';

class StoryProgressPainter extends CustomPainter {
  final int total;
  final bool viewed;

  StoryProgressPainter({required this.total, this.viewed = false});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..color = viewed ? Colors.grey : const Color(0xFF02B099);

    const double startAngle = -90.0 * (3.14 / 180.0);
    final double sweepAngle = (360.0 / total) * (3.14 / 180.0);
    const double gapSize = 5.0 * (3.14 / 180.0);

    for (int i = 0; i < total; i++) {
      double start = startAngle + (sweepAngle + gapSize) * i;
      canvas.drawArc(
        Rect.fromLTWH(0.0, 0.0, size.width, size.height),
        start,
        sweepAngle - gapSize,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
