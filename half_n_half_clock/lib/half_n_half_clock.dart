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

import 'dart:async';
import 'dart:math';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:intl/intl.dart';

import 'animated_number_text.dart';
import "hour_background.dart";
import 'minute_background.dart';
import 'weather_card.dart';

import 'package:google_fonts/google_fonts.dart';

bool colorContrastsEnough(Color color) {
  // Return true if color will conform to WCAG 2.0 accessibility
  // guidelines for contrast with large white text
  return color.computeLuminance() < 1 / 3;
}

final defaultTheme = HalfNHalfClockTheme(
  hourTextStyle: GoogleFonts.roboto(
    fontWeight: FontWeight.w900,
  ).copyWith(color: Colors.white),
  weatherTextStyle: GoogleFonts.hind(
    fontWeight: FontWeight.w900,
  ),
  lightColors: Colors.primaries.where(colorContrastsEnough).toList(),
  darkColors: Colors.primaries
      .where(colorContrastsEnough)
      .map((color) => color[900])
      .toList(),
);

class HalfNHalfClockTheme {
  const HalfNHalfClockTheme({
    @required this.hourTextStyle,
    @required this.weatherTextStyle,
    @required this.lightColors,
    @required this.darkColors,
  });

  final TextStyle hourTextStyle;
  final TextStyle weatherTextStyle;
  final List<Color> lightColors;
  final List<Color> darkColors;
}

class HalfNHalfClock extends StatefulWidget {
  HalfNHalfClock(this.model) : this.theme = defaultTheme;

  final ClockModel model;
  final HalfNHalfClockTheme theme;

  @override
  _HalfNHalfClockState createState() => _HalfNHalfClockState();
}

class _HalfNHalfClockState extends State<HalfNHalfClock> {
  var _now = DateTime.now();
  var _temperature = '';
  var _temperatureMin = '';
  var _temperatureMax = '';
  var _condition;
  var _location = '';
  var _hourCircleRadius = 60.0;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    // Set the initial values.
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(HalfNHalfClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _temperature = widget.model.temperatureString;
      _temperatureMin = widget.model.lowString;
      _temperatureMax = widget.model.highString;
      _condition = widget.model.weatherCondition;
      _location = widget.model.location;
    });
  }

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      // Update once per second. Make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
        _updateTime,
      );
    });
  }

  int _getAdjustedHour(hour) {
    if (widget.model.is24HourFormat || hour <= 12) {
      return hour;
    } else {
      return (hour - 12);
    }
  }

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).copyWith(
            backgroundColor: Color(0xFFF5F5F5),
            primaryColor: widget
                .theme.lightColors[_now.hour % widget.theme.lightColors.length],
            accentColor: widget.theme
                .lightColors[(_now.hour - 1) % widget.theme.lightColors.length],
          )
        : Theme.of(context).copyWith(
            backgroundColor: Color(0xFF3C4043),
            primaryColor: widget
                .theme.darkColors[_now.hour % widget.theme.darkColors.length],
            accentColor: widget.theme
                .darkColors[(_now.hour - 1) % widget.theme.darkColors.length],
          );

    final time = DateFormat.Hms().format(DateTime.now());

    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'Half n Half clock with time $time',
        value: time,
      ),
      child: Container(
        color: customTheme.backgroundColor,
        child: Stack(
          children: [
            Center(
              child: FractionallySizedBox(
                heightFactor: 0.35,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double newRadius =
                          min(constraints.maxWidth, constraints.maxHeight) / 2;

                      if (newRadius != _hourCircleRadius) {
                        _hourCircleRadius = newRadius;
                      }
                      return HourBackground(
                        color: customTheme.accentColor,
                        radius: _hourCircleRadius,
                      );
                    },
                  ),
                ),
              ),
            ),
            Center(
              child: MinuteBackground(
                color: customTheme.primaryColor,
                hourCircleRadius: _hourCircleRadius,
                minutes: _now.minute,
                seconds: _now.second,
              ),
            ),
            Center(
              child: FractionallySizedBox(
                heightFactor: 0.2,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: AnimatedNumberText(
                    number: _getAdjustedHour(_now.hour),
                    style: widget.theme.hourTextStyle,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, 0.8),
              child: FractionallySizedBox(
                heightFactor: 0.16,
                child: WeatherCard(
                  weatherTextStyle: widget.theme.weatherTextStyle,
                  condition: _condition,
                  temperature: _temperature,
                  temperatureMin: _temperatureMin,
                  temperatureMax: _temperatureMax,
                  location: _location,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
