import 'package:flutter/material.dart';
import 'package:substitute_teacher_management/screens/edit_faculty_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:substitute_teacher_management/screens/substitute_faculty_screen.dart';

class FacultyTile extends StatelessWidget {
  final dynamic faculty;
  final bool isHomeScreen;
  FacultyTile(this.faculty, {this.isHomeScreen = false});
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return Container(
      child: ListTile(
        onTap: isHomeScreen
            ? () {
                Navigator.of(context).pushNamed(
                  SubstituteFacultyScreen.routeName,
                  arguments: faculty,
                );
              }
            : null,
        title: Text(faculty['fullName']),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(faculty['empId']),
        ),
        // subtitle: Row(
        //   children: faculty['classes'].map<Widget>(
        //     (sub) {
        //       return Text(sub['subjectName'] + ', ');
        //     },
        //   ).toList(),
        // ),
        trailing: isHomeScreen
            ? null
            : Container(
                width: 100,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                            EditFacultyScreen.routeName,
                            arguments: faculty);
                      },
                      color: Theme.of(context).primaryColor,
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        try {
                          FirebaseFirestore.instance
                              .collection('faculties')
                              .doc(faculty['empId'])
                              .delete();
                        } catch (error) {
                          scaffold.showSnackBar(
                            SnackBar(
                              content: Text(
                                'Deleting failed!',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                      },
                      color: Theme.of(context).errorColor,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
