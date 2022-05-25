import 'dart:math';

import 'note.dart';

const notesNumber = 10000;

List<Note> initNotes() {
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
