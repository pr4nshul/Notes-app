import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:notes_clone/class/database.dart';

class Note {
  Note({
    this.id,
    @required this.title,
    @required this.note,
    @required this.dateTime,
    this.archived = 0,
  });

  int id;
  String title;
  String note;
  DateTime dateTime;
  int archived;

  Map<String, dynamic> toMap(bool ifUpdate) {
    var data = {
      'title': utf8.encode(title),
      'content': utf8.encode(note),
      "dateTime": epochFromDate(dateTime),
      "is_archived": archived,
    };
    if (ifUpdate) {
      data['id'] = this.id;
    }
    return data;
  }

  int epochFromDate(DateTime dt) {
    return dt.millisecondsSinceEpoch ~/ 1000;
  }



}
enum shape { isGrid, isList }
enum typeNotes { all, archived }
class NoteProvider with ChangeNotifier {
  List<Map<String, dynamic>> _allNotes = [];
  List<Map<String, dynamic>> _allArchivedNotes = [];
  var db = NotesDBHandler();

  shape view = shape.isList;
  void gridView() {
    view = shape.isGrid;
    notifyListeners();
  }
  void listView(){
    view= shape.isList;
    notifyListeners();
  }

  List<Map<String, dynamic>> get allNotes {
    return _allNotes;
  }

  List<Map<String, dynamic>> get archivedNotes {
    return _allArchivedNotes;
  }

  Future<void> getAllNotes() async {
    // queries for all the notes from the database ordered by latest edited note. excludes archived notes.

    this._allNotes = await db.selectAllNotes();
    print("all notes: $_allNotes");
  }

  Future<void> getAllArchivedNotes() async {
    // queries for all the notes from the database ordered by latest edited note. excludes archived notes.
    var _testData = db.selectAllArchivedNotes();
    _testData.then((value) {
      this._allArchivedNotes = value;
      print("archived:$_allArchivedNotes");
    });
  }

  Future<void> createNote(Note _currNote) async {
    await db.insertNote(
      _currNote,
      true,
    );
    notifyListeners();
  }

  Future<void> editNote(Note _currNote) async {
    await db.insertNote(
      _currNote,
      false,
    );
    notifyListeners();
  }

  Future<void> deleteNote(Note _currNote) async {
    await db.deleteNote(_currNote);
    await getAllNotes();
    await getAllArchivedNotes();
    notifyListeners();
  }

  Future<void> archiveNote(Note _currNote) async {

    await db.updateNote(_currNote);
    await getAllNotes();
    await getAllArchivedNotes();
    notifyListeners();
  }

  Future<void> unarchiveNote(Note _currNote) async {
    notifyListeners();
    await db.updateNote(_currNote);
    await getAllNotes();
    await getAllArchivedNotes();
    notifyListeners();
  }
  void notify(){
    notifyListeners();
  }
}
