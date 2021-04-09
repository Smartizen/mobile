class Devices {
  int id;
  String cropId;
  String deviceId;

  Devices({this.id, this.cropId, this.deviceId});

  Devices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cropId = json['cropId'];
    deviceId = json['deviceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cropId'] = this.cropId;
    data['deviceId'] = this.deviceId;
    return data;
  }

  @override
  String toString() {
    return 'Devices : {id: $id, cropId: $cropId,deviceId: $deviceId}';
  }
}
