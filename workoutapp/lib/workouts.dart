import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//----------widgets----------------

class Workouts extends StatefulWidget {
  final requests;
  Workouts(this.requests, {
    Key key,
  }) : super(key: key);

  @override
  _WorkoutsState createState() => _WorkoutsState();
}

class _WorkoutsState extends State<Workouts> {
  @override
  void initState() {
    super.initState();
  }

  final exercises = List<int>.generate(5, (i) => i); // today's exercises data

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      routes: {
        '/': (_) => WorkoutsHomePage(exercises, widget.requests),
        //'exercise': (_) => ExercisePage(0),
        'finishQuestions': (_) => QuestionsPage(getFinishQuestions, widget.requests),
        'quitQuestions': (_) => QuestionsPage(getQuitQuestions, widget.requests)
      },
    );
  }
}

class WorkoutsHomePage extends StatelessWidget {
  final exercises;
  final requests;
  final workouts = List<int>.generate(2, (i) => i);

  WorkoutsHomePage(this.exercises, this.requests, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    return Column(
        children: [
          ElevatedButton(
              onPressed: () => {},
              child: const Text("Physical Program")
          ),
          ElevatedButton(
              onPressed: () => {},
              child: const Text("Daily Challenge")
          ),
          ListView.builder( // list of exercises in workout
            shrinkWrap: true,
            itemCount: workouts.length,
            itemBuilder: (BuildContext context, int index) {
              return ElevatedButton(
                  child: Text(requests["workouts"].keys.toList()[index]),
                  onPressed: () => Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => ExercisePage(requests["workouts"].values.toList()[index], 0)
                      )
                  )
              );
            },
          ),
          // ListView.builder( // list of exercises in workout
          //   shrinkWrap: true,
          //   itemCount: exercises.length,
          //   itemBuilder: (BuildContext context, int index) {
          //     return ExerciseWidget(exercises[index]);
          //   },
          // )
        ]
    );
  }
}

class ExerciseWidget extends StatelessWidget {
  final int exercise; // exercise data
  const ExerciseWidget(this.exercise, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.only(top: 25.0, left: 6.0, right: 6.0, bottom: 6.0),
        shadowColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ExpansionTile(
          title: Text('Exercise ' + exercise.toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          children: <Widget>[
            Text('exercise details',
              style: TextStyle(color: Colors.lightBlue),)
          ],
          backgroundColor: Colors.lightGreen,
          initiallyExpanded: false,
        )

    );
  }
}


class ExercisePage extends StatefulWidget {
  final exercises;
  final index;
  ExercisePage(this.exercises, this.index, {
    Key key,
  }) : super(key: key);
  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  // final arr = List<int>.generate(5, (i) => i);

  nextPage(context) {
    if (widget.index + 1 < widget.exercises.length) { // go to next exercise
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) =>
              ExercisePage(widget.exercises, widget.index + 1)));
    } else { // go to finish questions
      Navigator.pushNamed(context, 'finishQuestions');
    }
  }

  @override
  Widget build(BuildContext context) {
    var timer = new Timer(Duration(seconds: 5), () {
      nextPage(context);
    });
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 4.0),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        height: MediaQuery
            .of(context)
            .size
            .height,
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Stack(
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red, // background
                      onPrimary: Colors.white, // foreground
                    ),
                    child: const Text('Quit'),
                    onPressed: () {
                      timer.cancel();
                      Navigator.pushReplacementNamed(context, 'quitQuestions');
                    },
                  ),
                )),
            Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green, // background
                        onPrimary: Colors.white, // foreground
                      ),
                      child: const Text('Skip'),
                      onPressed: () {
                        timer.cancel();
                        nextPage(context);
                      }
                  ),
                )
            ),
            Align(
                alignment: Alignment.topCenter,
                child: Padding(
                    padding: EdgeInsets.all(50),
                    child: Text(widget.exercises[widget.index],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      ),
                    )
                )
            ),
            Align(
              alignment: Alignment.center,
              child: Image.network(
                'https://asweatlife.com/wp-content/uploads/2018/04/MG_5692.jpg',
                width: 383,
                height: 600,
              ),
            ),
          ],
        )
    );
  }
}

