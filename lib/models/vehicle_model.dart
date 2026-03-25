import 'package:hive/hive.dart';

part 'vehicle_model.g.dart';

@HiveType(typeId: 0)
class VehicleModel extends HiveObject {
  @HiveField(0)
  String carNumber;

  @HiveField(1)
  String nickname;

  @HiveField(2)
  String name;

  @HiveField(3)
  DateTime startDate;

  @HiveField(4)
  DateTime endDate;

  @HiveField(5)
  bool completed;

  @HiveField(6)
  String vehicle;

  @HiveField(7)
  String phoneNumber;

  VehicleModel({
    required this.carNumber,
    required this.nickname,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.completed,
    required this.vehicle,
    required this.phoneNumber,
  });
}