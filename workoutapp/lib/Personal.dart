import 'dart:async';
//import 'dart:html';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
//import 'package:video_player/video_player.dart';

final exercises = List<int>.generate(6, (i) => i);

//Main class
class Personal extends StatelessWidget {
  final exercises = List<int>.generate(6, (i) => i); // today's exercises data

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
        titleSection,
        Container(
          padding: const EdgeInsets.all(32),
          child: Text(content),
        ),
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

  Widget titleSection = Container(
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
        Text('Day 2'),
      ],
    ),
  );

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
    return Column(
      children: [
        Container(
          height: size.height * .10,
          color: Color(0xFFF5CEB8),
          child: Text('Workout Routine',
              style: TextStyle(
                fontWeight: FontWeight.normal,
              )),
        ),
        //VideoPlayer(),
        ListView.builder(
            shrinkWrap: true,
            itemCount: exercises.length,
            itemBuilder: (BuildContext context, int index) {
              return ExerciseWidget(exercises[index]);
            }),
        ElevatedButton(
            child: const Text('Back'),
            onPressed: () => Navigator.pushNamed(context, '/'))
      ],
    );
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
    return Card(
        margin: EdgeInsets.only(top: 15.0, left: 6.0, right: 6.0, bottom: 6.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ExpansionTile(
          title: Text(
            'Day ' + exercises.toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          children: <Widget>[Text('exercise details')],
          backgroundColor: Colors.yellow,
          initiallyExpanded: false,
        ));
  }
}



/*class VideoPlayer extends StatefulWidget {
  VideoPlayer({Key key}) : super(key: key);

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  VideoPlayerController controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    controller = VideoPlayerController.asset(
        'audioFile/What’s standing strong mentally.m4a');
    _initializeVideoPlayerFuture = controller.initialize();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
    FloatingActionButton(
      onPressed: () {
        setState(() {
          if (controller.value.isPlaying) {
            controller.pause();
          } else {
            controller.play();
          }
        });
      },
      child: Icon(
        controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
      ),
    );
  }
} */
