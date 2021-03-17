import 'package:flutter/cupertino.dart';
//import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

//Main class
class Personal extends StatelessWidget {
  final exercises = List<int>.generate(5, (i) => i); // today's exercises data
  //CalendarController _calendar;

  //@override
  //void initState() {
  //super.initState();
  // _calendar = CalendarController();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

CalendarController _calendar;

@override
void initState() {
  //super.initState();
  _calendar = CalendarController();
  // super.initState();
}

class _PersonalHomePage extends State<PersonalHomePage> {
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Text('Username',
          textAlign: TextAlign.right, style: TextStyle(fontSize: 20)),
      Text('Quote',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10, height: 2)),
      //CalendarWidget(),
      //TableCalendar(
      //initialCalendarFormat: CalendarFormat.month,
      //calendarStyle: CalendarStyle(todayColor: Colors.purple),
      // calendarController: _calendar,
      // ),
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
              TextField(onChanged: (text) {
                Text(text);
                //todo: stop text from erasing when expansion tile closes
              })
            ]),
      ),
    );
  }
}

class CalendarWidget extends StatefulWidget {
  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  CalendarController cal;
  TextStyle dayTextStyle(FontWeight weightOfFont) {
    return TextStyle(color: Color(0xffa500), fontWeight: weightOfFont);
  }

  @override
  void initState() {
    super.initState();
    cal = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
      TableCalendar(
        initialCalendarFormat: CalendarFormat.month,
        headerStyle: HeaderStyle(
            centerHeaderTitle: true,
            formatButtonDecoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(10.0))),
        startingDayOfWeek: StartingDayOfWeek.monday,
        calendarStyle: CalendarStyle(
          weekdayStyle: dayTextStyle(FontWeight.normal),
        ),
        builders: CalendarBuilders(
            selectedDayBuilder: (context, date, events) => Container(
                margin: const EdgeInsets.all(5.0),
                alignment: Alignment.center)),
        calendarController: cal,
      )
    ]))));
  }
}
