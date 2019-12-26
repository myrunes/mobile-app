import 'package:app/api/api.dart';
import 'package:app/api/models.dart';
import 'package:app/models/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginBody extends StatelessWidget {
  final LoginModel loginState;
  final API api;

  LoginBody(this.loginState, this.api);

  final _formKey = GlobalKey<FormState>();
  final _loginFormData = LoginFormModel();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('LOGIN', style: TextStyle(
                fontSize: 32,
              ),),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Username',
                ),
                validator: (val) => val.length > 0 ? null : 'Invalid username',
                onSaved: (val) => _loginFormData.username = val,
              ),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
                validator: (val) => val.length > 0 ? null : 'Invalid password',
                onSaved: (val) => _loginFormData.password = val,
              ),
              RaisedButton(
                child: Text('LOGIN'),
                onPressed: () {
                  final FormState state = _formKey.currentState;
                  state.save();
                  api.login(_loginFormData).then((res) {
                    print(res);
                  }, onError: (err) {
                    var errTxt = 'An unknown error occured';
                    if (err is APIError) {
                      errTxt = err.statusCode == 401 ? 
                          'Invalid username or password.' : 
                          'Login failed: ${err.reason}';
                    } else {
                      errTxt = (err as Exception).toString();
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
        )
      )
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginState = Provider.of<LoginModel>(context);
    final api = Provider.of<API>(context);

    return Scaffold(
      body: LoginBody(loginState, api),
    );
  }
}