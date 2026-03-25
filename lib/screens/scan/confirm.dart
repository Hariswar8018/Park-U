import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:parku/models/vehicle_model.dart';

class ConfirmPage extends StatefulWidget {
  final String numberPlate;

  ConfirmPage({super.key, required this.numberPlate});

  @override
  State<ConfirmPage> createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {

  void initState(){
    if(widget.numberPlate!="NAN"){
      setState(() {
        controller.text = widget.numberPlate;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Confirm")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Vehicle Type"
              ,style: TextStyle(fontWeight: FontWeight.w800,color: Colors.white,fontSize: 19),),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                children: [
                  container(Icon(Icons.directions_bike_outlined,size: 25,color: Colors.white,), "Bike"),
                  container(Icon(Icons.directions_car,size: 25,color: Colors.white,), "Car"),
                  container(Icon(Icons.fire_truck,size: 25,color: Colors.white,), "Truck"),
                ],
              ),
            ),
            SizedBox(height: 15,),
            Text("Vehicle Number"
              ,style: TextStyle(fontWeight: FontWeight.w800,color: Colors.white,fontSize: 19),),
            VehicleNumberField(controller: controller),
            SizedBox(height: 15,),
            Text("Optional"
              ,style: TextStyle(fontWeight: FontWeight.w800,color: Colors.white,fontSize: 19),),
            SizedBox(height: 5,),
            smallVehicleField(controller: phone, hintText: "Phone Number",number: true),
            SizedBox(height: 10,),
            smallVehicleField(controller: name, hintText: "Nick Name"),
          ],
        ),
      ),
      persistentFooterButtons: [
        InkWell(
          onTap: (){
            VehicleModel vehicles = VehicleModel(
                carNumber: controller.text, nickname: name.text, name: name.text,
                startDate: DateTime.now(), endDate: DateTime.now(), completed: false,
                vehicle: vehicle, phoneNumber: phone.text
            );
            addVehicle(vehicles);
          },
          child: Container(
            width: MediaQuery.of(context).size.width-15,
            height: 55,
            decoration: BoxDecoration(
              color: Color(0xff0F4C82),
              borderRadius: BorderRadius.circular(15)
            ),
            child: Center(child: Text("CONFIRM",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20,color: Colors.white),)),
          ),
        )
      ],
    );
  }
  Future<void> addVehicle(VehicleModel vehicle) async {
    final box = Hive.box<VehicleModel>('vehicles');

    await box.add(vehicle);
    Navigator.pop(context);
    Navigator.pop(context);
  }
  TextEditingController phone = TextEditingController();
  TextEditingController controller = TextEditingController();
  TextEditingController name = .new();
  String vehicle = "Bike";

  Widget container(Icon icon, String str)=>InkWell(
    onTap: (){
      setState(() {
        vehicle=str;
      });
    },
    child: Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Container(
        width: 90,
        height: 80,
        decoration: BoxDecoration(
            border: Border.all(
                color: vehicle==str?Colors.blue:Colors.grey,
                width: 2
            ),
          color: Colors.black,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            Text(str,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 14),)
          ],
        ),
      ),
    ),
  );
  Widget smallVehicleField({
    required TextEditingController controller,
    required String hintText,
    number = false
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: number?TextInputType.number:TextInputType.name,
      textCapitalization: TextCapitalization.characters,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9 ]')),
        UpperCaseTextFormatter(),
      ],
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade500,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
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
}


class VehicleNumberField extends StatelessWidget {
  final TextEditingController controller;

  const VehicleNumberField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textCapitalization: TextCapitalization.characters,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9 ]')),
        UpperCaseTextFormatter(),
      ],
      style: const TextStyle(
        fontSize: 28, // 🔥 BIG TEXT
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
      ),
      decoration: InputDecoration(
        hintText: "OD 02 AB 1234",
        hintStyle: TextStyle(
          fontSize: 22,
          color: Colors.grey.shade500,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 20,
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
      ),
    );
  }
}

// 🔠 Force uppercase input
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}