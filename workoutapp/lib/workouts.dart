import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*

 */

class Workouts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      routes: {
        '/': (_) => WorkoutsHomePage(),
        'next': (_) => ExercisePage(),
      },
      // child: const Text("today's workout"),
      // onPressed: () {workout(context);},
    );
  }

  // void workout(BuildContext context) {
  //   final q = Queue<int>();
  //   q.add(1);
  //   q.add(2);
  //   q.add(3);
  //   q.add(4);
  //   Navigator.of(context).push(
  //       CupertinoPageRoute<void>(
  //         builder: (BuildContext context) {
  //           return Row(
  //             children: [
  //               Align(
  //                 alignment: Alignment.topLeft,
  //                 child: CupertinoButton(
  //                   child: const Text('Back'),
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                 ),
  //               ),
  //               Align(
  //                 alignment: Alignment.topRight,
  //                 child: CupertinoButton(
  //                   child: const Text('Forward'),
  //                   onPressed: () {
  //                     Navigator.of(context).push();
  //                   },
  //                 ),
  //               ),
  //             ],
  //           );
  //         },
  //       )
  //   );
  // }
}

class WorkoutsHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      child: const Text("today's workout"),
      onPressed: () => Navigator.pushNamed(context,'next'),
    );
  }
}

class ExercisePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: CupertinoButton(
            child: const Text('Back'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: CupertinoButton(
            child: const Text('Forward'),
            onPressed: () {
              Navigator.pushNamed(context,'next');
            },
          ),
        ),
      ],
    );
  }
}