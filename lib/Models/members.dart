class Members {
  List<Member> members;

  Members({this.members});

  Members.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      members = new List<Member>();
      json['members'].forEach((v) {
        members.add(new Member.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this != null) {
      data['members'] = this.members.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'Members : {members: $members}';
  }
}

class Member {
  String id;
  String firstname;
  String lastname;
  String email;
  String image;
  String phonenumber;
  String gender;
  int role;

  Member(
      {this.id,
      this.firstname,
      this.lastname,
      this.email,
      this.image,
      this.phonenumber,
      this.gender,
      this.role});

  Member.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    image = json['image'];
    phonenumber = json['phonenumber'];
    gender = json['gender'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['email'] = this.email;
    data['image'] = this.image;
    data['phonenumber'] = this.phonenumber;
    data['gender'] = this.gender;
    data['role'] = this.role;

    return data;
  }

  @override
  String toString() {
    return 'Member: {id: $id, firstname: $firstname,lastname: $lastname,email : $email,image : $image,phonenumber : $phonenumber,gender : $gender,role : $role}';
  }
}
