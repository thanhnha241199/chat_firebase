import 'package:appchat/screens/screens.dart';
import 'package:appchat/services/services.dart';
import 'package:appchat/util/show_toast.dart';
import 'package:appchat/static_varibale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../constants.dart';

class SignInScreen extends StatefulWidget {
  static const id = 'sign_in_screen';

  const SignInScreen({Key? key}) : super(key: key);
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  String? _emailErrorText;
  String? _passwordErrorText;

  Map<String, dynamic> _validateForm() {
    // Reset validation state
    setState(() {
      _emailErrorText = null;
      _passwordErrorText = null;
    });

    bool isValid = true;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      if (email.isEmpty) {
        _emailErrorText = 'Please enter your email.';
        isValid = false;
      }
      if (password.isEmpty) {
        _passwordErrorText = 'Please enter your password.';
        isValid = false;
      }
    });

    return {
      'isValid': isValid,
      'email': email,
      'password': password,
    };
  }

  Future<void> _signIn() async {
    final formData = _validateForm();
    if (formData['isValid']) {
      try {
        EasyLoading.show();
        final user = await AuthService.signIn(
          email: formData['email'],
          password: formData['password'],
        );
        if (user != null) {
          StaticVariable.uid = user.uid;
          StaticVariable.email = user.email;
          EasyLoading.dismiss();
          ToastView.show('Login success!');
          Navigator.pushReplacementNamed(context, HomeScreen.id);
        }
      } catch (e) {
        EasyLoading.dismiss();
        EasyLoading.showToast(e.toString());
        setState(() {
          switch (e) {
            case 'ERROR_INVALID_EMAIL':
              _emailErrorText = 'Please enter a valid email.';
              break;
            case 'ERROR_USER_NOT_FOUND':
              _emailErrorText = 'User not found.';
              break;
            case 'ERROR_USER_DISABLED':
              _emailErrorText = 'This user has been disabled.';
              break;
            case 'WRONG_PASSWORD':
              _passwordErrorText = 'Wrong password';
              break;
            default:
              '';
          }
        });
      }
    }
  }

  Future _signUp() async {
    final result = await Navigator.pushNamed(context, SignUpScreen.id);
    if (result == 'true') {
      Navigator.pushReplacementNamed(context, HomeScreen.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "SIGN IN",
                style: Theme.of(context).textTheme.headline3,
              ),
              const SizedBox(height: 60),
              TextField(
                controller: _emailController,
                focusNode: _emailFocusNode,
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText: _emailErrorText,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) {
                  _emailFocusNode.unfocus();
                  _passwordFocusNode.requestFocus();
                },
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _passwordController,
                focusNode: _passwordFocusNode,
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: _passwordErrorText,
                  border: const OutlineInputBorder(),
                ),
                obscureText: true,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 12.0),
              MaterialButton(
                onPressed: _signIn,
                child: const Text('Sign in'),
                color: kPrimaryColor,
                textColor: Colors.white,
                padding: const EdgeInsets.all(16.0),
              ),
              const SizedBox(height: 24.0),
              const Text(
                'Or create account',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24.0),
              MaterialButton(
                onPressed: _signUp,
                child: const Text('Sign up'),
                color: kSecondaryColor,
                textColor: Colors.white,
                padding: const EdgeInsets.all(16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
