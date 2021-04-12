import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    return FutureBuilder<HashMap>(
        future: getExercise(exercise),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Card(
                margin: EdgeInsets.only(
                    top: 25.0, left: 6.0, right: 6.0, bottom: 6.0),
                shadowColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ExpansionTile(
                  title: Row(
                      children: [
                        Container(
                          width: 70.0,
                          height: 70.0,
                          child: Image.network(
                            snapshot.data["img"], fit: BoxFit.fill,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                        ),
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
                          Flexible(
                              child: Text(snapshot.data["description"],
                                  style: TextStyle(fontWeight: FontWeight.bold)
                              )
                          )
                        ]
                    )
                  ],
                  initiallyExpanded: false,
                )
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(
              child: CircularProgressIndicator()
          );
        }
    );
  }
}

//-------------requests---------------

Future<List<String>> getExerciseNames(HashMap requests) async {
  return await requests["exerciseNames"];
}

Future<HashMap> getExercise(String exercise) async {
  try {
    Response response = await Dio().get(
      "https://europe-west1-trojan-tcd-dev.cloudfunctions.net/exerciseDescription?name=$exercise",
    );
    HashMap out = new HashMap();
    out.putIfAbsent("description", () => response.data);
    response = await Dio().get(
      "https://europe-west1-trojan-tcd-dev.cloudfunctions.net/test?name=$exercise", // todo should be using exerciseImg, but auth is weird...
    );
    out.putIfAbsent("img", () => response.data);
    return out;
  } catch (e) {
    print(e);
    return null;
  }
}


