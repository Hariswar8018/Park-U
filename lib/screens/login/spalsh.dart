
import 'package:flutter/material.dart';

import '../home/navigation.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()));
      });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: Image.asset("assets/ast.jpeg",width: MediaQuery.of(context).size.width/2+100,)
      ),
    );
  }
}
