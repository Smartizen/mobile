class Rooms {
  String id;
  String name;
  List<Actives> actives;

  Rooms({this.id, this.name, this.actives});

  Rooms.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['actives'] != null) {
      actives = new List<Actives>();
      json['actives'].forEach((v) {
        actives.add(new Actives.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.actives != null) {
      data['actives'] = this.actives.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'Rooms: {id: $id, name: $name,actives: $actives}';
  }
}

class Actives {
  String deviceId;

  Actives({this.deviceId});

  Actives.fromJson(Map<String, dynamic> json) {
    deviceId = json['deviceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deviceId'] = this.deviceId;
    return data;
  }

  @override
  String toString() {
    return 'Actives : {deviceId: $deviceId}';
  }
}
