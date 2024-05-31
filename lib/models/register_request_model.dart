class RegisterRequestModel {
  String? email;
  String? fullName;
  String? username;
  String? password;
  String? passwordConfirm;
  int? city;
  int? street;
  int? role;

  RegisterRequestModel(
      {this.email,
        this.fullName,
        this.username,
        this.password,
        this.passwordConfirm,
        this.city,
        this.street,
        this.role});

  RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    fullName = json['full_name'];
    username = json['username'];
    password = json['password'];
    passwordConfirm = json['password_confirm'];
    city = json['city'];
    street = json['street'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email.toString();
    data['full_name'] = fullName.toString();
    data['username'] = username.toString();
    data['password'] = password.toString();
    data['password_confirm'] = passwordConfirm.toString();
    data['city'] = city.toString();
    data['street'] = street.toString();
    data['role'] = role.toString();
    return data;
  }
}