import 'package:flutter/material.dart';
import 'dart:math';

class SubjectTile extends StatelessWidget {
  final void Function(String id) deleteSubject;
  final index;
  final subject;
  List colorList = [
    Colors.blue,
    Colors.purple,
    Colors.deepPurple,
    Colors.brown,
    Colors.green,
    Colors.red,
  ];
  SubjectTile(this.subject, this.deleteSubject, this.index);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: colorList[index % colorList.length],
            borderRadius: BorderRadius.circular(6)),
        width: 150,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Semester ${subject['semester']}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: IconButton(
                      color: Colors.white,
                      padding: EdgeInsets.all(0),
                      icon: Icon(
                        Icons.delete,
                      ),
                      onPressed: () {
                        deleteSubject(subject['id']);
                      },
                      iconSize: 16,
                    ),
                  ),
                ],
              ),
              Text(
                "Section ${subject['section']}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "${subject['subjectName']}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
