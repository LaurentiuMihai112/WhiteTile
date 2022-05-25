import 'dart:html';
import 'dart:math';

import 'package:flutter/material.dart';

class HighScoresPage extends StatelessWidget {
  const HighScoresPage({Key? key, required this.title}) : super(key: key);
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
            crossAxisAlignment: WrapCrossAlignment.center,
            children: _getScores(),
          ),
        )));
  }

  _getScores() {
    var message;
    if (window.localStorage.containsKey('scores')) {
      message = window.localStorage['scores'];
      message = message.substring(0, message.length - 1);
      var scoresString = message.split(",");
      var scores = [];
      for (var i in scoresString) {
        scores.add(int.parse(i));
      }
      scores.sort((b, a) => a.compareTo(b));
      List<Widget> list = [];
      list.add(const Text('HighScores', textAlign: TextAlign.center));
      for (var i in scores) {
        list.add(Text(i.toString(), textAlign: TextAlign.center));
      }
      return list;
    } else {
      var message = '';
      var random = Random();
      for (var i = 0; i < 10; i++) {
        var x = random.nextInt(300) + 100;
        message += x.toString() + ',';
      }
      window.localStorage['scores'] = message;
    }
  }
}
