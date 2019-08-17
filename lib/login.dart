import 'package:klassmind/attendance_sheet.dart';
import 'package:flutter/material.dart';
import 'package:klassmind/user_repository.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _email;
  TextEditingController _password;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: "");
    _password = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    return Scaffold(
      key: _key,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            children: [
              SizedBox(height: 100),
              Text(
                'KlassMind',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 100),
              TextFormField(
                controller: _email,
                decoration: InputDecoration(
                    labelText: 'Username',
                    filled: true,
                    border: OutlineInputBorder()),
                validator: (value) =>
                    (value.isEmpty) ? "Please Enter Email" : null,
              ),
              SizedBox(height: 20.0),
              TextFormField(
                obscureText: true,
                controller: _password,
                validator: (value) =>
                    (value.isEmpty) ? "Please Enter Password" : null,
                decoration: InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    border: OutlineInputBorder()),
              ),
              ButtonBar(
                children: <Widget>[
                  user.status == Status.Authenticating
                      ? FlatButton(
                          color: Theme.of(context).buttonColor,
                          child: CircularProgressIndicator(),
                          onPressed: () {},
                        )
                      : FlatButton(
                          color: Theme.of(context).buttonColor,
                          child: Text('Login'),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              final result = await user.signIn(
                                  _email.text, _password.text);
                              if (!result['success']) {
                                _key.currentState.showSnackBar(
                                  SnackBar(
                                    content: Text(result['error']),
                                  ),
                                );
                              } else {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        AttendanceSheet()));
                              }
                            }
                          },
                        )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
