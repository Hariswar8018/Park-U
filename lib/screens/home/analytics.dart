import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/checkin_model.dart';
import '../../models/vehicle_model.dart';
import '../../utils/api/do_checkin.dart';
import '../card/car_card.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class Analytics extends StatefulWidget {
  const Analytics({super.key});

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  List<CheckinModel> checkins = [];
  List<CheckinModel> filteredCheckins = [];
  void searchVehicle() {
    final query = controller.text.toLowerCase().trim();

    if (query.isEmpty) {
     loadTodayCheckins();
      return;
    }

    final results = checkins.where((item) {
      return item.carnumber.toLowerCase().contains(query);
    }).toList();

    setState(() {
      filteredCheckins = results;
      checkins = filteredCheckins;
    });
  }
  Future<void> loadTodayCheckins() async {
    try {
      if(!mounted){
        setState(() {
          working=true;
        });
      }
      print("Yes doing");
      DateTime now = DateTime.now();

      String formattedDate =
          "${now.year.toString().padLeft(4, '0')}-"
          "${now.month.toString().padLeft(2, '0')}-"
          "${now.day.toString().padLeft(2, '0')}";

      final response = await ApiService.getCheckinsByDateRange(
        startDate: DateFormat('yyyy-MM-dd').format(startDate),
        endDate: DateFormat('yyyy-MM-dd').format(endDate),
      );

      List<CheckinModel> temp = response
          .map<CheckinModel>((e) => CheckinModel.fromJson(e))
          .toList();

      setState(() {
        working=false;
        checkins = temp;
      });

    } catch (e) {
      setState(() {
        working=false;
        checkins = [];
      });
      print("ERROR: $e");
    }
  }
  DateTime startDate = DateTime.now().subtract(Duration(days: 1));
  DateTime endDate = DateTime.now();

  final DateFormat displayFormat = DateFormat('dd/MM/yyyy');
  bool working = true;
  @override
  void initState() {
    super.initState();
    loadTodayCheckins();
  }
  String formatSmartDateTime(DateTime dateTime) {
    return "${DateFormat('d MMM, yyyy').format(dateTime)}";
  }
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: working?Padding(
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
      ):Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 7),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: w - 95,
                  height: 70,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(
                          color: Colors.grey.shade200,
                          width: 0.4
                      ),
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Center(child: VehicleNumberField(controller: controller)),
                  ),
                ),
                SizedBox(width: 10,),
                InkWell(
                  onTap: searchVehicle,
                  child: Container(
                    width: 60,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(child: Icon(Icons.search,color: Colors.white,size: 30,)),
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: _openDatePicker,
                  child: Container(
                    width: w/2-15,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 0.4
                      ),
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month,color: Colors.blue,size: 27),
                          SizedBox(width: 10,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("FROM",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w600)),
                              Text(formatSmartDateTime(startDate),style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900),)
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: _openDatePicker,
                  child: Container(
                    width: w/2-15,
                    height: 70,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(
                            color: Colors.grey.shade200,
                            width: 0.4
                        ),
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month,color: Colors.blue,size: 27),
                          SizedBox(width: 10,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("TO",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w600)),
                              Text(formatSmartDateTime(endDate),style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900),)
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Flexible(
              child: ListView.builder(
                itemCount: checkins.length,
                itemBuilder: (BuildContext context, int index) {
                  CheckinModel vehicle = checkins[index];
                  return CarCard(vehicle: vehicle);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _openDatePicker() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            height: 400,
            child: SfDateRangePicker(
              selectionMode: DateRangePickerSelectionMode.range,
              maxDate: DateTime.now(),
              minDate: DateTime.now().subtract(Duration(days: 7)),
              showActionButtons: true,
              onSubmit: (value) async {
              if (value is PickerDateRange) {
                final start = value.startDate!;
                final end = value.endDate ?? start;
                setState(() {
                  startDate = start;
                  endDate = end;
                });
                Navigator.pop(context);
                final data = await ApiService.getCheckinsByDateRange(
                  startDate: DateFormat('yyyy-MM-dd').format(start),
                  endDate: DateFormat('yyyy-MM-dd').format(end),
                );
                setState(() {
                  checkins = data
                      .map<CheckinModel>((e) => CheckinModel.fromJson(e))
                      .toList();
                });
              }else{
                Navigator.pop(context);
              }

            },

              onCancel: () {
                Navigator.pop(context);

              },
            )
          ),
        );
      },
    );
  }

  TextEditingController controller = TextEditingController();

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
        fontSize: 18,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
        color: Colors.white
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.manage_search_outlined,color: Colors.white,),
        hintText: "Search Car Number",
        hintStyle: TextStyle(
          fontSize: 18,
          color: Colors.grey.shade500,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 20,
        ),
        filled: true,
        fillColor: Colors.black,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
      ),
    );
  }
}

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