import 'package:flutter/material.dart';

class FullPic extends StatelessWidget {
  final String pic;
  const FullPic({super.key,required this.pic});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Full Pic Taken"),
      ),
      body: Center(
        child: Image.network(
          pic, width: w,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
