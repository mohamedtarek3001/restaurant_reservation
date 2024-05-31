class NotificationModel {
  int? id;
  String? created;
  String? text;
  int? userId;

  NotificationModel({this.id, this.created, this.text, this.userId});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    created = json['created'];
    text = json['text'];
    userId = json['User_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created'] = this.created;
    data['text'] = this.text;
    data['User_id'] = this.userId;
    return data;
  }
}