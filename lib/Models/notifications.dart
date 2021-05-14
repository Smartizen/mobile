class Notifications {
  List<Noti> notifications;

  Notifications({this.notifications});

  Notifications.fromJson(Map<String, dynamic> json) {
    if (json['notifications'] != null) {
      notifications = new List<Noti>();
      json['notifications'].forEach((v) {
        notifications.add(new Noti.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.notifications != null) {
      data['notifications'] =
          this.notifications.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'RoomDetail : {notifications: $notifications}';
  }
}

class Noti {
  String id;
  String title;
  String body;
  String created_at;

  Noti({this.id, this.title, this.body, this.created_at});

  Noti.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    created_at = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;
    data['created_at'] = this.created_at;
    return data;
  }

  @override
  String toString() {
    return 'Devices : {id: $id, name: $title, command: $body, description: $created_at}';
  }
}
