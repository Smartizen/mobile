class Members {
  String firstname;
  String lastname;
  Manage manage;

  Members({this.firstname, this.lastname});

  Members.fromJson(Map<String, dynamic> json) {
    firstname = json['firstname'];
    lastname = json['lastname'];
    manage =
        json['Manage'] != null ? new Manage.fromJson(json['Manage']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    if (this.manage != null) {
      data['Manage'] = this.manage.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'Member: {firstname: $firstname,lastname: $lastname,manage : $manage}';
  }
}

class Manage {
  int role;

  Manage({this.role});

  Manage.fromJson(Map<String, dynamic> json) {
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['role'] = this.role;
    return data;
  }

  @override
  String toString() {
    return 'role: $role';
  }
}
