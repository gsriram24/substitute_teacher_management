import 'package:flutter/material.dart';
import 'package:substitute_teacher_management/screens/edit_faculty_screen.dart';

class FacultyTile extends StatelessWidget {
  final dynamic faculty;
  FacultyTile(this.faculty);
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return Container(
      child: ListTile(
        title: Text(faculty['fullName']),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(faculty['empId']),
        ),
        // subtitle: Row(
        //   children: faculty['classes'].map<Widget>(
        //     (sub) {
        //       return Text(sub['id'] + ', ');
        //     },
        //   ).toList(),
        // ),
        trailing: Container(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).pushNamed(EditFacultyScreen.routeName,
                      arguments: faculty);
                },
                color: Theme.of(context).primaryColor,
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  try {} catch (error) {
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
