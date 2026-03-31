


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parku/models/usermodel.dart';
import 'package:parku/screens/home/analytics.dart';
import 'package:parku/screens/home/profile.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'home.dart';
class HomePage extends StatefulWidget {
  final UserModel user;
  const HomePage({super.key,required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {



  Future<void> requestPermissions() async {

    if (!await Permission.camera.isGranted) {
      await Permission.camera.request();
    }

    if (!await Permission.photos.isGranted) {
      await Permission.photos.request();
    }

    if (!await Permission.notification.isGranted) {
      await Permission.notification.request();
    }
  }

  @override
  void initState() {

    super.initState();
  }
  bool timeout = false;
  int index = 0;

  void changeTab(int newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              title: const Text("Close the App ?"),
              content: const Text("You sure to Close the App"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.red),
                  ),
                  onPressed: () async {
                    Navigator.pop(context, true);
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
        return shouldExit ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyActions: false,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          title : Image.asset("assets/ast.jpeg",height: 40,),
          actions: [
            InkWell(
              onTap: () async {
                final Uri _url = Uri.parse('https://wa.me/919533286038');
                if (!await launchUrl(_url)) {
                  throw Exception('Could not launch $_url');
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.white
                    ),
                    shape: BoxShape.circle
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(Icons.support_agent,color: Colors.white,size: 22,),
                ),
              ),
            ),
            SizedBox(width: 8,),
            InkWell(
              onTap: (){
                changeTab(2);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white
                  ),
                  shape: BoxShape.circle
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(Icons.person,color: Colors.white,size: 22,),
                ),
              ),
            ),
            SizedBox(width: 10,)
          ],
        ),
        backgroundColor: Colors.black,
        body: returnw(),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.white,
          currentIndex: index,
          onTap: (i) {
            setState(() {
              index = i;
            });
          },

          type: BottomNavigationBarType.fixed,

          items: const [

            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.analytics),
              label: "Analytics",
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
      return  Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text("Loading....."),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: w,
                    height: MediaQuery.of(context).size.height/3-30,
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: ListView.builder(
                  itemCount: 6,
                  itemBuilder: (_, __) => Center(
                    child: Padding(
                      padding: const EdgeInsets.only( top: 5),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          width: w - 20,
                          height: MediaQuery.of(context).size.height/6-30,
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
      );
  }

  Widget returnw(){
    if(index ==0){
      return Home(onTabChange: changeTab);
    }else if (index==1){
      return Analytics();
    }else {
      return Profile(onTabChange: changeTab);
    }
  }

  String times(int str){
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm')
        .format(DateTime.fromMillisecondsSinceEpoch(str));
    return formattedDate;
  }
  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
  String time(int str){
    final formattedDate = DateFormat('yyyy-MM-dd')
        .format(DateTime.fromMillisecondsSinceEpoch(str));
    return formattedDate;
  }
  Widget t(String str)=>Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 15),
    child: Text(str,style: TextStyle(
        fontWeight: FontWeight.w900,fontSize: 19
    ),),
  );
  Widget tabcircle(Widget c,String launch)=>CircleAvatar(
    radius: 23,
    backgroundColor: Colors.grey.shade200,
    child: Center(child: c,),
  );
}