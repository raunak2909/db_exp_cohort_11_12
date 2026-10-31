import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  String table_note = "note";
  static String col_note_id = "note_id";
  static String col_note_title = "note_title";
  static String col_note_desc = "note_desc";
  static String col_created_at = "created_at";

  ///1
  DbHelper._();

  /// private constructor
  ///2
  static DbHelper getInstance() {
    return DbHelper._();

    /// singleton
  }

  ///Database
  Database? mDB;

  ///open
  Future<Database> initDB() async {
    /*if(mDB==null){
       mDB = await openDB();
     }*/
    mDB ??= await openDB();
    return mDB!;
  }

  ///create
  Future<Database> openDB() async {
    /// data/data/com.example.db_exp_cohort_11_12/databases/notesDB.db
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, "notesDB.db");
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        ///tables creation
        db.execute(
          "create table $table_note ( $col_note_id integer primary key autoincrement, $col_note_title text, $col_note_desc text, $col_created_at text )",
        );
      },
    );
  }

  ///query
  ///insert, select(read), update, delete - note app
  /// insert
  Future<bool> addNote({required String title, required String desc}) async {
    Database db = await initDB();

    int rowsEffected = await db.insert(table_note, {
      col_note_title: title,
      col_note_desc: desc,
      col_created_at: DateTime.now().millisecondsSinceEpoch.toString(),
    });

    return rowsEffected > 0;
  }

  Future<List<Map<String, dynamic>>> fetchAllNotes() async {
    Database db = await initDB();

    return await db.query(table_note);
  }

  Future<bool> updateNote({
    required String updTitle,
    required String updDesc,
    required int id,
  }) async {
    var db = await initDB();
    int rowsEffected = await db.update(table_note, {
      col_note_title: updTitle,
      col_note_desc: updDesc,
    }, where: "$col_note_id = $id");

    /// where note_id = 3
    return rowsEffected > 0;
  }

  Future<bool> deleteNote({required int id}) async {
    var db = await initDB();

    int rowsEffected = await db.delete(
      table_note,
      where: "$col_note_id = ?",
      whereArgs: ["$id"],
    );

    return rowsEffected > 0;
  }
}

/// Expense App UI - 6 UI
/// create a repo
/// push the code to github
/// share me the repo link via email
