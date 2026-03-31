import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:parku/screens/card/car_card.dart';
import 'package:parku/screens/miscelleous/make_exit.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/checkin_model.dart';
import '../../models/vehicle_model.dart';
import '../../utils/api/do_checkin.dart';
import '../scan/scan.dart';

class Home extends StatefulWidget {
  const Home({super.key,required this.onTabChange});
  final Function(int) onTabChange;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<CheckinModel> checkins = [];

  Future<void> loadTodayCheckins() async {
    try {
      print("Yes doing");
      DateTime now = DateTime.now();

      String formattedDate =
          "${now.year.toString().padLeft(4, '0')}-"
          "${now.month.toString().padLeft(2, '0')}-"
          "${now.day.toString().padLeft(2, '0')}";

      final response = await ApiService.getCheckinsByDate(formattedDate);

      List<CheckinModel> temp = response
          .map<CheckinModel>((e) => CheckinModel.fromJson(e))
          .toList();

      setState(() {
        working=false;
        checkins = temp;
        totalCount = checkins.length;
        outZeroCount = checkins.where((e) => e.outStatus == 0).length;
        remainingCount = totalCount - outZeroCount;

      });

    } catch (e) {
      setState(() {
        working=false;
        checkins = [];
      });
      print("ERROR: $e");
    }
  }
  int totalCount=0, outZeroCount=0,remainingCount=0;
  bool working = true;
  @override
  void initState() {
    super.initState();
    loadTodayCheckins();
  }
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              con(w, totalCount, "Entry", Icon(Icons.add,color: Colors.blue,size: 25,),),
              con(w, outZeroCount, "Exit", Icon(Icons.logout,color: Colors.red,size: 25,),),
              con(w, remainingCount, "Live", Icon(Icons.access_time_filled,color: Colors.orange,size: 25,),),
            ],
          ),
          SizedBox(height: 10,),
          container(w, Color(0xff0F5086),Color(0xff1A68B2),true),
          SizedBox(height: 15,),
          container(w, Color(0xffCF9720),Color(0xffA26D03),false),
          SizedBox(height: 25,),
          InkWell(
            onTap: (){
              widget.onTabChange(1);
            },
            child: Row(
              children: [
                SizedBox(width: 10,),
                Icon(Icons.refresh_sharp,color: Colors.white,size: 30,),
                SizedBox(width: 4,),
                Text("Recent Activities",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900),),
                Spacer(),
                Text("See All",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900),),
                Icon(Icons.arrow_forward_outlined,color: Colors.white,size: 22,),
                SizedBox(width: 20,),
              ],
            ),
          ),
          SizedBox(height: 15,),
          working?Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Shimmer.fromColors(
                        child: Container(
                            width: w-20,
                            height: 100,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Colors.grey.shade50,width: 0.1
                            ),
                          ),
                        ), baseColor: Color(0xff121622), highlightColor: Colors.grey),
                  );
                },
              ),
            ),
          ):Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView.builder(
                itemCount: checkins.length,
                itemBuilder: (BuildContext context, int index) {
                  CheckinModel vehicle = checkins[index];
                  return CarCard(vehicle: vehicle);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
  Widget con(double w, int i, String str, Icon icon)=>Container(
    width: w/4+12,
    height:120,
    decoration: BoxDecoration(
        border: Border.all(
            color: Color(0xff0F5086),
            width: 3
        ),
        color: Colors.black,
        borderRadius: BorderRadius.circular(15)
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon,
        SizedBox(height: 10,),
        Text("$i",style: TextStyle(color: Colors.white,fontSize: 23,fontWeight: FontWeight.w700),),
        Text("$str",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w800),),
      ],
    ),
  );

  String formatSmartDateTime(DateTime dateTime) {
    final now = DateTime.now();

    final isToday =
        dateTime.year == now.year &&
            dateTime.month == now.month &&
            dateTime.day == now.day;

    if (isToday) {
      // Example: 3:00 PM
      return DateFormat('h:mm a').format(dateTime);
    } else {
      // Example: 3:00 PM on 21 Jan, 2026
      return "${DateFormat('h:mm a').format(dateTime)} on ${DateFormat('d MMM, yyyy').format(dateTime)}";
    }
  }

  Widget container(double w, Color color,Color color1, bool yes )=>Center(
    child: InkWell(
      onTap: (){
        if(yes){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ScanPage(),
            ),
          );
        }else{
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MakeExit(),
            ),
          );
        }

      },
      child: Container(
        width: w-25,
        height: 90,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color, color1]),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black54, // The color of the shadow
              blurRadius: 20,       // The extent of the blur
              offset: Offset(5, 10), // The X and Y offset of the shadow
              spreadRadius: 0.1,    // Optional: inflates/deflates the box size before blur
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(5)
              ),
              child: Padding(
                padding: const EdgeInsets.all(9.0),
                child:yes? Icon(Icons.camera_alt,size: 25,color: Colors.white,):Icon(Icons.exit_to_app,size: 25,color: Colors.white,),
              ),
            ),
            SizedBox(width: 10,),
            Text(yes?"ENTRY":"EXIT",style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900,fontSize: 20),)
          ],
        ),
      ),
    ),
  );

}
