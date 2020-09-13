import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:substitute_teacher_management/screens/edit_faculty_screen.dart';
import 'package:substitute_teacher_management/widgets/faculty_management/facultyTile.dart';

class FacultyManagementScreen extends StatelessWidget {
  static const routeName = '/faculty-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditFacultyScreen.routeName);
            },
          ),
        ],
        title: const Text('Faculties'),
      ),
      body: StreamBuilder(
        builder: (ctx, facultySnapshot) {
          final facultyData = facultySnapshot.data.docs;
          if (facultySnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                itemBuilder: (ctx, i) {
                  return FacultyTile(facultyData[i].data());
                },
                itemCount: facultyData.length),
          );
        },
        stream: FirebaseFirestore.instance.collection('faculties').snapshots(),
      ),
    );
  }
}
