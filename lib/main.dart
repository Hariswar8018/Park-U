import 'package:flutter/material.dart';
import 'package:hive/hive.dart' show Hive;
import 'package:parku/screens/login/spalsh.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/vehicle_model.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(VehicleModelAdapter());

  await Hive.openBox<VehicleModel>('vehicles');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Park U',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xff121622),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 21
          ),
        ),
        scaffoldBackgroundColor: Color(0xff121622),
        colorScheme: .fromSeed(seedColor: Colors.white),
      ),
      home: SplashScreen(),
    );
  }
}

