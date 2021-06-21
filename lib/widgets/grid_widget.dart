import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notes_clone/class/Note.dart';

import '../handling_note.dart';

class GridWidget extends StatefulWidget {
  GridWidget({@required this.noteType, @required this.notes});

  final typeNotes noteType;
  final List<Map<String, dynamic>> notes;

  @override
  _GridWidgetState createState() => _GridWidgetState();
}

class _GridWidgetState extends State<GridWidget> {
  List<Map<String, dynamic>> get _notes {
    return widget.notes;
  }

  final _random = Random();
  final List<Color> _colors = [
    Colors.purple[300],
    Colors.red[300],
    Colors.deepPurple[300],
    Colors.lime,
    Colors.orange[400],
    Colors.green[300],
    Colors.cyan[300],
    Colors.tealAccent,
    Colors.brown[300],
  ];

  @override
  Widget build(BuildContext context) {
    return _notes.isEmpty
        ? Center(
            child: widget.noteType == typeNotes.all
                ? Text(
                    "No notes found here, Click on +",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )
                : Text(
                    "No Notes Archived",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
          )
        : GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemBuilder: (BuildContext ctx, index) {
              return GestureDetector(
                child: Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: _colors[_random.nextInt(_colors.length)],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(6),
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.black54,
                          ),
                          child: Text(
                            utf8.decode(
                                _notes[_notes.length - index - 1]['title']),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white60,
                        ),
                        child: Text(
                          utf8.decode(
                              _notes[_notes.length - index - 1]['content']),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return HandleNote(
                    currNote: Note(
                      id: _notes[_notes.length - index - 1]['id'],
                      note: utf8
                          .decode(_notes[_notes.length - index - 1]['content']),
                      dateTime: DateTime.fromMillisecondsSinceEpoch(
                          _notes[_notes.length - index - 1]['dateTime'] * 1000),
                      title: utf8
                          .decode(_notes[_notes.length - index - 1]['title']),
                      archived: _notes[_notes.length - index - 1]
                          ['is_archived'],
                    ),
                  );
                })),
              );
            },
            itemCount: _notes.length,
          );
  }
}
