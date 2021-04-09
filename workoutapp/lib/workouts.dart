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
        'exercise': (_) => ExercisePage(0),
        'finishQuestions': (_) => QuestionsPage(getFinishQuestions, widget.requests),
        'quitQuestions': (_) => QuestionsPage(getQuitQuestions, widget.requests)
      },
    );
  }
}

class WorkoutsHomePage extends StatelessWidget {
  final exercises;
  final requests;

  const WorkoutsHomePage(this.exercises, this.requests, {
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
                ),
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
          Image.network(requests["test"],fit: BoxFit.fill,
            loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null ?
                  loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                      : null,
                ),
              );
            },
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