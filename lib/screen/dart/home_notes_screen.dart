import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_clone/class/Note.dart';


import 'package:notes_clone/widgets/grid_widget.dart';
import 'package:notes_clone/widgets/list_widget.dart';

class HomeScreen extends StatefulWidget {
  final NoteProvider noteProvider;

  const HomeScreen({this.noteProvider});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      await widget.noteProvider.getAllNotes();
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            child: widget.noteProvider.view == shape.isGrid
                ? GridWidget(
                    noteType: typeNotes.all,
                    notes: widget.noteProvider.allNotes,
                  )
                : ListWidget(
                    noteType: typeNotes.all,
                    notes: widget.noteProvider.allNotes,
                  ),
          );
  }
}
