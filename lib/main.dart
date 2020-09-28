import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:substitute_teacher_management/screens/auth_screen.dart';
import 'package:substitute_teacher_management/screens/edit_faculty_screen.dart';
import 'package:substitute_teacher_management/screens/faculty_management_screen.dart';
import 'package:substitute_teacher_management/screens/home_screen.dart';
import 'package:substitute_teacher_management/screens/substitute_faculty_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        backgroundColor: Colors.deepPurple,
        accentColor: Colors.amber,
        accentColorBrightness: Brightness.dark,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.deepPurple,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshot) {
          if (userSnapshot.hasData) {
            return HomeScreen();
          }
          return AuthScreen();
        },
      ),
      routes: {
        FacultyManagementScreen.routeName: (_) => FacultyManagementScreen(),
        EditFacultyScreen.routeName: (_) => EditFacultyScreen(),
        SubstituteFacultyScreen.routeName: (_) => SubstituteFacultyScreen(),
      },
    );
  }
}
