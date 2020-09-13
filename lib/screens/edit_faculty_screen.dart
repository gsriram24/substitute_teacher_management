import 'package:flutter/material.dart';
import 'package:substitute_teacher_management/widgets/edit_faculty/new_subject_modal.dart';
import 'package:substitute_teacher_management/widgets/edit_faculty/subject_tile.dart';

class EditFacultyScreen extends StatefulWidget {
  static const routeName = '/edit-faculty';

  @override
  _EditFacultyScreenState createState() => _EditFacultyScreenState();
}

class _EditFacultyScreenState extends State<EditFacultyScreen> {
  var _initValues = {
    'fullName': '',
    'classes': [],
    'email': '',
    'timeTable': {},
  };
  List classes;
  var _isInit = true;
  var _isLoading = false;
  void didChangeDependencies() {
    if (_isInit) {
      final faculty = ModalRoute.of(context).settings.arguments as Map;
      print(faculty);
      if (faculty != null) {
        _initValues = faculty;
        classes = _initValues['classes'];
      }
    }
    _isInit = false;
    super.didChangeDependencies();
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
    print(subjectInitials);
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
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text('Edit Faculty'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: () {}),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
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
                              onChanged: (value) {},
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
                              onChanged: (value) {},
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
                              onChanged: (value) {},
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
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (ctx, i) {
                            return SubjectTile(classes[i], deleteSubject);
                          },
                          itemCount: classes.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
