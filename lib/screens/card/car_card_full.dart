import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parku/utils/api/do_checkin.dart';

import '../../models/checkin_model.dart' show CheckinModel;
import '../miscelleous/full_pic.dart';

class CarCardFull extends StatefulWidget {
  final CheckinModel vehicle;
  const CarCardFull({super.key,required this.vehicle});

  @override
  State<CarCardFull> createState() => _CarCardFullState();
}

class _CarCardFullState extends State<CarCardFull> {

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

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Car Full Option"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>FullPic(pic: widget.vehicle.pic,)));
              },
              child: Center(
                child: Image.network(
                  widget.vehicle.pic,
                  height: h/3,width: w-20,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 15,),
            Text("Car Number",
              style: TextStyle(fontWeight: FontWeight.w500,fontSize: 19,color: Colors.grey),),
            Text(widget.vehicle.carnumber,
              style: TextStyle(fontWeight: FontWeight.w900,fontSize: 29,color: Colors.white),),
            SizedBox(height: 25,),
            Container(
              width: w-25,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade200
                ),
                borderRadius: BorderRadius.circular(5)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 19.0,horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    row("CheckIn Time", formatSmartDateTime(widget.vehicle.starttime)),
                    widget.vehicle.outStatus==0?
                    Row(
                      children: [
                        Text("CheckOut Time",style: TextStyle(fontWeight: FontWeight.w900,color: Colors.white,fontSize: 17)),
                        Spacer(),
                        FlickerText(),
                      ],
                    ):
                    row("CheckOut Time", formatSmartDateTime(widget.vehicle.endtime))
                  ],
                ),
              ),
            ),
            SizedBox(height: 25,),
            Container(
              width: w-25,
              height: 180,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.grey.shade200
                  ),
                  borderRadius: BorderRadius.circular(5)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 19.0,horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    row("Car Number", widget.vehicle.carnumber),
                    row("NickName", widget.vehicle.name),
                    row("Phone Number", widget.vehicle.phonenumber),
                    row("Location", widget.vehicle.location),
                  ],
                ),
              ),
            ),
            SizedBox(height: 55,),
          ],
        ),
      ),
      persistentFooterButtons: [
        widget.vehicle.outStatus==0 ? InkWell(
          onTap: (){

            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0), // Rectangle (no rounded edges)
                  ),
                  title: const Text("Check out ?"),
                  content: const Text("Check Out this Vehicle from your Location "),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false), // Cancel
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await ApiService.checkoutCheckin(id: widget.vehicle.id, date: DateTime.now().toIso8601String());
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
          child: Container(
            width: w-10,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text("CHECK OUT CAR NOW",
                style: TextStyle(fontWeight: FontWeight.w900,color: Colors.white,fontSize: 20),),
            ),
          ),
        ):Container(
          width: w-10,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text("CHECK OUT DONE",
              style: TextStyle(fontWeight: FontWeight.w900,color: Colors.black,fontSize: 20),),
          ),
        ),
      ],
    );
  }
  Widget row(String str, String str2)=>Row(
    children: [
      Text(str,style: TextStyle(fontWeight: FontWeight.w900,color: Colors.white,fontSize: 17)),
      Spacer(),
      Text(str2,style: TextStyle(fontWeight: FontWeight.w900,color: Colors.white,fontSize: 17),)
    ],
  );
}

class FlickerText extends StatefulWidget {
  @override
  _FlickerTextState createState() => _FlickerTextState();
}

class _FlickerTextState extends State<FlickerText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 500), // speed of flicker
      vsync: this,
    )..repeat(reverse: true);

    _opacity = Tween<double>(begin: 0.2, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Text(
        "PENDING",
        style: TextStyle(
          color: Colors.red,
          fontSize: 17,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}