class QuestionsPage extends StatefulWidget {
  final Function getQuestions;
  final HashMap requests;
  const QuestionsPage(this.getQuestions, this.requests, {
    Key key,
  }) : super(key: key);

  @override
  _QuestionsPage createState() => _QuestionsPage();
}

class _QuestionsPage extends State<QuestionsPage> {
  List answers = List<String>.generate((2), (index) => "null");

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.getQuestions(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column( // success
                children: [
                  ListView.builder( // list of exercises in workout
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return QuestionWidget(snapshot.data[index], (answer) =>
                      answers[index] = answer);
                    },
                    itemCount: snapshot.data.length,
                  ),

                  CupertinoButton(
                      child: const Text("submit"),
                      onPressed: () async {
                        if (!answers.contains(
                            "null")) { // only return home if all questions have been answered
                          await postAnswers(answers, widget.requests);
                          Navigator.popUntil(context, ModalRoute.withName(
                              '/')); // todo go to workout summary first?
                        }
                      }
                  )
                ]
            );
          }
          else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator()
          );
        }
    );
  }
}

class QuestionWidget extends StatefulWidget {
  final Map question;
  final onChange;
  QuestionWidget(this.question, this.onChange, {
    Key key,
  }) : super(key: key);

  @override
  _QuestionWidget createState() => _QuestionWidget();
}

class _QuestionWidget extends State<QuestionWidget> {
  var answer;
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Card(
              child: ListTile(
                  title: Text(widget.question["Question"])
              )
          ),
          Card(
              child: ListTile(
                  title: Text(widget.question["Answers"][0]),
                  leading: Radio(
                      groupValue: answer,
                      value: "a1",
                      onChanged: (value) {
                        widget.onChange(value);
                        setState(() {
                          answer = value;
                        });
                      }
                  )
              )
          ),
          Card(
              child: ListTile(
                  title: Text(widget.question["Answers"][1]),
                  leading: Radio(
                      groupValue: answer,
                      value: "a2",
                      onChanged: (value) {
                        widget.onChange(value);
                        setState(() {
                          answer = value;
                        });
                      }
                  )
              )
          ),
        ]
    );
  }
}

//------------requests--------------


Future<String> call() async {
  try {
    Response url = await Dio().get(
      "https://europe-west1-trojan-tcd-dev.cloudfunctions.net/test",
    );
    Response response = await Dio().get(
      url.data
    );
    return response.data;
    // File file = File("assets/bruce-lee.jpg");
    // var raf = file.openSync(mode: FileMode.write);
    // raf.writeByteSync(response.data);
    // await raf.close();
    // return "bruce-lee.jpg";
  } catch (e) {
    print(e);
    return null;
  }
}

Future<List> getQuitQuestions() async {
  try {
    Response response = await Dio().get(
      "https://europe-west1-trojan-tcd-dev.cloudfunctions.net/quitQuestions",
    );
    return response.data.values.toList();
  } catch (e) {
    print(e);
    return null;
  }
}

Future<List> getFinishQuestions() async {
  try {
    Response response = await Dio().get(
      "https://europe-west1-trojan-tcd-dev.cloudfunctions.net/finishQuestions",
    );
    return response.data.values.toList();
  } catch (e) {
    print(e);
    return null;
  }
}

Future<void> postAnswers(List answers, HashMap requests) async {
  try {
    var userId = "UserId1"; // todo get current user
    var day = requests["programDay"]["physical"];
    await Dio().post(
        "https://europe-west1-trojan-tcd-dev.cloudfunctions.net/answers",
        data: {"UserId":userId,"Answers":answers,"Day":day}
    );
  } catch (e) {
    print(e);
    return null;
  }
}