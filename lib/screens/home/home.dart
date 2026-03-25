import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../../models/vehicle_model.dart';
import '../scan/scan.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<VehicleModel> list = [];
  List<VehicleModel> getVehicles() {
    final box = Hive.box<VehicleModel>('vehicles');

    return box.values.toList();
  }
  @override
  void initState(){
    super.initState();
    list=getVehicles();
    if (list.isEmpty){
      return ;
    }
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10,),
          container(w, Color(0xff0F5086),Color(0xff1A68B2),true),
          SizedBox(height: 15,),
          container(w, Color(0xffCF9720),Color(0xffA26D03),false),
          SizedBox(height: 25,),
          Row(
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
          SizedBox(height: 15,),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  VehicleModel vehicle = list[index];
                  return  Container(
                    width: w-20,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.grey.shade50,width: 0.1
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 17.0),
                      child: Row(
                        children: [
                          Container(
                            width: 55,height: 55,
                            decoration: BoxDecoration(
                                color: Colors.greenAccent.shade100,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Icon(Icons.verified,color: Colors.black,),
                          ),
                          SizedBox(width: 10,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(vehicle.carNumber,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 19),),
                              Text("Entry : ${formatSmartDateTime(vehicle.startDate)}",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 11),),
                              vehicle.nickname.isEmpty?SizedBox():Text("Nickname : ${vehicle.nickname} ",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 11),)
                            ],
                          ),
                          SizedBox(width: 10,),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ScanPage(),
          ),
        );
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
