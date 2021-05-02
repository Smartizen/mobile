import 'package:smartizen/Components/application_box.dart';
import 'package:smartizen/Models/rooms.dart';

class DefaultHouse {
  String id;
  String name;
  String image;
  String lat;
  String long;
  List<Rooms> rooms;
  List<ApplianceBox> roomBoxs;

  DefaultHouse(
      {this.id,
      this.name,
      this.image,
      this.lat,
      this.long,
      this.rooms,
      this.roomBoxs});

  DefaultHouse copyWith(
          {String id,
          String name,
          String image,
          String lat,
          String long,
          List<Rooms> rooms,
          List<ApplianceBox> roomBoxs}) =>
      DefaultHouse(
        id: id ?? this.id,
        name: name ?? this.name,
        image: image ?? this.image,
        lat: lat ?? this.lat,
        long: long ?? this.long,
        rooms: rooms ?? this.rooms,
        roomBoxs: roomBoxs ?? this.roomBoxs,
      );

  DefaultHouse.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    image = json['image'];
    lat = json['lat'];
    long = json['long'];
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
    data['lat'] = this.lat;
    data['long'] = this.long;
    if (this.rooms != null) {
      data['rooms'] = this.rooms.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'Default: {id: $id, name: $name,image: $image,lat: $lat,long: $long, rooms : $rooms}';
  }
}
