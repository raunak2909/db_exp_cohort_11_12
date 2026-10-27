import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  ///1
  DbHelper._(); /// private constructor
  ///2
  static DbHelper getInstance() {
    return DbHelper._(); /// singleton
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
     return await openDatabase(dbPath, version: 1, onCreate: (db, version){
       ///tables creation
       db.execute("create table note ( note_id integer primary key autoincrement, note_title text, note_desc text, created_at text )");
     });

   }




   ///query
   ///insert, select(read), update, delete - note app
   /// insert
   void addNote({required String title, required String desc}) async {
     Database db = await initDB();

     db.insert("note", {
       "note_title": title,
       "note_desc": desc,
       "created_at" : DateTime.now().millisecondsSinceEpoch.toString()
     });

   }

   Future<List<Map<String, dynamic>>> fetchAllNotes() async {
     Database db = await initDB();

     return await db.query("note");
   }

}













/// Expense App UI - 6 UI
/// create a repo
/// push the code to github
/// share me the repo link via email