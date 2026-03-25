import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../../models/vehicle_model.dart';

class Analytics extends StatefulWidget {
  const Analytics({super.key});

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
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
}
