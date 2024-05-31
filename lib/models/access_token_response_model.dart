class AccessTokenRequestModel {
  String? access;

  AccessTokenRequestModel({this.access});

  AccessTokenRequestModel.fromJson(Map<String, dynamic> json) {
    access = json['access'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access'] = access;
    return data;
  }
}