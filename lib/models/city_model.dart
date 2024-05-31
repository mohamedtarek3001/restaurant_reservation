class CityModel {
  int? id;
  String? cityname;

  CityModel({this.id, this.cityname});

  CityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cityname = json['cityname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cityname'] = this.cityname;
    return data;
  }
}