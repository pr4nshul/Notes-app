import 'package:flutter/material.dart';
import 'package:notes_clone/class/Note.dart';
import 'package:notes_clone/widgets/drawer.dart';
import 'package:notes_clone/widgets/grid_widget.dart';
import 'package:notes_clone/widgets/list_widget.dart';

class ArchivedNotes extends StatefulWidget {
  final NoteProvider noteProvider;

  const ArchivedNotes({this.noteProvider});

  @override
  _ArchivedNotesState createState() => _ArchivedNotesState();
}

class _ArchivedNotesState extends State<ArchivedNotes> {
  bool _isLoading = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      await widget.noteProvider.getAllArchivedNotes();
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(
        noteProvider: widget.noteProvider,
      ),
      appBar: AppBar(
        title: Text(
          "Archived Notes",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : widget.noteProvider.view == shape.isGrid
              ? GridWidget(
                  noteType: typeNotes.archived,
                  notes: widget.noteProvider.archivedNotes)
              : ListWidget(
                  noteType: typeNotes.archived,
                  notes: widget.noteProvider.archivedNotes),
    );
  }
}
