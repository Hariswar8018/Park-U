import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 25,),
          Center(
            child: CircleAvatar(
              radius: 68,
              backgroundColor: Colors.grey.shade300,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: CircleAvatar(
                  radius: 65,
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.grey.shade300,
                      child: Center(child: Icon(Icons.person,color: Colors.black,size: 60,),),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 25,),
          Text("Ayusman Samasi",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 19),),
          Text("hariswarsamasi@gmail.com",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w400,),),
          SizedBox(height: 10,),
          SizedBox(height: 30,),
          Container(
            width: w-25,
            height: (220/3)*5,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4), // shadow downwards
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                    onTap: (){

                    },
                    child: list(Icon(Icons.person_pin_sharp, color:Colors.black,size: 25,), "Edit Profile", "about")),
                InkWell(
                    onTap: (){
                    },
                    child: list(Icon(Icons.list_alt, color:Colors.black,size: 25,), "History", "terms")),
                InkWell(
                    onTap: (){

                    },
                    child: list(Icon(Icons.qr_code_scanner, color:Colors.black,size: 25,), "Scan Car", "about")),
                InkWell(
                    onTap: () async {

                    },
                    child: list(Icon(Icons.support_agent_outlined, color:Colors.black,size: 25,), "Help & Support", "terms")),
                InkWell(
                    onTap: (){
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0), // Rectangle (no rounded edges)
                            ),
                            title: const Text("Log out ?"),
                            content: const Text("You sure to Log out from the App"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false), // Cancel
                                child: const Text("Cancel"),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  Navigator.pop(context);

                                },
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.resolveWith(
                                        (states) => Colors.red,   // your color here
                                  ),
                                ),
                                child: const Text("OK",style: TextStyle(color: Colors.white)),
                              )
                            ],
                          );
                        },
                      );
                    },
                    child: list(Icon(Icons.login, color:Colors.red,size: 25,), "Log Out", "logout")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget list(Widget icon, String str, String navigate)=>ListTile(
    leading: Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10)
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: icon,
        )),
    title: Text(str,style: TextStyle(fontWeight: FontWeight.w700),),
    trailing: Icon(Icons.arrow_forward,color: Colors.grey,),
  );
}