import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'line.dart';
import 'line_divider.dart';
import 'note.dart';
import 'song_creator.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage>
    with SingleTickerProviderStateMixin {
  AudioPlayer player = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  List<Note> notes = initNotes();
  late AnimationController animationController;
  int currentNoteIndex = 0;
  int points = 0;
  bool hasStarted = false;
  bool isPlaying = true;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed && isPlaying) {
        if (notes[currentNoteIndex].state != NoteState.pressed) {
          //game over
          setState(() {
            isPlaying = false;
            notes[currentNoteIndex].state = NoteState.missed;
          });
          animationController.reverse().then((_) => _showFinishDialog());
        } else if (currentNoteIndex == notes.length - 5) {
          //song finished
          _showFinishDialog();
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
              LineDivider(),
              _drawLine(1),
              LineDivider(),
              _drawLine(2),
              LineDivider(),
              _drawLine(3),
            ],
          ),
          _drawPoints(),
        ],
      ),
    );
  }

  void _restart() {
    setState(() {
      hasStarted = false;
      isPlaying = true;
      notes = initNotes();
      points = 0;
      currentNoteIndex = 0;
    });
    animationController.reset();
  }

  void _showFinishDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Score: $points"),
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
            ])
          ],
        );
      },
    ).then((_) => _restart());
  }

  void _onTap(Note note) {
    animationController.duration =
        Duration(milliseconds: max(150, 450 - currentNoteIndex));
    bool areAllPreviousTapped = notes
        .sublist(0, note.orderNumber)
        .every((n) => n.state == NoteState.pressed);
    print(areAllPreviousTapped);
    if (areAllPreviousTapped) {
      if (!hasStarted) {
        setState(() => hasStarted = true);
        animationController.forward();
      }
      _playNote(note);
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
        onTileTap: _onTap,
        animation: animationController,
      ),
    );
  }

  _drawPoints() {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: Text(
          "$points",
          style: TextStyle(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 60),
        ),
      ),
    );
  }

  _playNote(Note note) {
    switch (note.line) {
      case 0:
        player.play('assets/note1.wav', isLocal: true);
        return;
      case 1:
        player.play('assets/note2.wav', isLocal: true);
        return;
      case 2:
        player.play('assets/note3.wav', isLocal: true);
        return;
      case 3:
        player.play('assets/note4.wav', isLocal: true);
        return;
    }
  }
}
