class DesertModel {
  int? id;
  String? restaurant;
  String? name;
  String? description;
  String? price;

  DesertModel({this.id,this.restaurant, this.name, this.description, this.price});

  DesertModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    restaurant = json['restaurant'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
  }

  Map<String, String> toJson(int option) {
    final Map<String, String> data = <String, String>{};
    if(option != 0){
      data['id'] = id.toString();
    }
    data['restaurant'] = restaurant.toString();
    data['name'] = name.toString();
    data['description'] = description.toString();
    data['price'] = price.toString();
    return data;
  }
}