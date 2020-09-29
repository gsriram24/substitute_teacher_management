import 'package:flutter/material.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/mailer.dart';
import 'package:substitute_teacher_management/screens/edit_faculty_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:substitute_teacher_management/screens/substitute_faculty_screen.dart';
import '../../email_credentials.dart';

class FacultyTile extends StatefulWidget {
  final dynamic faculty;
  final bool isHomeScreen;
  final bool isSubstituteScreen;
  final int numFreeHrs;
  final scaffoldKey;
  final int hour;
  final String cls;
  FacultyTile(this.faculty,
      {this.scaffoldKey,
      this.isHomeScreen = false,
      this.isSubstituteScreen = false,
      this.numFreeHrs = 0,
      this.hour,
      this.cls});

  @override
  _FacultyTileState createState() => _FacultyTileState();
}

class _FacultyTileState extends State<FacultyTile> {
  var _isLoading = false;

  final successSnackBar =
      SnackBar(content: Text('Message sent!', textAlign: TextAlign.center));

  final failSnackBar = SnackBar(
      content: Text('Error sending message!', textAlign: TextAlign.center));

  Future<void> _sendEmail() async {
    setState(() {
      _isLoading = true;
    });
    final smtpServer = gmail(username, password);

    // Create our message.
    final message = Message()
      ..from = Address(username, 'Admin')
      ..recipients.add(widget.faculty['email'])
      ..subject = 'Substitution class for ${widget.cls}'
      ..html =
          "<h1>New Substitution Class Allotted</h1>\n<p>Class: ${widget.cls}</p>\n<p>Hour: ${widget.hour + 1}</p>";

    try {
      final sendReport = await send(message, smtpServer);
      setState(() {
        _isLoading = false;
      });
      widget.scaffoldKey.currentState.showSnackBar(successSnackBar);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e);
      widget.scaffoldKey.currentState.showSnackBar(failSnackBar);
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return Container(
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListTile(
              onTap: widget.isHomeScreen
                  ? () {
                      Navigator.of(context).pushNamed(
                        SubstituteFacultyScreen.routeName,
                        arguments: widget.faculty,
                      );
                    }
                  : null,
              title: Text(widget.faculty['fullName']),
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(widget.faculty['empId']),
              ),
              subtitle: widget.isSubstituteScreen
                  ? Text(
                      'Free hours today: ${widget.numFreeHrs}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : null,
              trailing: widget.isHomeScreen
                  ? null
                  : widget.isSubstituteScreen
                      ? IconButton(
                          icon: Icon(Icons.email),
                          onPressed: () async {
                            await _sendEmail();
                          },
                          color: Theme.of(context).errorColor,
                        )
                      : Container(
                          width: 100,
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                      EditFacultyScreen.routeName,
                                      arguments: widget.faculty);
                                },
                                color: Theme.of(context).primaryColor,
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  try {
                                    FirebaseFirestore.instance
                                        .collection('faculties')
                                        .doc(widget.faculty['empId'])
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
