import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

//Main class
class Personal extends StatelessWidget {
  final exercises = List<int>.generate(5, (i) => i); // today's exercises data

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (_) => PersonalHomePage(exercises),
        'days': (_) => FullProgramPage()
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
    var size = MediaQuery.of(context)
        .size; //this gives us total height and width of our device
    return Scaffold(
        body: SingleChildScrollView(
            child: Stack(children: <Widget>[
      Container(
        height: size.height * .35,
        color: Color(0xFFF5CEB8),
      ),
      SafeArea(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: <Widget>[
                Text(
                  "Learn",
                  style: Theme.of(context)
                      .textTheme
                      .headline2
                      .copyWith(fontWeight: FontWeight.w900),
                ),
                ElevatedButton(
                    child: const Text("Full Program"),
                    onPressed: () => Navigator.pushNamed(context, 'days')),
                Text(
                  "Day 2: Today you will learn the importance of the power-pose",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontWeight: FontWeight.w900),
                ),

                Text(content),
                //need to space this out from previous text
              ])))
    ])));
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
    return Container(
      height: size.height * .35,
      color: Color(0xFFF5CEB8),
    );
  }
}
