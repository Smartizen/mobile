class RoomDetail {
  List<Device> devices;

  RoomDetail({this.devices});

  RoomDetail.fromJson(Map<String, dynamic> json) {
    if (json['devices'] != null) {
      devices = new List<Device>();
      json['devices'].forEach((v) {
        devices.add(new Device.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.devices != null) {
      data['devices'] = this.devices.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'RoomDetail : {devices: $devices}';
  }
}

class Device {
  String activeId;
  String id;
  String description;
  String deviceId;
  List<Functions> functions;

  Device(
      {this.activeId,
      this.id,
      this.description,
      this.deviceId,
      this.functions});

  Device.fromJson(Map<String, dynamic> json) {
    activeId = json['activeId'];
    id = json['id'];
    description = json['description'];
    deviceId = json['deviceId'];
    if (json['functions'] != null) {
      functions = new List<Functions>();
      json['functions'].forEach((v) {
        functions.add(new Functions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['activeId'] = this.activeId;
    data['id'] = this.id;
    data['deviceId'] = this.deviceId;
    data['description'] = this.description;

    if (this.functions != null) {
      data['functions'] = this.functions.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'Device : {id: $id, activeId: $activeId, deviceId: $deviceId,description: $description ,functions : $functions}';
  }
}

class Functions {
  String id;
  String name;
  String command;
  String description;

  Functions({this.id, this.name, this.command, this.description});

  Functions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    command = json['command'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['command'] = this.command;
    data['description'] = this.description;
    return data;
  }

  @override
  String toString() {
    return 'Devices : {id: $id, name: $name, command: $command, description: $description}';
  }
}
