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
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  void initState() {
    super.initState();

    /// note fetch
    getNotes();
  }

  getNotes() async {
    dbHelper = DbHelper.getInstance();
    mNotes = await dbHelper!.fetchAllNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: mNotes.isNotEmpty
          ? ListView.builder(
              itemCount: mNotes.length,
              itemBuilder: (context, index) {
                var currNote = mNotes[index];

                return Container(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: Text("${index+1}"),
                    title: Text(currNote[DbHelper.col_note_title]),
                    subtitle: Text(currNote[DbHelper.col_note_desc]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () async {
                            bool isUpdated = await dbHelper!.updateNote(
                              updTitle: "Updated Note",
                              updDesc: "Updated Desc",
                              id: currNote[DbHelper.col_note_id],
                            );

                            if (isUpdated) {
                              getNotes();
                            }
                          },
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () async {
                            bool isDeleted = await dbHelper!.deleteNote(
                              id: currNote[DbHelper.col_note_id],
                            );
                            if (isDeleted) {
                              getNotes();
                            }
                          },
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  /*Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(mNotes[index]["note_title"], style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),),
                  Text(mNotes[index]["note_desc"],
                    style: TextStyle(fontSize: 14,),)
                ],
              ),*/
                );
              },
            )
          : Center(child: Text("No Notes yet!!")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          titleController.clear();
          descController.text = "";

          showModalBottomSheet(
            ///enableDrag: false,
            ///isDismissible: false,
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(21),
            ),
            builder: (c) {
              return Container(
                padding: EdgeInsets.all(11),
                width: double.infinity,
                height: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(21),
                ),
                child: Column(
                  children: [
                    Text(
                      "Add Note",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 11),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: "Enter you title here..",
                        labelText: "Title",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(21),
                        ),
                      ),
                    ),
                    SizedBox(height: 11),
                    TextField(
                      controller: descController,
                      maxLines: 4,
                      minLines: 4,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        hintText: "Enter you desc here..",
                        labelText: "Desc",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(21),
                        ),
                      ),
                    ),
                    SizedBox(height: 11),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () async {
                            bool isAdded = await dbHelper!.addNote(
                              title: titleController.text,
                              desc: descController.text,
                            );

                            if (isAdded) {
                              Navigator.pop(context);
                              getNotes();
                            }
                          },
                          child: Text("Save"),
                        ),
                        SizedBox(width: 11),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Cancel"),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
