import 'package:flutter/material.dart';
import 'package:white_tile/game.dart';

import 'high_scores.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
            child: Container(
          margin: const EdgeInsets.all(30),
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            direction: Axis.vertical,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center ,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return GamePage();
                  }));
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.lightBlue,
                  onPrimary: Colors.white,
                  onSurface: Colors.grey,
                ),
                child: const Text('Play'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const HighScoresPage(title: "High Scores");
                  }));
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.lightBlue,
                  onPrimary: Colors.white,
                  onSurface: Colors.grey,
                ),
                child: const Text('High scores'),
              ),
              TextButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Colors.lightBlue,
                  onPrimary: Colors.white,
                  onSurface: Colors.grey,
                ),
                child: const Text('Quit'),
              ),
            ],
          ),
        )));
  }
}
