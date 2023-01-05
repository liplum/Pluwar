import 'package:flutter/material.dart';
import 'package:pluwar/ui/login/login.dart';
import 'package:pluwar/ui/login/register.dart';
import 'package:pluwar/ui/main/menu.dart';

typedef RouteGenerator = Widget Function(String name, Object? args);

class Routes {
  static const login = "/login";
  static const register = "/register";
  static const mainMenu = "/mainMenu";
  static final Map<String, RouteGenerator> name2Generator = {
    login: (name, _) => const LoginPage(),
    register: (name, _) => const RegisterPage(),
    mainMenu: (name, _) => const MainMenuPage(),
  };

  static Route<dynamic>? onGenerate(String? name, Object? arguments) {
    if (name == null) {
      return onUnknown(name, arguments);
    }
    final generator = name2Generator[name];
    if (generator != null) {
      return MaterialPageRoute(builder: (_) => generator(name, arguments));
    } else {
      return onUnknown(name, arguments);
    }
  }

  static Route<dynamic>? onUnknown(String? name, Object? arguments) {
    return MaterialPageRoute(builder: (_) => const _404Page());
  }
}

// ignore: camel_case_types
class _404Page extends StatelessWidget {
  const _404Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
