import 'package:flutter/material.dart';
import 'package:pyshop_camera/config/dependency_injection.dart';
import 'package:pyshop_camera/resources/strings.dart';
import 'package:pyshop_camera/resources/theme.dart';
import 'package:pyshop_camera/widgets/home_page.dart';

void main() {
  configureDependencyInjection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.appName,
      theme: theme,
      home: const HomePage(title: Strings.appName),
    );
  }
}
