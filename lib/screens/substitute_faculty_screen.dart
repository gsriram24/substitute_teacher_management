import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SubstituteFacultyScreen extends StatefulWidget {
  static const routeName = '/substitute-faculty-screen';

  @override
  _SubstituteFacultyScreenState createState() =>
      _SubstituteFacultyScreenState();
}

class _SubstituteFacultyScreenState extends State<SubstituteFacultyScreen> {
  var currentFaculty;
  var _isInit = true;
  var _isLoading = false;

  List allFaculties;
  Future<List> getFaculties() async {
    QuerySnapshot faculties =
        await FirebaseFirestore.instance.collection('faculties').get();
    return faculties.docs
        .map((snapshot) => {
              'empId': snapshot.data()['empId'],
              'fullName': snapshot.data()['fullName'],
              'classes': snapshot.data()['classes'],
              'email': snapshot.data()['email'],
              'timeTable': snapshot.data()['timeTable'],
            })
        .toList();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      currentFaculty = ModalRoute.of(context).settings.arguments as Map;
      allFaculties = await getFaculties();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentFaculty['fullName']),
      ),
    );
  }
}
