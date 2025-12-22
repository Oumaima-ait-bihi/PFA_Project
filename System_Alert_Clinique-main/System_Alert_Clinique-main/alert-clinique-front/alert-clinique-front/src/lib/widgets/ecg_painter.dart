import 'package:flutter/material.dart';

class ECGPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.shade800
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(10, size.height / 2);
    path.lineTo(20, size.height / 4);
    path.lineTo(30, size.height / 2);
    path.lineTo(40, size.height / 5);
    path.lineTo(50, size.height / 2);
    path.lineTo(60, size.height * 0.4);
    path.lineTo(70, size.height * 0.6);
    path.lineTo(80, size.height / 2);
    path.lineTo(90, size.height * 0.6);

    canvas.drawPath(path, paint);

    // Stethoscope earpieces on peaks
    final earpiecePaint = Paint()
      ..color = Colors.green.shade600
      ..style = PaintingStyle.fill;
    
    final earpieceBorder = Paint()
      ..color = Colors.green.shade800
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Earpieces aligned with ECG peaks
    canvas.drawCircle(Offset(20, size.height / 4), 6, earpiecePaint);
    canvas.drawCircle(Offset(20, size.height / 4), 6, earpieceBorder);
    
    canvas.drawCircle(Offset(40, size.height / 5), 6, earpiecePaint);
    canvas.drawCircle(Offset(40, size.height / 5), 6, earpieceBorder);

    // Tubing connecting to chest piece
    final tubingPaint = Paint()
      ..color = Colors.green.shade600
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final tubingPath = Path();
    tubingPath.moveTo(20, size.height / 4);
    tubingPath.quadraticBezierTo(30, size.height * 0.7, 50, size.height * 0.9);
    tubingPath.moveTo(40, size.height / 5);
    tubingPath.quadraticBezierTo(30, size.height * 0.7, 50, size.height * 0.9);
    
    canvas.drawPath(tubingPath, tubingPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

