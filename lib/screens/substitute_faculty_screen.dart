import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:substitute_teacher_management/widgets/faculty_management/facultyTile.dart';

class SubstituteFacultyScreen extends StatefulWidget {
  static const routeName = '/substitute-faculty-screen';

  @override
  _SubstituteFacultyScreenState createState() =>
      _SubstituteFacultyScreenState();
}

class _SubstituteFacultyScreenState extends State<SubstituteFacultyScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var currentFaculty;
  var _isInit = true;
  var _isLoading = false;
  var day = DateFormat.EEEE().format(DateTime.now());

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

  int getFreeHours(faculty, day) {
    return faculty['timeTable'][day].where((c) => c == 'Free').toList().length;
  }

  List getClasses(faculty) {
    List classes = [];
    faculty['classes'].forEach((cls) {
      classes.add(cls['semester'] + cls['branch'] + cls['section']);
    });
    return classes;
  }

  Map getClass(String clss, faculty) {
    var foundClass = {};
    faculty['classes'].forEach((cls) {
      if (cls['id'] == clss) {
        foundClass = cls;
      }
    });
    return foundClass;
  }

  List findSubstituteFaculties(day, hour) {
    final dailyTimeTable = currentFaculty['timeTable'][day];
    final hourClass = dailyTimeTable[hour];
    final freeFacultyList = [];
    allFaculties.forEach((faculty) {
      var classObj = getClass(hourClass, currentFaculty);
      var cls = classObj['semester'] + classObj['branch'] + classObj['section'];
      if (getClasses(faculty).contains(cls) &&
          faculty['empId'] != currentFaculty['empId']) {
        if (faculty['timeTable'][day][hour] == 'Free') {
          freeFacultyList.add(faculty);
        }
      }
    });
    return freeFacultyList;
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      day = day == "Sunday" ? "Monday" : day;
      currentFaculty = ModalRoute.of(context).settings.arguments as Map;
      allFaculties = await getFaculties();
    }
    setState(() {
      _isInit = false;
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(currentFaculty['fullName']),
      ),
      body: _isInit
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Text(
                    'Day',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: DropdownButtonFormField(
                        icon: Icon(Icons.expand_more),
                        items: [
                          'Monday',
                          'Tuesday',
                          'Wednesday',
                          'Thursday',
                          'Friday',
                          'Saturday'
                        ]
                            .map<DropdownMenuItem<String>>(
                              (d) => DropdownMenuItem<String>(
                                value: d,
                                child: Text(d),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            day = value;
                          });
                        },
                        value: day,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  currentFaculty['timeTable'][day]
                              .where((i) => i != 'Free')
                              .toList()
                              .length ==
                          0
                      ? Container(
                          height: 400,
                          child: Center(
                            child: Text(
                              'Faculty is Free!',
                              style: Theme.of(context).textTheme.title,
                            ),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Substitute Faculties',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Card(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  children: currentFaculty['timeTable'][day]
                                      .asMap()
                                      .entries
                                      .map<Widget>(
                                        (hour) {
                                          if (hour.value != 'Free') {
                                            var cls;
                                            var classObj = getClass(
                                                hour.value, currentFaculty);
                                            cls = classObj['semester'] +
                                                ' ' +
                                                classObj['section'] +
                                                ' ' +
                                                classObj['branch'];
                                            var subFaculties =
                                                findSubstituteFaculties(
                                                    day, hour.key);
                                            return ExpansionTile(
                                              childrenPadding:
                                                  EdgeInsets.symmetric(
                                                vertical: 16,
                                              ),
                                              title: Text(
                                                  'Hour ${(hour.key + 1)}: $cls'),
                                              children: subFaculties.length == 0
                                                  ? [
                                                      Text(
                                                        'No Free Faculties',
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )
                                                    ]
                                                  : subFaculties
                                                      .map(
                                                        (faculty) =>
                                                            FacultyTile(
                                                          faculty,
                                                          scaffoldKey:
                                                              _scaffoldKey,
                                                          isSubstituteScreen:
                                                              true,
                                                          cls: cls,
                                                          hour: hour.key,
                                                          numFreeHrs:
                                                              getFreeHours(
                                                            faculty,
                                                            day,
                                                          ),
                                                        ),
                                                      )
                                                      .toList(),
                                            );
                                          }
                                        },
                                      )
                                      .where((o) => o != null)
                                      .toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
    );
  }
}
