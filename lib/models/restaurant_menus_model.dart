class RestaurantMenusModel {
  int? id;
  String? name;
  String? description;
  String? price;

  RestaurantMenusModel({this.id, this.name, this.description, this.price});

  RestaurantMenusModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    return data;
  }
}