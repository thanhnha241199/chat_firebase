import 'package:appchat/screens/home_screen.dart';
import 'package:appchat/screens/sign_in_screen.dart';
import 'package:appchat/services/auth_service.dart';
import 'package:appchat/static_varibale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const id = 'splash_screen';

  const SplashScreen({Key? key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      _checkSession();
    });
    super.initState();
  }

  Future _checkSession() async {
    final user = await AuthService.currentUser();
    StaticVariable.uid = user?.uid;
    StaticVariable.email = user?.email;
    StaticVariable.avatar = user?.photoURL;
    if (user != null) {
      Navigator.pushReplacementNamed(context, HomeScreen.id);
    } else {
      Navigator.pushReplacementNamed(context, SignInScreen.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CupertinoActivityIndicator(
          radius: 20,
        ),
      ),
    );
  }
}
