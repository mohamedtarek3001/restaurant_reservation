class MenuModel {
  int? id;
  String? restaurant;
  String? name;
  String? description;
  String? price;

  MenuModel(
      {this.id, this.restaurant, this.name, this.description, this.price});

  MenuModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    restaurant = json['restaurant'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
  }

  Map<String, dynamic> toJson(int option) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(option != 0){
      data['id'] = id.toString();
    }
    data['restaurant'] = restaurant;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    return data;
  }
}