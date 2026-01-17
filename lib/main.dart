import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'screens/account_screen.dart';
import 'screens/login_screen.dart';
//import 'screens/account_screen.dart';


void main() => runApp(DevicePreview(builder: (context) => MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Auth UI',
      theme: ThemeData(
        textTheme: Typography.blackCupertino,
        primaryColor: Colors.blueAccent,
      ),
      home: const LoginScreen(),
   //   home: const AccountScreen(),
    );
  }
}
