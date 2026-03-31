class CheckinModel {
  final int id;
  final String pic;
  final DateTime starttime;
  final DateTime endtime;
  final int outStatus;
  final String phonenumber;
  final String name;
  final String carnumber;
  final String gatekeeperuid;
  final String location;

  CheckinModel({
    required this.id,
    required this.pic,
    required this.starttime,
    required this.endtime,
    required this.outStatus,
    required this.phonenumber,
    required this.name,
    required this.carnumber,
    required this.gatekeeperuid,
    required this.location,
  });

  factory CheckinModel.fromJson(Map<String, dynamic> json) {
    return CheckinModel(
      id: json['id'],
      pic: json['pic'] ?? "",
      starttime: DateTime.parse(json['starttime']),
      endtime: DateTime.parse(json['endtime']),
      outStatus: json['out_status'],
      phonenumber: json['phonenumber'] ?? "",
      name: json['name'] ?? "",
      carnumber: json['carnumber'] ?? "",
      gatekeeperuid: json['gatekeeperuid'] ?? "",
      location: json['location'] ?? "",
    );
  }
}