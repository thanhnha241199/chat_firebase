import 'package:appchat/screens/screens.dart';
import 'package:appchat/screens/widgets/widgets.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Route? onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case ChatScreen.id:
        final args = settings.arguments as Map;
        String _uid = args['uid'];
        String _name = args['name'];
        String _avatar = args['avatar'];
        return _materialRoute(ChatScreen(
          uid: _uid,
          name: _name,
          avatar: _avatar,
        ));
      case FullPhotoPage.id:
        final args = settings.arguments as Map;
        String _url = args['url'];

        return _materialRoute(FullPhotoPage(
          url: _url,
        ));
      case SignInScreen.id:
        return _materialRoute(const SignInScreen());
      case SignUpScreen.id:
        return _materialRoute(const SignUpScreen());
      case HomeScreen.id:
        return _materialRoute(const HomeScreen());
      case SplashScreen.id:
        return _materialRoute(const SplashScreen());
      case ProfileScreen.id:
        return _materialRoute(const ProfileScreen());
      default:
        return null;
    }
  }

  static List<Route> onGenerateInitialRoute() {
    return [_materialRoute(const SplashScreen())];
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute<String>(builder: (_) => view);
  }
}
