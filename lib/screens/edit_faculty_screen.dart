import 'package:flutter/material.dart';
import 'package:substitute_teacher_management/widgets/edit_faculty/new_subject_modal.dart';
import 'package:substitute_teacher_management/widgets/edit_faculty/subject_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditFacultyScreen extends StatefulWidget {
  static const routeName = '/edit-faculty';

  @override
  _EditFacultyScreenState createState() => _EditFacultyScreenState();
}

class _EditFacultyScreenState extends State<EditFacultyScreen> {
  final _formKey = GlobalKey<FormState>();

  var _initValues = {
    'fullName': '',
    'classes': [],
    'email': '',
    'timeTable': {
      "Monday": List.filled(7, 'Free'),
      "Tuesday": List.filled(7, 'Free'),
      "Wednesday": List.filled(7, 'Free'),
      "Thursday": List.filled(7, 'Free'),
      "Friday": List.filled(7, 'Free'),
      "Saturday": List.filled(4, 'Free')
    },
  };
  List classes;
  var timeTable;
  var _isInit = true;
  var _isLoading = false;
  var faculty;
  void didChangeDependencies() {
    if (_isInit) {
      faculty = ModalRoute.of(context).settings.arguments as Map;
      if (faculty != null) {
        _initValues = faculty;
      }
      classes = _initValues['classes'];
      timeTable = _initValues['timeTable'];
      print(timeTable['Monday'].asMap());
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _submitData() async {
    final isValid = _formKey.currentState.validate();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      if (faculty == null) {
        await FirebaseFirestore.instance
            .collection('faculties')
            .doc(_initValues['empId'])
            .set(_initValues);
        print('Faculty Added');
      } else {
        await FirebaseFirestore.instance
            .collection('faculties')
            .doc(_initValues['empId'])
            .update(_initValues);
      }
      Navigator.of(context).pop();
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _startAddNewSubject(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return NewSubjectModal(addSubject);
      },
    );
  }

  void addSubject(
      String branch, String semester, String section, String subjectName) {
    String subjectInitials = subjectName.split(' ').map((word) {
      return word[0];
    }).join('');
    String id = semester + branch + section + subjectInitials;
    final newSubject = {
      'section': section,
      'semester': semester,
      'id': id,
      'branch': branch,
      'subjectName': subjectName
    };
    setState(
      () {
        classes.add(newSubject);
        _initValues['classes'] = classes;
      },
    );
  }

  void deleteSubject(String id) {
    final existingSubjectIndex = classes.indexWhere((clss) => clss['id'] == id);

    setState(
      () {
        classes.removeAt(existingSubjectIndex);
        _initValues['classes'] = classes;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ];
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text('Edit Faculty'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _submitData),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    Text('Basic Details'),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            TextFormField(
                              initialValue: _initValues['empId'],
                              onChanged: (value) {
                                _initValues['empId'] = value;
                              },
                              enabled: faculty == null ? true : false,
                              key: ValueKey('empId'),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Employee ID',
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please Enter the Employee ID of the faculty!';
                                }

                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 24.0,
                            ),
                            TextFormField(
                              initialValue: _initValues['fullName'],
                              onChanged: (value) {
                                _initValues['fullName'] = value;
                              },
                              key: ValueKey('fullName'),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Full Name',
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please Enter the full name of the faculty!';
                                }

                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 24.0,
                            ),
                            TextFormField(
                              initialValue: _initValues['email'],
                              onChanged: (value) {
                                _initValues['email'] = value;
                              },
                              key: ValueKey('email'),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Email',
                              ),
                              validator: (value) {
                                Pattern pattern =
                                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                RegExp regex = new RegExp(pattern);

                                if (value.isEmpty) {
                                  return 'Please Enter the Email ID of the faculty';
                                }
                                if (!regex.hasMatch(value)) {
                                  return 'Enter a valid Email ID.';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Subjects'),
                        FlatButton.icon(
                          icon: Icon(
                            Icons.add,
                            color: Theme.of(context).primaryColor,
                            size: 18,
                          ),
                          onPressed: () => _startAddNewSubject(context),
                          label: Text(
                            'Add Subject',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 12,
                            ),
                          ),
                        )
                      ],
                    ),
                    Card(
                      child: Container(
                        height: 120,
                        child: classes == null
                            ? Text('Empty')
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (ctx, i) {
                                  return SubjectTile(classes[i], deleteSubject);
                                },
                                itemCount: classes.length,
                              ),
                      ),
                    ),
                    Text('Time Table'),
                    Card(
                      child: Column(
                        children: days
                            .map(
                              (day) => ExpansionTile(
                                title: Text(day),
                                children: timeTable[day]
                                    .asMap()
                                    .entries
                                    .map<Widget>(
                                      (hour) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0,
                                          vertical: 8.0,
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              (hour.key + 1).toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 16.0,
                                                  vertical: 8.0,
                                                ),
                                                child: DropdownButtonFormField(
                                                  onChanged: (value) => {
                                                    setState(
                                                      () {
                                                        timeTable[day]
                                                            [hour.key] = value;
                                                      },
                                                    )
                                                  },
                                                  value: timeTable[day]
                                                      [hour.key],
                                                  icon: Icon(Icons.expand_more),
                                                  items: (classes +
                                                          [
                                                            {'id': 'Free'}
                                                          ])
                                                      .map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                        (clss) =>
                                                            DropdownMenuItem<
                                                                String>(
                                                          value: clss['id'],
                                                          child: Text(
                                                            clss['id'] == "Free"
                                                                ? clss['id']
                                                                : clss['semester'] +
                                                                    clss[
                                                                        'section'] +
                                                                    ' - ' +
                                                                    clss[
                                                                        'subjectName'],
                                                          ),
                                                        ),
                                                      )
                                                      .toList(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
