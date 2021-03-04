import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Workouts extends StatelessWidget {

  final exercises = List<int>.generate(5, (i) => i); // today's exercises data
  final finishQuestions = List<int>.generate(3, (i) => i); // finish questions data
  final quitQuestions = List<int>.generate(2, (i) => i); // quit questions data

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      routes: {
        '/': (_) => WorkoutsHomePage(exercises),
        'exercise': (_) => ExercisePage(pageIndex:0),
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
    return Card(
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
  final int pageIndex;

  ExercisePage({Key key, @required this.pageIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CupertinoButton(
          child: const Text('Back'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        CupertinoButton(
          child: const Text('Forward'),
          onPressed: () {
            if (pageIndex+1 < arr.length) { // go to next exercise
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ExercisePage(pageIndex: pageIndex+1)));
            } else { // go to questions
              Navigator.pushNamed(context, 'finishQuestions');
            }
          },
        ),
        CupertinoButton(
          child: const Text('Quit'),
          onPressed: () {
            Navigator.pushNamed(context, 'quitQuestions');
          },
        ),
        Align(
          alignment: Alignment.center,
          child: CupertinoButton(
            child: Text(arr[pageIndex].toString()),
            onPressed: () {},
          ),
        )
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
              //process v

              //return home
              Navigator.popUntil(context, ModalRoute.withName('/'));
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
