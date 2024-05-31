class RegisterResponseModel {
  String? accessToken;
  String? refreshToken;
  User? user;

  RegisterResponseModel({this.accessToken, this.refreshToken, this.user});

  RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access_token'] = accessToken;
    data['refresh_token'] = refreshToken;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? email;
  String? fullName;
  String? username;
  String? password;
  int? city;
  int? street;
  int? role;

  User(
      {this.id,
        this.email,
        this.fullName,
        this.username,
        this.password,
        this.city,
        this.street,
        this.role});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    fullName = json['full_name'];
    username = json['username'];
    password = json['password'];
    city = json['city'];
    street = json['street'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['full_name'] = fullName;
    data['username'] = username;
    data['password'] = password;
    data['city'] = city;
    data['street'] = street;
    data['role'] = role;
    return data;
  }
}