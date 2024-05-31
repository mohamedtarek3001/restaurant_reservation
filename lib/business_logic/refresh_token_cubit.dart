import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_reservation/app_brain/api_endpoint.dart';

part 'refresh_token_state.dart';

class RefreshTokenCubit extends Cubit<RefreshTokenState> {
  RefreshTokenCubit() : super(RefreshTokenInitial());

  String token = '';


  Future get_access_token(String refreshToken) async {
    var body = {
      "refresh": refreshToken
    };
    var response = await http.post(Uri.parse("${baseurl}token/refresh/"),body: body);
    token = (json.decode(response.body) as Map<String,dynamic>)["access"].toString();
    return token;
  }


}
