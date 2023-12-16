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
      [
        1000,
        1000,
        0,
        400,
        200,
        500,
        200,
        300,
        400,
        200,
        200,
        500,
        100,
        200,
        300,
        400,
        200,
        500,
        200,
        300,
        400,
        200,
        200,
        500,
      ],
      [
        750,
        750,
        0,
        500,
        100,
        200,
        300,
        400,
        200,
        200,
        300,
        400,
        200,
        500,
        200,
        500,
        100,
        200,
        300,
        400,
        200,
        200,
        300,
        400,
      ],
    ];

    features = features.sublist(0, numberOfFeatures.floor());
    data = data
        .map((graph) => graph.sublist(0, numberOfFeatures.floor()))
        .toList();

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
                      reverseAxis: true,
                      useSides: useSides,
                    )
                  : RadarChart.light(
                      ticks: ticks,
                      features: features,
                      data: data,
                      reverseAxis: false,
                      useSides: useSides,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
