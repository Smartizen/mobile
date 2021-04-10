import 'package:smartizen/Components/application_box.dart';
import 'package:smartizen/Models/members.dart';
import 'package:smartizen/Models/rooms.dart';

class DefaultHouse {
  String name;
  String id;
  String image;
  String location;
  List<Members> members;
  List<Rooms> rooms;
  List<ApplianceBox> roomBoxs;

  DefaultHouse(
      {this.name,
      this.id,
      this.image,
      this.location,
      this.members,
      this.rooms,
      this.roomBoxs});

  DefaultHouse.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    image = json['image'];
    location = json['location'];
    if (json['members'] != null) {
      members = new List<Members>();
      json['members'].forEach((v) {
        members.add(new Members.fromJson(v));
      });
    }
    if (json['rooms'] != null) {
      rooms = new List<Rooms>();
      json['rooms'].forEach((v) {
        rooms.add(new Rooms.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['image'] = this.image;
    data['location'] = this.location;
    if (this.members != null) {
      data['members'] = this.members.map((v) => v.toJson()).toList();
    }
    if (this.rooms != null) {
      data['rooms'] = this.rooms.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'Default: {id: $id, name: $name,image: $image,location: $location, members: $members,rooms : $rooms}';
  }
}
