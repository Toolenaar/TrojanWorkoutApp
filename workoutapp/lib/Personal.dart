import 'dart:async';
//import 'dart:html';
import 'dart:convert' show utf8;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
//import 'dart:html';
//import 'dart:html';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'dart:io' as io;
import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

final exercises = List<int>.generate(6, (i) => i);

Note theNote;
String notes = "";

//Main class
class Personal extends StatefulWidget {
  final exercises = List<int>.generate(6, (i) => i); // today's exercises data
  final requests;
  Personal(
    this.requests, {
    Key key,
  }) : super(key: key);

  @override
  _PersonalState createState() => _PersonalState();
}

class _PersonalState extends State<Personal> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (_) => PersonalHomePage(exercises, widget.requests),
        'days': (_) => FullProgramPage()
      },
    );
  }
}

//Home Page
class PersonalHomePage extends StatefulWidget {
  final exercises;
  final requests;
  const PersonalHomePage(
    this.exercises,
    this.requests, {
    Key key,
  }) : super(key: key);

  @override
  _PersonalHomePage createState() => _PersonalHomePage();
}

class _PersonalHomePage extends State<PersonalHomePage> {
  String content = '';
  fetchContentDescription() async {
    String responseText;
    responseText = await rootBundle.loadString('textDescriptions/day1.txt');

    setState(() {
      content = responseText;
    });
  }

  void initState() {
    fetchContentDescription();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var day = widget.requests["programDay"]["mental"];
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                child: const Text("Notes"),
                onPressed: () => Navigator.pushNamed(context, 'days')),
            ElevatedButton(onPressed: null, child: const Text("Full Program"))
          ],
        ),
        //titleSection,
        //get title
        Container(
    padding: const EdgeInsets.all(32),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Learn',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                'Learn Day1 title',
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.wb_sunny_rounded,
          color: Colors.red[500],
        ),
        Text(day),
      ],
    ),
  ),
        //get desctriptions.
        Row(children: [
          FutureBuilder<String>(
              future: getDescription("exercise1"),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Flexible(
                      child: Text(snapshot.data,
                          style: TextStyle(fontWeight: FontWeight.bold)));
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();
              }),
        ]),
        //divider used to avoid overlapping with navigation bar
        const Divider(
          height: 80,
          thickness: 5,
          indent: 20,
          endIndent: 20,
        ),
      ],
    ))));
  }


  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/config.json');
  }
}

//program page with each day
class FullProgramPage extends StatefulWidget {
  @override
  _FullProgramPage createState() => _FullProgramPage();
}

class _FullProgramPage extends State<FullProgramPage> {
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context)
        .size; //this gives us total height and width of our device
    return Padding(
        padding: EdgeInsets.only(top: 35, left: 10, right: 10),
        child: Scaffold(
            body: Container(
                height: 200,
                child: Column(children: <Widget>[
                  Container(
                    /* constraints:
                        BoxConstraints.expand(height: size.height * .05), */
                    color: Colors.grey,
                    child: Text('',
                        style: TextStyle(
                          //fontSize: 10.0,
                          fontWeight: FontWeight.normal,
                        )),
                  ),
                  NoteScreen(),
                  //TodoList(),
                  ElevatedButton(
                      child: const Text('Back'),
                      onPressed: () => Navigator.pushNamed(context, '/'))
                ]))));
  }
}

class ExerciseWidget extends StatelessWidget {
  final int exercises; // exercise data

  const ExerciseWidget(
    this.exercises, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _isEditingText = false;
    TextEditingController _editingController;
    String initialText = "Initial Text";
    return Container();
  }
}

class Note {
  int id;
  // String title;
  String content;
  DateTime timeCreated;
/*   DateTime lastEdited;
  Color colorNote;
  int archived = 0; */

  Note(
    this.id,
    this.content,
    this.timeCreated,
    /* this.lastEdited, */ /* this.colorNote, */
    /* this.archived */
  );

  Map<String, dynamic> toMap(bool forUpdate) {
    var data = {
//      'id': id,  since id is auto incremented in the database we don't need to send it to the insert query.
      //'title': utf8.encode(title),
      'content': utf8.encode(content),
      'timeCreated': epochFromDate(timeCreated),
/*       'lastEdited': epochFromDate(lastEdited),
      'colorNote': colorNote.value,
      'is_archived': archived */ //  for later use for integrating archiving
    };
    if (forUpdate) {
      data["id"] = this.id;
    }
    return data;
  }

  int epochFromDate(DateTime dt) {
    return dt.millisecondsSinceEpoch ~/ 1000;
  }

  void saveNote() {
    // archived = 1;
  }

  @override
  toString() {
    return {
      'id': id,
      // 'title': title,
      'content': content,
      'date_created': epochFromDate(timeCreated),
/*       'date_last_edited': epochFromDate(lastEdited),
      'note_color': colorNote.toString(),
      'is_archived': archived */
    }.toString();
  }
}

