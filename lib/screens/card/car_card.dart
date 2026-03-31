import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/checkin_model.dart';
import 'car_card_full.dart';

class CarCard extends StatelessWidget {
  final CheckinModel vehicle;
  const CarCard({super.key,required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final bool given = vehicle.outStatus==0;
    double w = MediaQuery.of(context).size.width;
    return  InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_)=>CarCardFull(vehicle: vehicle,)));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6.0),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17.0),
            child: Row(
              children: [
                Container(
                  width: 55,height: 55,
                  decoration: BoxDecoration(
                      color: given?Colors.red:Colors.greenAccent.shade100,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: given?Icon(Icons.local_car_wash,color: Colors.white,):Icon(Icons.verified,color: Colors.black,),
                ),
                SizedBox(width: 10,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(vehicle.carnumber,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 19),),
                    Text("Entry : ${formatSmartDateTime(vehicle.starttime)}",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 11),),
                    given?                    Text("Nickname : ${vehicle.name} ",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 11),) :Text("Exit : ${formatSmartDateTime(vehicle.endtime)}",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 11),),

                  ],
                ),
                SizedBox(width: 10,),
              ],
            ),
          ),
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
