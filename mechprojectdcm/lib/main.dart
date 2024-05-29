import 'package:flutter/material.dart';
import 'package:mechprojectdcm/firebase_options.dart';
import 'package:mechprojectdcm/screens/bottom_bar.dart';
import 'package:mechprojectdcm/utils/app_styles.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:
          'Mechatronics Semester Project Sem 2 - DC Motor Measuring Test Stand',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 100, 88, 208)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'MSP DC Motor Measurement App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Motor Test Stand SPRO2',
      theme: ThemeData(
        primaryColor: primary,
      ),
      debugShowCheckedModeBanner: false,
      home: const BottomBar(),
    );
  }
}
