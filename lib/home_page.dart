import 'package:db_exp_cohort_11_12/db_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  DbHelper? dbHelper;
  List<Map<String, dynamic>> mNotes = [];

  @override
  void initState() {
    super.initState();
    /// note fetch
    getNotes();
  }

  getNotes() async {
    dbHelper = DbHelper.getInstance();
    mNotes = await dbHelper!.fetchAllNotes();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: mNotes.isNotEmpty ? ListView.builder(
        itemCount: mNotes.length,
          itemBuilder: (context, index){
        return Container(
          height: 50,
          margin: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(mNotes[index]["note_title"], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              Text(mNotes[index]["note_desc"], style: TextStyle(fontSize: 14,),)
            ],
          ),
        );
      }) : Center(
        child: Text("No Notes yet!!"),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        /// note add
        dbHelper!.addNote(title: "My Note", desc: "This is my first note");
        getNotes();
      }, child: Icon(Icons.add),),
    );
  }

}

