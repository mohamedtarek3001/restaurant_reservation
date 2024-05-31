class NearbyRestaurantsModel {
  int? id;
  int? user;
  String? name;
  String? image;
  String? description;
  int? city;
  int? street;
  String? phoneNumber;

  NearbyRestaurantsModel(
      {this.id,
        this.user,
        this.name,
        this.image,
        this.description,
        this.city,
        this.street,
        this.phoneNumber});

  NearbyRestaurantsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    name = json['name'];
    image = json['image'];
    description = json['description'];
    city = json['city'];
    street = json['street'];
    phoneNumber = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user'] = user;
    data['name'] = name;
    data['image'] = image;
    data['description'] = description;
    data['city'] = city;
    data['street'] = street;
    data['phone_number'] = phoneNumber;
    return data;
  }
}