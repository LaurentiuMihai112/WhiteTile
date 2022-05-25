import 'dart:html';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'line.dart';
import 'note.dart';

const notesNumber = 10000;

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage>
    with SingleTickerProviderStateMixin {
  final AudioCache _audioCache = AudioCache();
  late List<Note> notes;

  late AnimationController animationController;
  int currentNoteIndex = 0;
  int points = 0;
  bool hasStarted = false;
  bool isPlaying = true;

  @override
  void initState() {
    super.initState();
    // _setAssets();
    notes = _createSong();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed && isPlaying) {
        if (notes[currentNoteIndex].state != NoteState.pressed) {
          //game over
          setState(() {
            isPlaying = false;
            notes[currentNoteIndex].state = NoteState.missed;
          });
          animationController.reverse().then((_) {
            _saveScore();
            _showEndScreen();
          });
        } else if (currentNoteIndex == notes.length - 5) {
          //song finished
          _saveScore();
          _showEndScreen();
        } else {
          setState(() => ++currentNoteIndex);
          animationController.forward(from: 0);
        }
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          Image.asset(
            'assets/background-image.jpg',
            fit: BoxFit.cover,
          ),
          Row(
            children: <Widget>[
              _drawLine(0),
              Container(height: double.infinity, width: 1, color: Colors.white),
              _drawLine(1),
              Container(height: double.infinity, width: 1, color: Colors.white),
              _drawLine(2),
              Container(height: double.infinity, width: 1, color: Colors.white),
              _drawLine(3),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: Text(
                "$points",
                style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 60),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _restart() {
    setState(() {
      hasStarted = false;
      isPlaying = true;
      notes = _createSong();
      points = 0;
      currentNoteIndex = 0;
    });
    animationController.reset();
  }

  void _saveScore() {
    var message;
    if (window.localStorage.containsKey('scores')) {
      message = window.localStorage['scores'];
      message += points.toString();
      var scoresString = message.split(",");
      var scores = [];
      for (var i in scoresString) {
        scores.add(int.parse(i));
      }
      scores.sort((b, a) => a.compareTo(b));
      var firstTen = scores.take(10);
      var leaderboard = '';
      for (var i in firstTen) {
        leaderboard += i.toString() + ',';
      }
      window.localStorage['scores'] = leaderboard;
    } else {
      window.localStorage['scores'] = points.toString() + ',';
    }
  }

  _createSong() {
    List<Note> notes = [];
    var random = Random();
    for (var i = 0; i < notesNumber; i++) {
      notes.add(Note(i, random.nextInt(4)));
    }
    notes.add(Note(notesNumber, -1));
    notes.add(Note(notesNumber + 1, -1));
    notes.add(Note(notesNumber + 2, -1));
    notes.add(Note(notesNumber + 3, -1));
    return notes;
  }

  void _showEndScreen() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Score: " + points.toString()),
          actions: <Widget>[
            Column(children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Play again"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.popUntil(
                      context, (Route<dynamic> predicate) => predicate.isFirst);
                },
                child: const Text("Main menu"),
              ),
              TextButton(
                onPressed: () {
                  _share();
                },
                child: const Text("Share on Facebook"),
              ),
            ])
          ],
        );
      },
    ).then((_) => _restart());
  }

  void _tilePressed(Note note) {
    animationController.duration =
        Duration(milliseconds: max(150, 450 - currentNoteIndex));
    bool allPressed = notes
        .sublist(0, note.orderNumber)
        .every((n) => n.state == NoteState.pressed);
    if (allPressed) {
      if (!hasStarted) {
        setState(() => hasStarted = true);
        animationController.forward();
      }
      _playSound(note);
      setState(() {
        note.state = NoteState.pressed;
        ++points;
      });
    }
  }

  _drawLine(int lineNumber) {
    return Expanded(
      child: Line(
        lineNumber: lineNumber,
        currentNotes: notes.sublist(currentNoteIndex, currentNoteIndex + 5),
        onTileTap: _tilePressed,
        animation: animationController,
      ),
    );
  }

  _share() async {
    var message =
        "Come play with me. I got a score of " + points.toString() + " points";
    var appUrl =
        'https://lh3.googleusercontent.com/3NO2xuo4f4diYXyUvj8l2OGtzGgYiYvyCED42lnydqzU3Ni-X6NUasvDgxqKmjySK08=h900';
    var shareUrl = 'https://www.facebook.com/sharer/sharer.php?u=' +
        appUrl +
        '&quote=' +
        message;
    await launchUrl(Uri.parse(shareUrl));
  }

  _playSound(Note note) {
    switch (note.line) {
      case 0:
        // Source source=Source()
        _audioCache.play('note1.mp3');
        return;
      case 1:
        _audioCache.play('note2.mp3');
        return;
      case 2:
        _audioCache.play('note3.mp3');
        return;
      case 3:
        _audioCache.play('note4.mp3');
        return;
    }
  }
}
