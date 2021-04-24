class Devices {
  int id;
  String roomId;
  String deviceId;

  Devices({this.id, this.roomId, this.deviceId});

  Devices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roomId = json['roomId'];
    deviceId = json['deviceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['roomId'] = this.roomId;
    data['deviceId'] = this.deviceId;
    return data;
  }

  @override
  String toString() {
    return 'Devices : {id: $id, roomId: $roomId,deviceId: $deviceId}';
  }
}
