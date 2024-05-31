import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_reservation/app_brain/api_endpoint.dart';
import 'package:restaurant_reservation/models/city_model.dart';
import 'package:restaurant_reservation/models/register_request_model.dart';
import 'package:restaurant_reservation/models/street_model.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confPassController;
  late TextEditingController userIdController;
  List<CityModel> cities =[];
  List<StreetModel> streets =[];
  CityModel? selectedCity;
  StreetModel? selectedStreet;
  Map<String,int> roles = {'restaurant':2,'customer':1};
  String? role;





  Initialize(){
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confPassController = TextEditingController();
    userIdController = TextEditingController();
    selectedStreet = null;
    selectedCity = null;
    role = null;
  }

  Dispose(){
    emailController.dispose();
    passwordController.dispose();
    confPassController.dispose();
    userIdController.dispose();
    selectedStreet = null;
    selectedCity = null;
    role = null;

  }

  Future register() async {
    try {
      RegisterRequestModel requestBody = RegisterRequestModel(
        email: emailController.text,
        password: passwordController.text,
        fullName: '',
        username: userIdController.text,
        passwordConfirm: confPassController.text,
        role: roles[role],
        city: selectedCity?.id,
        street: selectedStreet?.id,
      );
      final response = await http.post(Uri.parse('${baseurl}register/'), body: requestBody.toJson());

      if (response.statusCode == 200) {
        print(response.body);
        return true;
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
        var res = jsonDecode(response.body) as List;
        cities = res.map((e) => CityModel.fromJson(e)).toList();
        print(response.body);
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
        var res = jsonDecode(response.body) as List;
        streets = res.map((e) => StreetModel.fromJson(e)).toList();
        print(response.body);
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
  selectCity(CityModel? city) {
    selectedCity = city;
    emit(Selected());
    return selectedCity;
  }

  selectStreet(StreetModel? street) {
    selectedStreet = street;
    emit(Selected());
    return selectedStreet;
  }

  selectRole(String? r) {
    role = r;
    emit(Selected());
    return role;
  }

}
