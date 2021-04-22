import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:dio/dio.dart';
import 'package:audioplayers/audioplayers.dart';



String notes = "";

//Main class
class Personal extends StatefulWidget {
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
    print(FirebaseAuth.instance.currentUser.getIdToken());
    return MaterialApp(
      routes: {
        '/': (_) => PersonalHomePage(widget.requests),
        // chaged to note page from full program page which is removed
        'days': (_) => NotePage(widget.requests),
      },
    );
  }
}

//Home Page
class PersonalHomePage extends StatefulWidget {
  final requests;
  const PersonalHomePage(
    this.requests, {
    Key key,
  }) : super(key: key);

  @override
  _PersonalHomePage createState() => _PersonalHomePage();
}

class _PersonalHomePage extends State<PersonalHomePage> {
  String _playing = "Play";
  AudioPlayer _player = AudioPlayer();
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
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    var day = widget.requests["programDay"]["mental"];
    return Scaffold(
        appBar: AppBar(
          title: Container(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Learn',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  child: const Text("Notes"),
                  onPressed: () => Navigator.pushNamed(context, 'days')),
            ),
          ],
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
          children: [
            //get title
            Container(
              padding: const EdgeInsets.all(32),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            FutureBuilder<String>(
                                future: getText(day, day + "MentalHeader"),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Flexible(
                                        child: Text(snapshot.data,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)));
                                  } else if (snapshot.hasError) {
                                    return Text("${snapshot.error}");
                                  }
                                  return Center(
                                      child: CircularProgressIndicator());
                                }),
                          ],
                        )
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
                  future: getText(day, day + "MentalDescription"),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Flexible(
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                  width / 15, 0, width / 15, 0),
                              child: Text(snapshot.data,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))));
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return Center(child: CircularProgressIndicator());
                  }),
            ]),
            Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                      child: Text(_playing),
                      onPressed: () {
                        if (_playing == "Play") {
                          setState(() {
                            _playing = "Pause";
                            _player.play(
                                "https://firebasestorage.googleapis.com/v0/b/trojan-tcd-dev.appspot.com/o/Program%2FDay1%2FMental%2FWhat%E2%80%99s%20standing%20strong%20mentally.m4a?alt=media&token=38fb7332-2c67-4e49-aab0-755a19685c1f");
                          });
                        } else {
                          setState(() {
                            _playing = "Play";
                            _player.pause();
                          });
                        }
                      }),
                )),
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

}




final String tableNotes = 'notes';
final String columnId = '_id';
final String columnContent = "content";
final String columnDateMade = "date_created";


class NotePage extends StatefulWidget {

  final requests;
  const NotePage(
    this.requests, {
    Key key,
  }) : super(key: key);

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  
  TextEditingController _contentControl = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    List<String> allNotes = widget.requests["notes"].values.toList(); //List();
    var size = MediaQuery.of(context).size;
    var height = size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
      ),
      body: allNotes == null
          ? Container()
          : ListView.builder(
              itemCount: allNotes.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                    onDismissed: (direction) => setState(() {
                          allNotes.remove(allNotes[index]);
                        }),
                    key: Key(allNotes[index]),
                    child: Card(
                        child: ListTile(
                      title: Text("" + allNotes[index] + ""),
                    )));
              }),
      floatingActionButton: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, height * 0.075),
        child: FloatingActionButton(
            onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      title: Text("Add note"),
                      content: TextField(
                        onChanged: (String value) {
                          notes = value;
                        },
                      ),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () {
                              setState(() {
                                allNotes.add(notes);
                              });
                              Navigator.of(context).pop();
                            },
                            child: Text("Add note"))
                      ]);
                }),
            tooltip: 'Add Item',
            child: Icon(Icons.add)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}


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

Future<String> getText(String day, String text) async {
  try {
    Response response = await Dio().get(
      "https://europe-west1-trojan-tcd-dev.cloudfunctions.net/exerciseLearnDescription?name=$text&day=$day",
    );
    return response.data.toString();
  } catch (e) {
    print(e);
    return null;
  }
}
