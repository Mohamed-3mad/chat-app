import 'package:chatapp/screens/home/home_screen.dart';
import 'package:chatapp/screens/login/login_screen.dart';
import 'package:chatapp/screens/register/register_screen.dart';
import 'package:flutter/material.dart';

class NavigationServices {
  // تعريف المفتاح مباشرة دون الحاجة إلى late
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  // خريطة تحتوي على المسارات
  final Map<String, Widget Function(BuildContext)> _routes = {
    "/login": (context) => const LoginScreen(),
    "/register": (context) => const RegisterScreen(),
    "/home": (context) => const HomeScreen(),
  };

  // Getter للوصول إلى المفتاح
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  // Getter للوصول إلى المسارات
  Map<String, Widget Function(BuildContext)> get routes => _routes;

    void push(MaterialPageRoute route) {
    _navigatorKey.currentState!.push(route);
  }

  // التنقل إلى صفحة جديدة
  void pushNamed(String routeName) {
    _navigatorKey.currentState!.pushNamed(routeName);
  }

  // استبدال الصفحة الحالية بصفحة جديدة
  void pushReplacementNamed(String routeName) {
    _navigatorKey.currentState!.pushReplacementNamed(routeName);
  }

  // الرجوع إلى الصفحة السابقة
  void goBack() {
    _navigatorKey.currentState!.pop();
  }

  // إضافة مسار جديد أثناء تشغيل التطبيق
  void defineRoute(String routeName, Widget Function(BuildContext) builder) {
    _routes[routeName] = builder;
  }
}
