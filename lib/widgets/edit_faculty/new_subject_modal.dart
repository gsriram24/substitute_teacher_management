import 'package:flutter/material.dart';

class NewSubjectModal extends StatefulWidget {
  final Function addSubject;
  NewSubjectModal(this.addSubject);
  @override
  _NewSubjectModalState createState() => _NewSubjectModalState();
}

class _NewSubjectModalState extends State<NewSubjectModal> {
  var _formKey = GlobalKey<FormState>();
  var subjectName;
  var abbr;
  var semester = '1';
  var branch = 'CSE';
  var section = 'A';

  void _submitData() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      widget.addSubject(branch, semester, section, subjectName, abbr);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Text('Branch'),
                    const SizedBox(
                      width: 25,
                    ),
                    Container(
                      width: 75,
                      child: DropdownButtonFormField(
                        value: branch,
                        icon: Icon(Icons.expand_more),
                        items: ['CSE', 'IT', 'ME', 'ECE', 'CE']
                            .map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                            ),
                          );
                        }).toList(),
                        onChanged: (String newValue) {
                          setState(() {
                            branch = newValue;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Semester'),
                        const SizedBox(
                          width: 25,
                        ),
                        Container(
                          width: 50,
                          child: DropdownButtonFormField(
                            value: semester,
                            icon: Icon(Icons.expand_more),
                            items: Iterable<int>.generate(8)
                                .map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem<String>(
                                value: (value + 1).toString(),
                                child: Text(
                                  (value + 1).toString(),
                                ),
                              );
                            }).toList(),
                            onChanged: (String newValue) {
                              setState(() {
                                semester = newValue;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    Container(
                      child: Row(
                        children: [
                          Text('Section'),
                          const SizedBox(
                            width: 25,
                          ),
                          Container(
                            width: 50,
                            child: DropdownButtonFormField(
                              value: section,
                              icon: Icon(Icons.expand_more),
                              items: ['A', 'B', 'C', 'D', 'E']
                                  .map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                  ),
                                );
                              }).toList(),
                              onChanged: (String newValue) {
                                setState(() {
                                  section = newValue;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25.0,
                ),
                TextFormField(
                  onChanged: (value) {
                    subjectName = value;
                  },
                  key: ValueKey('subjectName'),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Subject Name',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please Enter the Subject Name!';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 25.0,
                ),
                TextFormField(
                  onChanged: (value) {
                    abbr = value;
                  },
                  key: ValueKey('abbr'),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Abbreviation',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please Enter the Abbreviation!';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 25.0,
                ),
                RaisedButton(
                  child: Text(
                    'Add Subject',
                  ),
                  onPressed: _submitData,
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
