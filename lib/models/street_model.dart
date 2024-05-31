class StreetModel {
  int? id;
  String? streetName;

  StreetModel({this.id, this.streetName});

  StreetModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    streetName = json['StreetName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['StreetName'] = this.streetName;
    return data;
  }
}