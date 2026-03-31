
import 'package:flutter/material.dart';
import 'package:parku/screens/login/bloc/current.dart';
import 'package:parku/utils/messages/show_message.dart';

import '../../models/usermodel.dart';
import '../../utils/api/userapi.dart';
import '../login/spalsh.dart';

class UpdateScreen extends StatefulWidget {

  final UserModel user;

  const UpdateScreen({super.key, required this.user});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {

  final formKey = GlobalKey<FormState>();

  late TextEditingController nameC;
  late TextEditingController ageC;
  late TextEditingController phoneC;
  late TextEditingController placeC;

  String? selectedGender;
  String? selectedOccupation;

  bool progress = false;

  void b(bool v) {
    setState(() {
      progress = v;
    });
  }

  @override
  void initState() {
    super.initState();

    nameC = TextEditingController(text: widget.user.name);
    placeC = TextEditingController(text: widget.user.location);
    phoneC = TextEditingController(text: widget.user.phone.toString());
    ageC = TextEditingController(text: widget.user.bio);

  }

  Widget c(TextEditingController c, String str, Widget icon,
      {String? Function(String?)? validator,
        TextInputType? type,
        int? maxLength}) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: c,
        keyboardType: type,
        maxLength: maxLength,
        validator: validator,
        decoration: InputDecoration(
          counterText: "",
          hintText: str,
          prefixIcon: icon,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text("Update Profile")),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 10),
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
            const SizedBox(height: 20),
            Container(
              height: 45,width: w/2-90,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.yellow, // The color of the shadow
                    blurRadius: 20,       // The extent of the blur
                    offset: Offset(1, 3), // The X and Y offset of the shadow
                    spreadRadius: 0.1,    // Optional: inflates/deflates the box size before blur
                  ),
                ],
              ),
              child: Center(
                child: Text("My ID : PARKU09"+widget.user.id.toString()+"AS"
                  ,style: TextStyle(fontSize: 24,fontWeight: FontWeight.w900,),),
              ),
            ),
            const SizedBox(height: 20),
           t1("Your Name"),
           smallVehicleField(controller: nameC, hintText:"Name"),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                t1("Phone Number"),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6,vertical: 4),
                    child: Text("Not Editable",style: TextStyle(
                      color: Colors.white,fontSize: 13,height: 1
                    ),),
                  ),
                )
              ],
            ),
            smallVehicleField(controller: phoneC, hintText:"Name",number: true),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                t1("Location"),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.red
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6,vertical: 4),
                    child: Text("Editable via Admin Panel >",style: TextStyle(
                        color: Colors.white,fontSize: 13,height: 1
                    ),),
                  ),
                )
              ],
            ),
            smallVehicleField(controller: placeC, hintText:"Name",number: true),
            t1("Small Bio"),
            smallVehicleField(controller: ageC, hintText:"Your Small Bio",),
            const SizedBox(height: 20),
          ],
        ),
      ),
      persistentFooterButtons: [
        progress
            ? CircularProgressIndicator()
            : InkWell(
          onTap: () async {
            try{
              var res = await UserApiService.updateUser(
                id: Current.user.id,
                name: nameC.text,
                bio: ageC.text
              );
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>SplashScreen()));
              Send.topic(context, "Success", res.toString(),b: true)
;            }catch(e){
              Send.topic(context,"Error", "$e");
            }
          },
          child: contain(w, "Update Profile"),
        ),
      ],
    );
  }
  Widget t1(String str)=>  Padding(
    padding: const EdgeInsets.only(top: 10.0,bottom: 4),
    child: Text("$str : ",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w800),),
  );
  Widget smallVehicleField({
    required TextEditingController controller,
    required String hintText,
    number = false,
  }) {
    return TextFormField(
      controller: controller,

      keyboardType: TextInputType.emailAddress,
      readOnly: number,
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