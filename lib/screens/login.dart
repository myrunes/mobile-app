import 'package:app/api/api.dart';
import 'package:app/api/forms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginBody extends StatelessWidget {
  LoginBody(this.api);

  final API api;
  final _formKey = GlobalKey<FormState>();
  final _loginFormData = LoginFormModel();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'LOGIN',
              style: TextStyle(
                fontSize: 32,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Username',
                    ),
                    validator: (val) =>
                        val.length > 0 ? null : 'Invalid username',
                    onSaved: (val) => _loginFormData.username = val,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                    ),
                    validator: (val) =>
                        val.length > 0 ? null : 'Invalid password',
                    onSaved: (val) => _loginFormData.password = val,
                  ),
                ],
              ),
            ),
            RaisedButton(
              child: Text('LOGIN'),
              onPressed: () {
                final FormState state = _formKey.currentState;
                state.save();
                api.login(_loginFormData).then((_) {
                  Navigator.pushReplacementNamed(context, '/');
                }, onError: (err) {
                  var errTxt = 'An unknown error occured';
                  if (err is APIError) {
                    errTxt = err.statusCode == 401
                        ? 'Invalid username or password.'
                        : 'Login failed: ${err.reason}';
                  } else {
                    errTxt = err.toString();
                    print(err);
                  }
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(errTxt),
                    backgroundColor: Colors.red,
                  ));
                });
              },
            )
          ],
        ),
      ),
    )));
  }
}

class LoginPage extends StatelessWidget {
  LoginPage(this.apiInstance);

  final API apiInstance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginBody(apiInstance),
    );
  }
}
