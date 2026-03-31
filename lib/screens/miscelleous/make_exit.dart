import 'package:flutter/material.dart';

import '../home/analytics.dart' show Analytics;

class MakeExit extends StatelessWidget {
  const MakeExit({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Car to Exit "),
      ),
      body: Analytics(),
    );
  }
}
