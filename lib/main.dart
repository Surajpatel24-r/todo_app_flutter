import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard.dart';
import 'login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(
    token: prefs.getString('token'),
  ));
}

class MyApp extends StatelessWidget {
  final token;
  const MyApp({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Task Upload",
          theme: ThemeData(
            primaryColor: Colors.black,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          // home: (token != null && JwtDecoder.isExpired(token) == false)
          //     ? Dashboard(token: token)
          //     : LoginScreen());
          home: LoginScreen(),
        );
      },
    );
  }
}
