
import 'package:flutter/material.dart';
import 'package:parku/screens/login/bloc/current.dart';
import 'package:parku/screens/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/usermodel.dart';
import '../../utils/api/userapi.dart';
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
    login();
  }
  void navigate(){
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()));
    });
  }
  Future<void> login() async {
    try {
      final SharedPreferences prefs = await SharedPreferences
          .getInstance();
      String id = await prefs.getString('id',) ?? "NA";
      String pass = await prefs.getString('password') ?? "NA";
      print(pass);
      var res = await UserApiService.login(
        phone: id,
        password: pass,
      );
      var user = UserModel.fromJson(res['user']);
      Current.user = user ;
      print(Current.user.name);
      print("-------->");
      if (user!=null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomePage(user: user,)));
        return ;
      }
      print("else----->");
      navigate();

    }catch(e){
      print(e);
      navigate();
    }
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
