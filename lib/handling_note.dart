import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:notes_clone/class/Note.dart';
import 'package:notes_clone/class/database.dart';
import 'package:notes_clone/main.dart';
import 'package:notes_clone/screen/dart/archive_notes.dart';
import 'package:provider/provider.dart';

class HandleNote extends StatefulWidget {
  static const routeName = '/addNote';

  HandleNote({@required this.currNote});

  final Note currNote;

  @override
  _HandleNoteState createState() => _HandleNoteState();
}

class _HandleNoteState extends State<HandleNote> {
  NoteProvider noteProvider;
  TextEditingController _title = TextEditingController();
  TextEditingController _note = TextEditingController();
  String _dateObject;
  FocusNode _titleNode = FocusNode();
  FocusNode _notesNode = FocusNode();
  var db = NotesDBHandler();
  Note _currNote;

  void _changeFocus() {
    FocusScope.of(context).requestFocus(_notesNode);
  }

  void createProvider(BuildContext context) {
    noteProvider = Provider.of<NoteProvider>(context);
  }

  @override
  void initState() {
    super.initState();
    _currNote = widget.currNote;
    if (_currNote.id != -1) {
      _title.text = _currNote.title;
      _note.text = _currNote.note;
      _dateObject = DateFormat.yMMMd().format(_currNote.dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    createProvider(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () async {
          _currNote.id == -1 ? await _createNote() : await _editNote();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return _currNote.archived == 0
                ? Home()
                : ArchivedNotes(
                    noteProvider: noteProvider,
                  );
          }));
        },
      ),
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            noteProvider.notify();
            Navigator.of(context).pop();
          },
          color: Colors.indigo,
        ),
        leadingWidth: 45,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () async {
                    _currNote.archived == 0
                        ? await _archiveNote()
                        : await _unarchiveNote();
                  },
                  child: Icon(
                    Icons.archive_outlined,
                    color:
                        _currNote.archived == 1 ? Colors.indigo : Colors.grey,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await _deleteNote(context);
                    noteProvider.notify();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return _currNote.archived == 0
                          ? Home()
                          : ArchivedNotes(
                              noteProvider: noteProvider,
                            );
                    }));
                  },
                  child: Icon(Icons.delete),
                ),
              ],
            ),
          ),
        ],
        backgroundColor: Colors.white24,
        elevation: 0,
      ),
      bottomSheet: Row(
        children: [
          TextButton(
            onPressed: null,
            child: Icon(Icons.edit_road_rounded),
          ),
          _dateObject != null
              ? Row(
                  children: [
                    Text(
                      "Last edited : ",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      "$_dateObject",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                )
              : Text(" ")
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),
          color: Colors.white24,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                textAlign: TextAlign.justify,
                controller: _title,
                decoration: InputDecoration(
                  hintText: "Title",
                  hintStyle: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                maxLines: null,
                autocorrect: true,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                textInputAction: TextInputAction.next,
                focusNode: _titleNode,
                onEditingComplete: _changeFocus,
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                textAlign: TextAlign.justify,
                controller: _note,
                focusNode: _notesNode,
                decoration: InputDecoration(
                    hintText: "Write a Note Here!",
                    hintStyle: TextStyle(fontSize: 18)),
                maxLines: 25,
                style: TextStyle(fontSize: 18),
                //   onEditingComplete: _createNote,
                textInputAction: TextInputAction.done,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createNote() async {
    DateTime now = DateTime.now();
    await noteProvider.createNote(
      Note(
        title: _title.text,
        note: _note.text,
        dateTime: now,
        archived: _currNote.archived,
      ),
    );
  }

  Future<void> _editNote() async {
    DateTime now = DateTime.now();
    await noteProvider.editNote(
      Note(
        id: _currNote.id,
        title: _title.text,
        note: _note.text,
        archived: _currNote.archived,
        dateTime: now,
      ),
    );
  }

  Future<void> _deleteNote(BuildContext context) async {
    await noteProvider.deleteNote(_currNote);
  }

  Future<void> _archiveNote() async {
    setState(() {
      _currNote.archived = 1;
    });
    await noteProvider.archiveNote(_currNote);
  }

  Future<void> _unarchiveNote() async {
    setState(() {
      _currNote.archived = 0;
    });
    await noteProvider.unarchiveNote(_currNote);
  }
}
