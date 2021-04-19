class HousesModel {
  final String id;
  final String name;
  final String image;
  final String lat;
  final String long;

  HousesModel({this.name, this.id, this.image, this.lat, this.long});

  HousesModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        image = json['image'],
        lat = json['lat'],
        long = json['long'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
        'lat': lat,
        'long': long,
      };

  @override
  String toString() {
    return 'User: {id: $id, name: $name,image: $image,lat: $lat,long: $long}';
  }
}
