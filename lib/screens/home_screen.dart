import 'package:flutter/material.dart';
import 'package:substitute_teacher_management/widgets/home/drawer.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome Admin!'),
      ),
      drawer: AppDrawer(),
    );
  }
}
