import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:substitute_teacher_management/widgets/auth/auth_form.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  void _submitAuthForm(
    String email,
    String password,
    BuildContext ctx,
  ) async {
    var authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on PlatformException catch (err) {
      var message = 'An Error occurred, please recheck your credentials!';
      if (err.message != null) {
        message = err.message;
      }
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
