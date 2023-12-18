import 'dart:math';

import 'package:flutter/material.dart';
import 'package:the_radar_chart/the_radar_chart.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Radar Chart Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  bool darkMode = false;
  bool useSides = false;
  double numberOfFeatures = 4;

  final _controller = RadarChartController();

  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    final ticks = [
      TickData(value: 0, showLabel: true),
      TickData(value: 250, showLabel: false),
      TickData(value: 500, showLabel: true),
      TickData(value: 750, showLabel: false),
      TickData(value: 1000, showLabel: true)
    ];
    var features = [
      "AAAA AAAAAAAA AAAAAAA",
      "BBBBBB BBBBBB BBBBBB",
      "CCCCCC CCCCCCCCCCCCCCCCCC CCCCCC",
      "DDDDDD DDDDDD DDDDDD ",
      "EEEEE EEEEE EEEEEEE",
      "FFFFFF FFFFFF FFFFFF",
      "GGGGGG GGGGGG GGGGGGGGG",
      "HHHH HHHHHHHH HHHHHHH ",
      "IIIIII IIIIII IIIIII ",
      "JJJJJJJ JJJJJJJ JJJJJJJ ",
      "KKKKKKKK KKKKKKKK KKKKKKKK ",
      "LLLLLLL LLLLLLL LLLLLLL ",
      "AAAA AAAAAAAA AAAAAAA",
      "BBBBBB BBBBBBBBBBBB BBBBBB",
      "CCCCCC CCCCCCCCCCCCCCCCCC CCCCCC",
      "DDDDDD DDDDDD DDDDDD ",
      "EEEEE EEEEE EEEEEEE",
      "FFFFFF FFFFFF FFFFFF",
      "GGGGGG GGGGGG GGGGGGGGG",
      "HHHH HHHHHHHH HHHHHHH ",
      "IIIIII IIIIII IIIIII ",
      "JJJJJJJ JJJJJJJ JJJJJJJ ",
      "KKKKKKKK KKKKKKKK KKKKKKKK ",
      "LLLLLLL LLLLLLL LLLLLLL ",
    ];

    var data = [
      RadarDataSet(
        borderColor: Colors.orange,
        fillColor: Colors.orange.withOpacity(0.3),
        borderWidth: 3,
        dataEntries: [
          1000,
          1000,
          0,
          0,
        ],
      ),
      RadarDataSet(
        borderColor: Colors.red,
        fillColor: Colors.red.withOpacity(0.3),
        borderWidth: 1,
        dataEntries: [
          750,
          750,
          0,
          0,
        ],
      ),
    ];
    features = features.sublist(0, numberOfFeatures.floor());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Radar Chart Example'),
      ),
      body: Container(
        color: darkMode ? Colors.black : Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  darkMode
                      ? const Text(
                          'Light mode',
                          style: TextStyle(color: Colors.white),
                        )
                      : const Text(
                          'Dark mode',
                          style: TextStyle(color: Colors.black),
                        ),
                  Switch(
                    value: darkMode,
                    onChanged: (value) {
                      setState(() {
                        darkMode = value;
                      });
                    },
                  ),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          var didRotate =
                              _controller.rotateToFeature(currentStep + 1);
                          if (didRotate) currentStep++;
                        });
                      },
                      child: const Text('Rotate'))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  useSides
                      ? Text(
                          'Polygon border',
                          style: darkMode
                              ? const TextStyle(color: Colors.white)
                              : const TextStyle(color: Colors.black),
                        )
                      : Text(
                          'Circular border',
                          style: darkMode
                              ? const TextStyle(color: Colors.white)
                              : const TextStyle(color: Colors.black),
                        ),
                  Switch(
                    value: useSides,
                    onChanged: (value) {
                      setState(() {
                        useSides = value;
                      });
                    },
                  ),
                  // TextButton(onPressed: onPressed, child: child)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'Number of features',
                    style: TextStyle(
                        color: darkMode ? Colors.white : Colors.black),
                  ),
                  Expanded(
                    child: Slider(
                      value: numberOfFeatures,
                      min: 3,
                      max: 20,
                      divisions: 20 - 3,
                      onChanged: (value) {
                        setState(() {
                          numberOfFeatures = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: darkMode
                  ? RadarChart.dark(
                      ticks: ticks,
                      features: features,
                      data: data,
                      shape: RadarChartShape.circular,
                      getTitle: (index, angle) {
                        return RadarChartTitle(
                            text: features[index], angle: angle);
                      },
                    )
                  : RadarChart(
                      controller: _controller,
                      ticks: ticks,
                      features: features,
                      data: data,
                      reverseAxis: false,
                      rotationAngle: 0,
                      outlineColor: Colors.grey,
                      // sides: 10,
                      shape: RadarChartShape.polygon,
                      ticksTextStyle:
                          const TextStyle(color: Colors.black, fontSize: 14),
                      getTitle: (index, angle) {
                        return RadarChartTitle(
                            text: features[index], angle: angle);
                      }),
            ),
          ],
        ),
      ),
    );
  }
}
