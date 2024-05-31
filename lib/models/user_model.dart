class LoginResponseModel {
  String? accessToken;
  String? refreshToken;
  User? user;

  LoginResponseModel({this.accessToken, this.refreshToken, this.user});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? email;
  String? role;
  int? id;

  User({this.email, this.role, this.id});

  User.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    role = json['role'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['role'] = role;
    data['id'] = id;
    return data;
  }
}