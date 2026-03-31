import 'package:flutter/material.dart';
import 'package:parku/screens/login/spalsh.dart';
import 'package:parku/utils/messages/show_message.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/api/userapi.dart';
import '../home/navigation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailC = TextEditingController();
  final passC = TextEditingController();

  bool loading = false;

  Color color = Colors.white;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 70),
              Center(
                child: Image.network(
                  "https://cdni.iconscout.com/illustration/premium/thumb/the-man-is-pointing-secure-login-illustration-svg-download-png-11562428.png",
                  width: w - 120,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  "Sign in to manage your Locations Daily CheckIn and Outs",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              smallVehicleField(controller: emailC, hintText: "Your Phone Number"),
              const SizedBox(height: 7),
              smallVehicleField(
                controller: passC,
                hintText: "Your Password",
                number: true,
              ),
              const SizedBox(height: 20),
              loading
                  ? Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        color: color,
                      ),
                    )
                  : InkWell(
                      onTap: () async {
                        try {
                          var res = await UserApiService.login(
                            phone: emailC.text,
                            password: passC.text,
                          );
                          print(res);
                          var user = res['user'];
                          print(user['name']);
                          if (user['name']
                              .toString()
                              .isNotEmpty) {
                            final SharedPreferences prefs = await SharedPreferences
                                .getInstance();
                            await prefs.setString('id', emailC.text);
                            await prefs.setString('password', passC.text);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>SplashScreen()));
                            Send.topic(
                                context, "Login Successful", res.toString(),
                                b: true);
                          } else {
                            Send.topic(context, "Error ! ", res.toString());
                          }
                        }catch(e){
                          Send.topic(context, "We hit an Error", "Wrong Password or Email Address. Or No Connection to Server");
                        }

                      },
                      child: contain(w, "Login"),
                    ),
              const SizedBox(height: 10),
              loading ? SizedBox() : Center(child: Text("OR")),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget smallVehicleField({
    required TextEditingController controller,
    required String hintText,
    number = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: number,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 18, color: Colors.grey.shade500),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 14,
        ),
        filled: true,
        fillColor: Colors.grey.shade100,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black, width: 1.5),
        ),
      ),
    );
  }

  Widget contain(double w, String str, {bool on = false}) {
    return Container(
      width: w,
      height: 55,
      decoration: BoxDecoration(
        color: Color(0xff014A8E),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            str,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          SizedBox(width: 5),
          on
              ? Icon(Icons.download_for_offline, color: Colors.white)
              : Icon(Icons.arrow_forward, color: Colors.white),
        ],
      ),
    );
  }
}
