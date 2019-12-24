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

class AnimatedNumberText extends StatefulWidget {
  const AnimatedNumberText({
    Key key,
    @required this.number,
    this.style,
  }) : super(key: key);

  final int number;
  final TextStyle style;

  @override
  _AnimatedNumberTextState createState() => _AnimatedNumberTextState();
}

class _AnimatedNumberTextState extends State<AnimatedNumberText>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _rotation;
  int lastValue;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _rotation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    TextStyle effectiveTextStyle = widget.style;
    if (widget.style == null || widget.style.inherit)
      effectiveTextStyle = defaultTextStyle.style.merge(widget.style);

    if (lastValue != widget.number) {
      bool shouldAnimate = lastValue != null;
      lastValue = widget.number;

      if (shouldAnimate) {
        _controller.animateTo(1, curve: Curves.easeOutCubic)
          ..whenComplete(() {
            _controller.reset();
          });
      }
    }

    return RotationTransition(
      turns: _rotation,
      child: Text(
        lastValue.toString(),
        style: effectiveTextStyle,
      ),
    );
  }
}
