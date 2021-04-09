import 'package:smartizen/Models/devices.dart';

class Rooms {
  String id;
  String name;
  List<Devices> devices;

  Rooms({this.id, this.name, this.devices});

  Rooms.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['devices'] != null) {
      devices = new List<Devices>();
      json['devices'].forEach((v) {
        devices.add(new Devices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.devices != null) {
      data['devices'] = this.devices.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'Rooms: {id: $id, name: $name,devices: $devices}';
  }
}
