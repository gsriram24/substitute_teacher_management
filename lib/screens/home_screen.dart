import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:substitute_teacher_management/widgets/faculty_management/facultyTile.dart';
import 'package:substitute_teacher_management/widgets/home/drawer.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          DateFormat.MMMMEEEEd().format(DateTime.now()),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Choose Absent Faculty',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              builder: (ctx, facultySnapshot) {
                if (facultySnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (facultySnapshot.data.docs.length == 0) {
                  return Center(
                    child: Text(
                      'No Faculties added yet!',
                      style: Theme.of(context).textTheme.title,
                    ),
                  );
                }
                final facultyData = facultySnapshot.data.docs;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      itemBuilder: (ctx, i) {
                        return FacultyTile(facultyData[i].data(),
                            isHomeScreen: true);
                      },
                      itemCount: facultyData.length),
                );
              },
              stream: FirebaseFirestore.instance
                  .collection('faculties')
                  .snapshots(),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
    );
  }
}
