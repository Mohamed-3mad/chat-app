import 'package:chatapp/services/auth_services.dart';
import 'package:chatapp/services/navigation_services.dart';
import 'package:chatapp/utils.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  await setup(); // إعداد الخدمات اللازمة قبل تشغيل التطبيق
  runApp(MyApp());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebase(); // إعداد Firebase (تعريفه داخل utils.dart)
  await registerServices(); // تسجيل الخدمات باستخدام GetIt
}

class MyApp extends StatelessWidget {
  MyApp({super.key}) {
    // استدعاء NavigationServices باستخدام GetIt
    _navigationServices = _getIt.get<NavigationServices>();
    _authServices = _getIt.get<AuthServices>();
  }

  final GetIt _getIt = GetIt.instance; // الحصول على نسخة من GetIt
  late final NavigationServices _navigationServices; // تعريف NavigationServices
  late final AuthServices _authServices;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigationServices
          .navigatorKey, // ربط navigatorKey من NavigationServices
      debugShowCheckedModeBanner: false, // إزالة شريط تصحيح الأخطاء
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.blue), // تخصيص ألوان التطبيق
        useMaterial3: true, // تفعيل واجهة Material 3
        textTheme:
            GoogleFonts.montserratTextTheme(), // استخدام خطوط Google Fonts
      ),
      initialRoute: _authServices.user != null
          ? "/home"
          : "/login", // المسار الافتراضي عند بدء التطبيق
      routes:
          _navigationServices.routes, // المسارات المعتمدة من NavigationServices
    );
  }
}
