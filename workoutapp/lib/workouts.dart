import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Workouts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      routes: {
        '/': (_) => WorkoutsHomePage(),
        'exercise': (_) => ExercisePage(pageIndex:0),
        'questions': (_) => QuestionsPage(),
      },
    );
  }
}

class WorkoutsHomePage extends StatelessWidget {
  final exercises = List<int>.generate(5, (i) => i); // today's exercises data
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CupertinoButton(
          child: const Text("today's workout"),
          onPressed: () => Navigator.pushNamed(context,'exercise')
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
    return Card( //todo inc img
      child: Padding(
        padding: EdgeInsets.only(top: 36.0, left: 6.0, right: 6.0, bottom: 6.0),
        child: ExpansionTile(
          title: Text('Exercise ' + exercise.toString()),
          children: <Widget>[
            Text('exercise details')
          ],
        ),
      ),
    );
  }
}

class ExercisePage extends StatelessWidget {
  final arr = List<int>.generate(5, (i) => i);
  int pageIndex;
  ExercisePage({Key key, @required this.pageIndex}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: CupertinoButton(
            child: const Text('Back'),
            onPressed: () {
              pageIndex--;
              Navigator.of(context).pop();
            },
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: CupertinoButton(
            child: const Text('Forward'),
            onPressed: () {
              pageIndex++;
              if (pageIndex < arr.length) { // go to next exercise
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ExercisePage(pageIndex: pageIndex)));
              } else { // go to questions
                Navigator.pushNamed(context,'questions');
              }
            },
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: CupertinoButton(
            child: Text(arr[pageIndex].toString()),
            onPressed: () {
            },
          ),
        )
      ],
    );
  }
}
class QuestionsPage extends StatefulWidget {
  @override
  _QuestionsPageState createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  String v;
  @override
  Widget build(BuildContext context) {
    return ListView(
        children: [
          Card(
              child: ListTile(
                  title: Text("question 1")
              )
          ),
          Card(
              child: ListTile(
                  title: Text("answer 1"),
                  leading: Radio(
                      groupValue: v,
                      value: "a1",
                      onChanged: (value) {
                        setState(() {
                          v = value;
                        });
                      }
                  )
              )
          ),
          Card(
              child: ListTile(
                  title: Text("answer 2"),
                  leading: Radio(
                      groupValue: v,
                      value: "a2",
                      onChanged: (value) {
                        setState(() {
                          v = value;
                        });
                      }
                  )
              )
          ),
          CupertinoButton(
            child: const Text("submit"),
            onPressed: () {
              //process v

              //return home
              Navigator.popUntil(context, ModalRoute.withName('/'));
            }
          )
        ]
    );
  }
}
