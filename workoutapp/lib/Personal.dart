import 'package:flutter/cupertino.dart';
//import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

//Main class
class Personal extends StatelessWidget {
  final exercises = List<int>.generate(5, (i) => i); // today's exercises data

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      routes: {
        '/': (_) => PersonalHomePage(exercises),
      },
    );
  }
}

//Home Page
class PersonalHomePage extends StatefulWidget {
  final exercises;
  const PersonalHomePage(
    this.exercises, {
    Key key,
  }) : super(key: key);

  @override
  _PersonalHomePage createState() => _PersonalHomePage();
}

class _PersonalHomePage extends State<PersonalHomePage> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListView.builder(
        // list of exercises in workout
        shrinkWrap: true,
        itemCount: widget.exercises.length,
        itemBuilder: (BuildContext context, int index) {
          return ExerciseWidget(widget.exercises[index]);
        },
      )
    ]);
  }
}

class ExerciseWidget extends StatefulWidget {
  final int exercise; // exercise data
  const ExerciseWidget(
    this.exercise, {
    Key key,
  }) : super(key: key);
  @override
  _ExerciseWidget createState() => _ExerciseWidget();
}

class _ExerciseWidget extends State<ExerciseWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.only(top: 36.0, left: 6.0, right: 6.0, bottom: 6.0),
        child: ExpansionTile(
            title: Text('Record ' + widget.exercise.toString()),
            children: <Widget>[
              Text('Yes')
              //todo editable text in widget
            ]),
      ),
    );
  }
}

