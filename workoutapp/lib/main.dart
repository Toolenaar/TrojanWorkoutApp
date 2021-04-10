import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:workoutapp/workouts.dart';
import 'package:workoutapp/personal.dart';
import 'package:workoutapp/community.dart';
import 'package:workoutapp/library.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final GlobalKey<NavigatorState> firstTabNavKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> secondTabNavKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> thirdTabNavKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> fourthTabNavKey = GlobalKey<NavigatorState>();
FirebaseAnalytics analytics = FirebaseAnalytics();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(WorkoutApp());
}

// make initial api requests before app starts
Future<HashMap> initRequests() async {
  HashMap out = new HashMap();
  try {
    // get exercise names todo could get pairs of img-description instead?
    Response response = await Dio().get(
      "https://europe-west1-trojan-tcd-dev.cloudfunctions.net/exerciseNames",
    );
    out.putIfAbsent("exerciseNames", () => response.data.split(","));

    // get current program day for the current user
    const userId = "UserId1";
    response = await Dio().get(
      "https://europe-west1-trojan-tcd-dev.cloudfunctions.net/date?user=$userId",
    );
    List days = response.data.split(",");
    out.putIfAbsent("programDay", () => {"physical":days[0], "mental":days[1]});

    // get list of workouts and their exercises
    // format: workout1:ex1?descriptionURL-imgURL,ex2?descriptionURL-imgURL;workout2:ex1?descriptionURL-imgURL,ex2?descriptionURL-imgURL;etc
    response = await Dio().get(
      "https://europe-west1-trojan-tcd-dev.cloudfunctions.net/workouts",
    );
    List responses = response.data.split(";");
    HashMap workouts = new HashMap();
    for (var elem in responses) {
      List workout = elem.split(":");
      List exercises = workout[1].split(",");
      // HashMap exercisesMap = new HashMap(); // exercise : [descriptionURL, imgURL]
      // for (var exercise in exercises) {
      //   List urls = exercise.split("?");
      //   exercisesMap.putIfAbsent(urls[0], () => urls[1].split("-"));
      // }
      workouts.putIfAbsent(workout[0], () => exercises);
    }
    out.putIfAbsent("workouts", () => workouts);

    // other...

    return out;
  } catch (e) {
    print(e);
    return null;
  }
}

class WorkoutApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initRequests(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CupertinoApp(
              home: new HomeScreen(snapshot.data),
              localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
                DefaultMaterialLocalizations.delegate,
                DefaultWidgetsLocalizations.delegate,
              ],
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

class HomeScreen extends StatefulWidget {
  final requests;
  const HomeScreen(this.requests, {
    Key key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
    
      tabBar: CupertinoTabBar(
        activeColor: Color(0xFFF5CEB8),
        items: [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.dumbbell),
            title: Text('Workout'),
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.leanpub),
            title: Text('Learn'),
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.globe),
            title: Text('Community'),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.book),
            title: Text('Library'),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        if (index == 0) {
          return CupertinoTabView(
            navigatorKey: firstTabNavKey,
            builder: (BuildContext context) => Workouts(widget.requests),
          );
        } else if (index == 1) {
          return CupertinoTabView(
            navigatorKey: secondTabNavKey,
            builder: (BuildContext context) => Personal(widget.requests),
          );
        } else if (index == 2) {
          return CupertinoTabView(
            navigatorKey: thirdTabNavKey,
            builder: (BuildContext context) => Community(),
          );
        } else {
          return CupertinoTabView(
            navigatorKey: fourthTabNavKey,
            builder: (BuildContext context) => Library(widget.requests),
          );
        }
      },
    );
  }
}

//class Personal extends StatelessWidget {
//@override
//Widget build(BuildContext context) {
//return Container(
//color: Colors.greenAccent,
//);
//}
//}

//class Community extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      color: Colors.blue,
//    );
//  }
//}

//class Library extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      color: Colors.yellowAccent,
//    );
//  }
//}
