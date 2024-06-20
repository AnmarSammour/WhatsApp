import 'package:flutter/material.dart';

class ChatBubblePainter extends CustomPainter {
  final bool isFromFriend;

  ChatBubblePainter({required this.isFromFriend});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = isFromFriend ? Color(0xFFFCFEFB) : Color(0xFFE9F8DF)
      ..style = PaintingStyle.fill;

    var path = Path();
    if (isFromFriend) {
      path
        ..moveTo(size.width, 10)
        ..lineTo(size.width, size.height - 10)
        ..arcToPoint(
          Offset(size.width - 10, size.height),
          radius: Radius.circular(10),
          clockwise: true,
        )
        ..lineTo(10, size.height)
        ..arcToPoint(
          Offset(0, size.height - 10),
          radius: Radius.circular(10),
          clockwise: true,
        )
        ..lineTo(0, 20)
        ..lineTo(-10, 0)
        ..lineTo(0, 0)
        ..arcToPoint(
          Offset(0, 0),
          radius: Radius.circular(10),
          clockwise: true,
        )
        ..lineTo(size.width - 10, 0)
        ..arcToPoint(
          Offset(size.width, 10),
          radius: Radius.circular(10),
          clockwise: true,
        )
        ..close();
    } else {
      path
        ..moveTo(0, 10)
        ..lineTo(0, size.height - 10)
        ..arcToPoint(
          Offset(10, size.height),
          radius: Radius.circular(10),
          clockwise: false,
        )
        ..lineTo(size.width - 10, size.height)
        ..arcToPoint(
          Offset(size.width, size.height - 10),
          radius: Radius.circular(10),
          clockwise: false,
        )
        ..lineTo(size.width, 20)
        ..lineTo(size.width + 10, 0)
        ..lineTo(size.width, 0)
        ..arcToPoint(
          Offset(size.width, 0),
          radius: Radius.circular(10),
          clockwise: false,
        )
        ..lineTo(10, 0)
        ..arcToPoint(
          Offset(0, 10),
          radius: Radius.circular(10),
          clockwise: false,
        )
        ..close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
