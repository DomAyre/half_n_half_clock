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

import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

final conditionIcons = {
  WeatherCondition.cloudy: Image.asset(
    "assets/cloudy_icon.png",
  ),
  WeatherCondition.foggy: Image.asset(
    "assets/foggy_icon.png",
  ),
  WeatherCondition.rainy: Image.asset(
    "assets/rainy_icon.png",
  ),
  WeatherCondition.snowy: Image.asset(
    "assets/snowy_icon.png",
  ),
  WeatherCondition.sunny: Image.asset(
    "assets/sunny_icon.png",
  ),
  WeatherCondition.thunderstorm: Image.asset(
    "assets/thunderstorm_icon.png",
  ),
  WeatherCondition.windy: Image.asset(
    "assets/windy_icon.png",
  ),
};

final leftLight = Image.asset("assets/left_bound_light.png", height: 10);
final rightLight = Image.asset("assets/right_bound_light.png", height: 10);
final leftDark = Image.asset("assets/left_bound_dark.png", height: 10);
final rightDark = Image.asset("assets/right_bound_dark.png", height: 10);

class WeatherCard extends StatelessWidget {
  const WeatherCard({
    Key key,
    @required this.weatherTextStyle,
    @required this.condition,
    @required this.location,
    @required this.temperature,
    @required this.temperatureMin,
    @required this.temperatureMax,
    this.padding = 5.0,
  }) : super(key: key);

  final TextStyle weatherTextStyle;
  final condition;
  final location;
  final temperature;
  final temperatureMin;
  final temperatureMax;
  final padding;

  @override
  Widget build(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: constraints.maxHeight * 0.25,
                  ),
                  Container(
                    height: constraints.maxHeight * 0.75,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: conditionIcons[condition],
                    ),
                  ),
                  Container(
                    width: constraints.maxHeight * 0.1,
                  ),
                  Container(
                    height: constraints.maxHeight * 0.75,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Text(
                              location,
                              style: weatherTextStyle,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Transform.scale(
                                  scale: 0.75,
                                  child: Text(
                                    temperatureMin,
                                    style: weatherTextStyle.copyWith(
                                        color: DefaultTextStyle.of(context)
                                            .style
                                            .color
                                            .withOpacity(0.5)),
                                  ),
                                ),
                                Transform.scale(
                                  scale: 0.9,
                                  child: isLightMode ? leftLight : leftDark,
                                ),
                                Text(
                                  temperature,
                                  style: weatherTextStyle,
                                ),
                                Transform.scale(
                                  scale: 0.9,
                                  child: isLightMode ? rightLight : rightDark,
                                ),
                                Transform.scale(
                                  scale: 0.75,
                                  child: Text(
                                    temperatureMax,
                                    style: weatherTextStyle.copyWith(
                                        color: DefaultTextStyle.of(context)
                                            .style
                                            .color
                                            .withOpacity(0.5)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: constraints.maxHeight * 0.3,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
