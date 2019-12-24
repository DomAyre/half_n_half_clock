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

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

/// Total distance traveled by a second or a minute hand, each second or minute,
/// respectively.
final radiansPerMinute = radians(360 / 60);
final radiansPerSecond = radians(360 / 60 / 60);
final startAngle = radians(-90);

class MinuteBackgroundPainter extends CustomPainter {
  const MinuteBackgroundPainter({
    Key key,
    @required this.color,
    @required this.radius,
    @required this.minutes,
    @required this.seconds,
    @required this.elevation,
  });

  final Color color;
  final double radius;
  final int minutes;
  final int seconds;
  final double elevation;

  @override
  bool shouldRepaint(MinuteBackgroundPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.radius != radius ||
        oldDelegate.minutes != minutes ||
        oldDelegate.seconds != seconds;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);

    Offset center = Offset(size.width / 2, size.height / 2);
    double sweepAngle = minutes * radiansPerMinute + seconds * radiansPerSecond;

    if (sweepAngle == 0) {
      return;
    }

    Rect arcRect = Rect.fromCircle(center: center, radius: radius);

    Path arcPath = Path();
    arcPath.lineTo(center.dx, size.height);
    arcPath.addArc(arcRect, startAngle, sweepAngle);
    arcPath.lineTo(center.dx, center.dy);

    Paint circlePaint = new Paint()..color = color;
    canvas.drawShadow(arcPath, Colors.black, elevation, false);
    canvas.drawArc(arcRect, startAngle, sweepAngle, true, circlePaint);
  }
}

class MinuteBackground extends StatefulWidget {
  const MinuteBackground({
    Key key,
    @required this.color,
    @required this.hourCircleRadius,
    @required this.minutes,
    @required this.seconds,
    this.elevation = 5,
  });

  final Color color;
  final double hourCircleRadius;
  final int minutes;
  final int seconds;
  final double elevation;

  @override
  _MinuteBackgroundState createState() => _MinuteBackgroundState();
}

class _MinuteBackgroundState extends State<MinuteBackground>
    with SingleTickerProviderStateMixin {
  AnimationController animation;
  Animation<double> radiusAnimation;
  double minRadius = 0;
  double maxRadius = 0;
  Tween<double> radius;

  Color color;
  int minutes;
  int seconds;

  @override
  void initState() {
    super.initState();

    animation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    setMaxRadius(0);
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  void setMaxRadius(double newMaxRadius) {
    maxRadius = newMaxRadius;
    onMinMaxRadiusChanged();
  }

  void setMinRadius(double newMinRadius) {
    minRadius = newMinRadius;
    onMinMaxRadiusChanged();
  }

  void onMinMaxRadiusChanged() {
    radiusAnimation =
        Tween<double>(begin: maxRadius, end: widget.hourCircleRadius)
            .animate(animation);
  }

  void updateStateFromWidget() {
    color = widget.color;
    minutes = widget.minutes;
    seconds = widget.seconds;
  }

  @override
  Widget build(BuildContext context) {
    if (minRadius != widget.hourCircleRadius) {
      setMinRadius(widget.hourCircleRadius);
    }

    if (widget.minutes == 0 && widget.seconds == 0) {
      animation.animateTo(1,
          curve: Curves.fastLinearToSlowEaseIn,
          duration: Duration(milliseconds: 500))
        ..whenComplete(() {
          animation.reset();
          updateStateFromWidget();
        });
    }

    if (!animation.isAnimating) updateStateFromWidget();

    return LayoutBuilder(
      builder: (context, constraints) {
        double currentMaxRadius =
            max(constraints.maxWidth, constraints.maxHeight);
        if (currentMaxRadius != maxRadius) {
          setMaxRadius(currentMaxRadius);
        }

        return AnimatedBuilder(
          animation: radiusAnimation,
          builder: (_, __) {
            return CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: MinuteBackgroundPainter(
                color: color,
                radius: radiusAnimation.value,
                minutes: minutes,
                seconds: seconds,
                elevation: animation.value == 0 ? widget.elevation : 0,
              ),
            );
          },
        );
      },
    );
  }
}
