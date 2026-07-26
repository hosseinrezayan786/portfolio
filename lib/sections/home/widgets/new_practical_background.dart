// import 'package:flutter/material.dart';

// class NewPaint extends StatefulWidget {
//   const NewPaint({super.key});

//   @override
//   State<NewPaint> createState() => _NewPaintState();
// }

// class _NewPaintState extends State<NewPaint> {
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return CustomPaint(painter: NewPainter());
//       },
//     );
//   }
// }

// class NewPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()..color = Colors.blue;
//     canvas.drawArc(Rect.largest, 100, 100, true, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }
