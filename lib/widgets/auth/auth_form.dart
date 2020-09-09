import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading);
  final void Function(String email, String password, BuildContext ctx) submitFn;
  final bool isLoading;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _userEmail;
  String _userPassword;

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'Login',
          style: Theme.of(context).textTheme.headline3.copyWith(
                color: Colors.white,
              ),
        ),
        Card(
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 40,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    onChanged: (value) {
                      _userEmail = value;
                    },
                    key: ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                    validator: (value) {
                      Pattern pattern =
                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                      RegExp regex = new RegExp(pattern);

                      if (value.isEmpty) {
                        return 'Please Enter your Email ID';
                      }
                      if (!regex.hasMatch(value)) {
                        return 'Enter a valid Email ID.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      _userPassword = value;
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.vpn_key),
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  RaisedButton(
                    child: Text('Login'),
                    onPressed: _trySubmit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
