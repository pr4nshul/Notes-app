import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqlite_api.dart';
import 'dart:async';
import 'Note.dart';

class NotesDBHandler {
  final databaseName = "notes_clone.db";
  final tableName = "notes_clone";

  final fieldMap = {
    "id": "INTEGER PRIMARY KEY AUTOINCREMENT",
    "title": "BLOB",
    "content": "BLOB",
    "dateTime": "INTEGER",
    "is_archived": "INTEGER",
  };

  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  initDB() async {
    var path = await getDatabasesPath();
    var dbPath = join(path, databaseName);
    // ignore: argument_type_not_assignable
    Database dbConnection = await openDatabase(dbPath, version: 1,
        onCreate: (Database db, int version) async {
     // print("executing create query from onCreate callback");
      await db.execute(_buildCreateQuery());
    });

    await dbConnection.execute(_buildCreateQuery());
    // _buildCreateQuery();
    return dbConnection;
  }

// build the create query dynamically using the column:field dictionary.
  String _buildCreateQuery() {
    String query = "CREATE TABLE IF NOT EXISTS ";
    query += tableName;
    query += "(";
    fieldMap.forEach((column, field) {
      // print("$column : $field");
      query += "$column $field,";
    });

    query = query.substring(0, query.length - 1);
    query += " )";

    return query;
  }

  static Future<String> dbPath() async {
    String path = await getDatabasesPath();
    return path;
  }

  Future<void> insertNote(Note note, bool isNew) async {
    // Get a reference to the database
    final Database db = await database;
   // print("insert called");

    // Insert the Notes into the correct table.
    await db.insert(
      tableName,
      isNew ? note.toMap(false) : note.toMap(true),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    // if (isNew) {
    //   //get latest note which isn't archived, limit by 1
    //   var one = await db.query(tableName, orderBy: "dateTime",
    //       where: "is_archived = ?",
    //       whereArgs: [0],
    //       limit: 1);
    //   print(one);
    //  // int latestId = one.first["id"] as int;
    //  //print(latestId);
    //   return;
    // }
    print("id:${note.id}");
    return;
  }

  Future<void> updateNote(Note note) async {
    if (note.id != -1) {
      final Database db = await database;

      int idToUpdate = note.id;

      db.update(tableName, note.toMap(true),
          where: "id = ?", whereArgs: [idToUpdate]);
    }
  }

  Future<bool> deleteNote(Note note) async {
    if (note.id != -1) {
      final Database db = await database;
      try {
        await db.delete(tableName, where: "id = ?", whereArgs: [note.id]);
        return true;
      } catch (Error) {
        print("Error deleting ${note.id}: ${Error.toString()}");
        return false;
      }
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> selectAllNotes() async {
    final Database db = await database;
    // query all the notes sorted by last edited
    var data = await db.query(tableName,
        orderBy: "dateTime", where: "is_archived = ?", whereArgs: [0]);
    //print(data);
    return data;
  }

  Future<List<Map<String, dynamic>>> selectAllArchivedNotes() async {
    final Database db = await database;
    // query all the notes sorted by last edited
    var data = await db.query(tableName,
        orderBy: "dateTime", where: "is_archived = ?", whereArgs: [1]);
    return data;
  }
}
