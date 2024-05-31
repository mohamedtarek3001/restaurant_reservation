import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_reservation/models/login_request_model.dart';
import 'package:restaurant_reservation/models/user_model.dart';

import '../app_brain/api_endpoint.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  late TextEditingController emailController;
  late TextEditingController passwordController;
  LoginResponseModel? loggedUser;
  String? RestaurantId;

  Initialize(){
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  Dispose(){
    emailController.dispose();
    passwordController.dispose();
  }

  Future Login() async{
    try {
      LoginRequestModel requestBody = LoginRequestModel(email: emailController.text.toLowerCase(),password: passwordController.text);
      final response = await http.post(Uri.parse('${baseurl}login/'),body: requestBody.toJson()) ;
      var res = json.decode(response.body) as Map<String,dynamic>;
      if (response.statusCode == 200) {
        //print(response.body);
        loggedUser = LoginResponseModel.fromJson(res);
        if(loggedUser?.user?.role == "2"){
          await getRestaurantId(loggedUser?.user?.id.toString()??'',loggedUser?.accessToken??'');
        }
        return loggedUser;
      } else if (response.statusCode == 404) {
        throw Exception('Item not found');
      } else if (response.statusCode == 500) {
        throw Exception('Server error');
      } else {
        throw Exception('Failed to load item: ${response.body}');
      }
    } catch (error) {
      // Log the error or handle it in an appropriate way
      print('Error occurred: $error');
      //throw Exception('Failed to load item');
      return (error as Exception).toString();
    }

  }

  Future getRestaurantId(String userId,String token) async{
    try {
      var headers = {"Authorization":"Bearer $token"};
      //LoginRequestModel requestBody = LoginRequestModel(email: emailController.text,password: passwordController.text);
      final response = await http.get(Uri.parse('${baseurl}retrive_restaurants_id/$userId'),headers: headers) ;
      String? res = (json.decode(response.body) as Map<String,dynamic>)["restaurant_id"].toString();
      if (response.statusCode == 200) {
        //print(response.body);
        RestaurantId = res;
        return res;
      } else if (response.statusCode == 404) {
        throw Exception('Item not found');
      } else if (response.statusCode == 500) {
        throw Exception('Server error');
      } else {
        throw Exception('Failed to load item: ${response.body}');
      }
    } catch (error) {
      // Log the error or handle it in an appropriate way
      print('Error occurred: $error');
      //throw Exception('Failed to load item');
      return (error as Exception).toString();
    }

  }

  Future getCities() async{
    try {

      final response = await http.get(Uri.parse('${baseurl}City/'),) ;
      if (response.statusCode == 200) {

      } else if (response.statusCode == 404) {
        throw Exception('Item not found');
      } else if (response.statusCode == 500) {
        throw Exception('Server error');
      } else {
        throw Exception('Failed to load item: ${response.body}');
      }
    } catch (error) {
      // Log the error or handle it in an appropriate way
      print('Error occurred: $error');
      //throw Exception('Failed to load item');
      return (error as Exception).toString();
    }

  }
  Future getStreets() async{
    try {

      final response = await http.get(Uri.parse('${baseurl}Street/'),) ;

      if (response.statusCode == 200) {

      } else if (response.statusCode == 404) {
        throw Exception('Item not found');
      } else if (response.statusCode == 500) {
        throw Exception('Server error');
      } else {
        throw Exception('Failed to load item: ${response.body}');
      }
    } catch (error) {
      // Log the error or handle it in an appropriate way
      print('Error occurred: $error');
      //throw Exception('Failed to load item');
      return (error as Exception).toString();
    }

  }


}