final String tableNotes = 'notes';
final String columnId = '_id';
final String columnContent = "content";
final String columnDateMade = "date_created";

class DatabaseHelper {
  static final _databaseName = "AllNotes.db";
  static final _databaseVersion = 1;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int verison) async {
    await db.execute('''
        CREATE TABLE $tableNotes (
          $columnId INTEGER PRIMARY KEY,
          $columnContent TEXT NOT NULL,
          $columnDateMade TEXT NOT NULL
        )
      ''');
  }

  Future<int> insert(Note note) async {
    Database db = await database;
    int id = await db.insert(tableNotes, note.toMap(false));
    return id;
  }

/*   Future<String> queryNote(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tableNotes,
        columns: [columnId, columnContent, columnDateMade],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Note
    }
  } */

  Future<bool> archiveNote(Note note) async {
    if (note.id != -1) {
      final Database db = await database;

      int idToUpdate = note.id;

      db.update("notes", note.toMap(true),
          where: "id = ?", whereArgs: [idToUpdate]);
    }
  }

  Future<bool> deleteNote(Note note) async {
    if (note.id != -1) {
      final Database db = await database;
      try {
        await db.delete("notes", where: "id = ?", whereArgs: [note.id]);
        return true;
      } catch (Error) {
        print("Error deleting ${note.id}: ${Error.toString()}");
        return false;
      }
    }
  }
}

class NotePage extends StatefulWidget {
  //final noteView;

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  var notesDB = DatabaseHelper._privateConstructor();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Consumer<NoteProvider>(
          builder: (context, NoteProvider data, child) {
            return data.getNotes.length != 0
                ? ListView.builder(
                    itemCount: data.getNotes.length,
                    itemBuilder: (context, index) {
                      return CardList(data.getNotes[index], index);
                    },
                  )
                : GestureDetector(
                    onTap: () {
                      showAlertDialog(context);
                    },
                    child: Center(
                        child: Text(
                      "ADD SOME NOTES NOW",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAlertDialog(context);
        },
        backgroundColor: Colors.white,
        child: Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}

showAlertDialog(BuildContext context) {
  TextEditingController _contentControl = TextEditingController();

  Widget okButton = TextButton(
    child: Text("Add note"),
    onPressed: () {
      Provider.of<NoteProvider>(context, listen: false)
          .addNote(1, _contentControl.text, DateTime.now());
      Navigator.of(context).pop();
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text("Add a new Note"),
    content: Column(mainAxisSize: MainAxisSize.min, children: [
      TextField(
          controller: _contentControl,
          decoration: InputDecoration(hintText: "Enter note"))
    ]),
    actions: [
      okButton,
    ],
  );

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
}

class NoteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => NoteProvider(), child: NotePage());
  }
}

class CardList extends StatelessWidget {
  final Note notes;
  int index;
  CardList(this.notes, this.index);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                topLeft: Radius.circular(10),
              )),
          child: ListTile(
            leading: Icon(Icons.note),
            //title: Text(notes.title),
            subtitle: Text(notes.content),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.black26,
            ),
          ),
        ),
        secondaryActions: <Widget>[
          IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () {
                print("HELLO DELETED");
                Provider.of<NoteProvider>(context, listen: false)
                    .removeNote(index);
              }),
        ],
      ),
    );
  }
}

class NoteProvider extends ChangeNotifier {
  List<Note> _notes = new List<Note>();

  List<Note> get getNotes {
    return _notes;
  }

  void addNote(int id, String content, DateTime day) {
    Note note = new Note(id, content, day);
    _notes.add(note);
    notifyListeners();
  }

  void removeNote(int index) {
    _notes.removeAt(index);
    notifyListeners();
  }
}

/* class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final List<String> _todoList = <String>[];
  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes List')),
      body: ListView(children: _getItems()),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _displayDialog(context),
          tooltip: 'Add Item',
          child: Icon(Icons.add)),
    );
  }

  void _addTodoItem(String title) {
    // Wrapping it inside a set state will notify
    // the app that the state has changed
    setState(() {
      _todoList.add(title);
    });
    _textFieldController.clear();
  }

  // Generate list of item widgets
  Widget _buildTodoItem(String title) {
    return ListTile(title: Text(title));
  }

  // Generate a single item widget
  Future<AlertDialog> _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add a note to your list'),
            content: TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: 'Enter note here'),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('ADD'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _addTodoItem(_textFieldController.text);
                },
              ),
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  List<Widget> _getItems() {
    final List<Widget> _todoWidgets = <Widget>[];
    for (String title in _todoList) {
      _todoWidgets.add(_buildTodoItem(title));
    }
    return _todoWidgets;
  }
} */

//-------------requests---------------

Future<String> getDescription(String exercise) async {
  try {
    Response response = await Dio().get(
      "https://europe-west1-trojan-tcd-dev.cloudfunctions.net/exerciseDescription?name=$exercise",
    );
    return response.data.toString();
  } catch (e) {
    print(e);
    return null;
  }
}

