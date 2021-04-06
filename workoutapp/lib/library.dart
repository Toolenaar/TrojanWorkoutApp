import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


//------------widgets-------------

class Library extends StatelessWidget {
  final requests;
  Library(this.requests, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
        future: getExerciseNames(requests),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder( // list of exercises in workout
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return ExerciseWidget(snapshot.data[index]);
              },
            );
          } else if (snapshot.hasError) {
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

class ExerciseWidget extends StatelessWidget {
  final String exercise; // exercise data
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
          title: Row(
              children: [
                Text("img"),
                Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(exercise,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                )
              ]
          ),
          children: <Widget>[
            Row(
                children: [
                  FutureBuilder<String>(
                      future: getDescription(exercise),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Flexible(
                              child: Text(snapshot.data,
                                  style: TextStyle(fontWeight: FontWeight.bold)
                              )
                          );
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        return CircularProgressIndicator();
                      }
                  ),
                ]
            )
          ],
          initiallyExpanded: false,
        )

    );
  }
}

//-------------requests---------------

Future<List<String>> getExerciseNames(HashMap requests) async {
  return await requests["exerciseNames"];
}

Future<String> getDescription(String exercise) async {
  try {
    Response response = await Dio().get(
      "https://europe-west1-trojan-tcd-dev.cloudfunctions.net/exerciseDescription?name=$exercise",
    );
    return response.data.toString();
  } catch (e) {
    print(e);
    return null;
  }
}