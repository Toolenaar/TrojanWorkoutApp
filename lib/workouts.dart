import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<String> call() async {
  try {
    Response response = await Dio().get(
        "https://europe-west1-trojan-tcd-dev.cloudfunctions.net/test",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "<ID>"
          }
        )
    );
    print(response);
    return response.data.toString();
  } catch (e) {
    print(e);
    return null;
  }
}

class Workouts extends StatefulWidget {
  @override
  _WorkoutsState createState() => _WorkoutsState();
}

class _WorkoutsState extends State<Workouts> {
  @override
  void initState() {
    super.initState();
  }

  final exercises = List<int>.generate(5, (i) => i); // today's exercises data
  final finishQuestions = List<int>.generate(3, (i) => i); // finish questions data
  final quitQuestions = List<int>.generate(2, (i) => i); // quit questions data

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      routes: {
        '/': (_) => WorkoutsHomePage(exercises),
        'exercise': (_) => ExercisePage(0),
        'finishQuestions': (_) => QuestionsPage(finishQuestions),
        'quitQuestions': (_) => QuestionsPage(quitQuestions)
      },
    );
  }
}

class WorkoutsHomePage extends StatelessWidget {
  final exercises;

  const WorkoutsHomePage(this.exercises, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context)
        .size;
    return Column(
        children: [
          Row(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: ElevatedButton.icon(
                      onPressed: () => {},
                      icon: Icon(Icons.add, size: 20),
                      label: Text("Subscription"),
                  ),//do stuff
                ),
                Align(
                  alignment: Alignment(1000000, 2.5),
                  child: ElevatedButton(
                      onPressed: () => {},
                      child: const Text("Daily Challenge")
                  ),
                ),
                Container(
                  height: size.height * .05,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                  ),
                ),
              ],
          ),
          ElevatedButton(
              child: const Text("Today's workout"),
              onPressed: () => Navigator.pushNamed(context, 'exercise')
          ),
          FutureBuilder<String>( // todo example widget containing API data
              future: call(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();
              }
          ),
          ListView.builder( // list of exercises in workout
            shrinkWrap: true,
            itemCount: exercises.length,
            itemBuilder: (BuildContext context, int index) {
              return ExerciseWidget(exercises[index]);
            },
          )
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
  final int pageIndex; // exercise data
  ExercisePage(this.pageIndex, {
    Key key,
  }) : super(key: key);
  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  final arr = List<int>.generate(5, (i) => i);

  nextPage(context) {
    if (widget.pageIndex+1 < arr.length) { // go to next exercise
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => ExercisePage(widget.pageIndex + 1)));
    } else { // go to finish questions
      Navigator.pushNamed(context, 'finishQuestions');
    }
  }

  @override
  Widget build(BuildContext context) {
    var timer = new Timer(Duration(seconds: 2), () {nextPage(context);});
    return Row(
      children: [
        // CupertinoButton(
        //   child: const Text('Back'),
        //   onPressed: () {
        //     widget.timer.cancel();
        //     Navigator.of(context).pop(true);
        //   },
        // ),
        ElevatedButton(
          child: const Text('Skip'),
          onPressed: () {
            timer.cancel();
            nextPage(context);
          }
        ),
        ElevatedButton(
          child: const Text('Quit'),
          onPressed: () {
            timer.cancel();
            Navigator.pushReplacementNamed(context, 'quitQuestions');
          },
        ),
        Text(arr[widget.pageIndex].toString()),
      ],
    );
  }
}
class QuestionsPage extends StatefulWidget {
  final questions;
  const QuestionsPage(this.questions, {
    Key key,
  }) : super(key: key);

  @override
  _QuestionsPage createState() => _QuestionsPage();
}

class _QuestionsPage extends State<QuestionsPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          ListView.builder( // list of exercises in workout
            shrinkWrap: true,
            itemCount: widget.questions.length,
            itemBuilder: (BuildContext context, int index) {
              return QuestionWidget(widget.questions[index]);
            },
          ),
          CupertinoButton(
            child: const Text("submit"),
            onPressed: () {
              //todo how to access answers?

              //return home
              Navigator.popUntil(context, ModalRoute.withName('/')); // todo go to workout summary first?
            }
          )
        ]
    );
  }
}

class QuestionWidget extends StatefulWidget {
  final int question;
  const QuestionWidget(this.question, {
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
                  title: Text("question " + (widget.question+1).toString())
              )
          ),
          Card(
              child: ListTile(
                  title: Text("answer 1"),
                  leading: Radio(
                      groupValue: answer,
                      value: "a1",
                      onChanged: (value) {
                        setState(() {
                          answer = value;
                        });
                      }
                  )
              )
          ),
          Card(
              child: ListTile(
                  title: Text("answer 2"),
                  leading: Radio(
                      groupValue: answer,
                      value: "a2",
                      onChanged: (value) {
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