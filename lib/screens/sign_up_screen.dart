import 'package:appchat/constants.dart';
import 'package:appchat/services/services.dart';
import 'package:appchat/util/show_toast.dart';
import 'package:appchat/static_varibale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SignUpScreen extends StatefulWidget {
  static const id = 'sign_up_screen';

  const SignUpScreen({Key? key}) : super(key: key);
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _displayNameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  String? _emailErrorText;
  String? _displayNameErrorText;
  String? _passwordErrorText;
  String? _confirmPasswordErrorText;

  Map<String, dynamic> _validateForm() {
    // Reset validation state
    setState(() {
      _emailErrorText = null;
      _displayNameErrorText = null;
      _passwordErrorText = null;
      _confirmPasswordErrorText = null;
    });

    bool isValid = true;

    final email = _emailController.text.trim();
    final displayName = _displayNameController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    setState(() {
      if (email.isEmpty) {
        _emailErrorText = 'Please enter your email.';
        isValid = false;
      }
      if (displayName.isEmpty) {
        _displayNameErrorText = 'Please enter display name';
        isValid = false;
      }
      if (password.isEmpty) {
        _passwordErrorText = 'Please enter your password.';
        isValid = false;
      }
      if (password != confirmPassword) {
        _confirmPasswordErrorText = 'Password does not match.';
        isValid = false;
      }
    });

    return {
      'isValid': isValid,
      'email': email,
      'displayName': displayName,
      'password': password,
    };
  }

  Future _signUp() async {
    final formData = _validateForm();
    if (formData['isValid']) {
      try {
        EasyLoading.show();
        final user = await AuthService.signUp(
          email: formData['email'],
          displayName: formData['displayName'],
          password: formData['password'],
        );
        if (user != null) {
          final email = _emailController.text.trim();
          final name = _displayNameController.text.trim();
          await UserService.addUser(
            uid: user.uid,
            email: email,
            name: name,
          );
          EasyLoading.dismiss();
          StaticVariable.uid = user.uid;
          StaticVariable.email = user.email;
          ToastView.show("Sign up success");
          Navigator.pop(context, 'true');
        }
      } catch (e) {
        EasyLoading.dismiss();

        setState(() {
          switch (e) {
            case 'ERROR_INVALID_EMAIL':
              _emailErrorText = 'Please enter a valid email.';
              ToastView.show(_emailErrorText ?? '');
              break;
            case 'ERROR_EMAIL_ALREADY_IN_USE':
              _emailErrorText = 'Email already in use.';
              ToastView.show(_emailErrorText ?? '');
              break;
            default:
              _emailErrorText = 'An error occurred.';
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                      _displayNameFocusNode.requestFocus();
                    },
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: _displayNameController,
                    focusNode: _displayNameFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Display name',
                      errorText: _displayNameErrorText,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) {
                      _displayNameFocusNode.unfocus();
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
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) {
                      _passwordFocusNode.unfocus();
                      _confirmPasswordFocusNode.requestFocus();
                    },
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: _confirmPasswordController,
                    focusNode: _confirmPasswordFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Confirm password',
                      errorText: _confirmPasswordErrorText,
                      border: const OutlineInputBorder(),
                    ),
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 30),
                  MaterialButton(
                    onPressed: _signUp,
                    child: const Text('Sign up'),
                    color: kPrimaryColor,
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 10,
            child: SafeArea(
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: kPrimaryColor,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
