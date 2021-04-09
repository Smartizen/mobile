class HousesModel {
  final String id;
  final String name;
  final String image;
  final String location;

  HousesModel({this.name, this.id, this.image, this.location});

  HousesModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        image = json['image'],
        location = json['location'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
        'location': location,
      };

  @override
  String toString() {
    return 'User: {id: $id, name: $name,image: $image,location: $location}';
  }
}
