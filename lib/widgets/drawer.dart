import 'package:flutter/material.dart';
import 'package:notes_clone/class/Note.dart';
import 'package:notes_clone/main.dart';
import 'package:notes_clone/screen/dart/archive_notes.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  final NoteProvider noteProvider;

  const MyDrawer({this.noteProvider});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width*0.48,
        height: MediaQuery.of(context).size.height*0.8155,
        child: Drawer(
          elevation: 10,
          child: Container(
            color: Colors.blueAccent[100],
            child: ListView(
              children: [
                ListTile(
                  tileColor: Colors.black87,
                  leading: Icon(
                    Icons.sticky_note_2,
                    color: Colors.white70,
                    size: 28,
                  ),
                  title: Center(
                      child: Text(
                    "Welcome to your Notes!",
                    style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  )),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 18, 10, 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(70),
                    //   border: Border.all(color: Colors.white,width: 4),
                    color: Color(0xff191970),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.grid_view,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Grid View",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                    onTap: () {
                      noteProvider.gridView();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 8, 10, 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(70),
                    //    border: Border.all(color: Colors.white,width: 4),
                    color: Color(0xff191970),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.view_list,
                      color: Colors.white,
                    ),
                    title: Text(
                      "List View",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                    onTap: () {
                      noteProvider.listView();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                // Divider(
                //   thickness: 2,
                //   color: Colors.black,
                // ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 8, 10, 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(70),
                    //  border: Border.all(color: Colors.white,width: 4),
                    color:Color(0xff191970),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.home_outlined,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Home",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                    onTap: () => Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return Home();
                    })),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 8, 10, 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(70),
                    //  border: Border.all(color: Colors.white,width: 4),
                    color: Color(0xff191970),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.archive_outlined,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Archive",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                    onTap: () => Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return Consumer<NoteProvider>(builder: (context,noteProvider,__)=> ArchivedNotes(noteProvider:noteProvider),);
                    })),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
