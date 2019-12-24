// MIT License

// Copyright (c) 2020 Dominic Ayre

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'package:flutter/widgets.dart';

class HourBackgroundPainter extends CustomPainter {
  const HourBackgroundPainter({
    Key key,
    @required this.color,
    @required this.radius,
  });

  final Color color;
  final double radius;

  @override
  bool shouldRepaint(HourBackgroundPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint circlePaint = new Paint()..color = color;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      radius,
      circlePaint,
    );
  }
}

class HourBackground extends StatelessWidget {
  const HourBackground({
    Key key,
    @required this.color,
    @required this.radius,
  });

  final Color color;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: HourBackgroundPainter(
        color: color,
        radius: radius,
      ),
    );
  }
}
