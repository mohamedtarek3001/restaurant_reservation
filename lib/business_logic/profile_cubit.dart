import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:restaurant_reservation/models/city_model.dart';
import 'package:restaurant_reservation/models/restaurant_profile_model.dart';
import 'package:restaurant_reservation/models/street_model.dart';
import '../app_brain/api_endpoint.dart';
import 'package:http/http.dart' as http;

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  File? image;
  RestaurantProfileModel? profile;
  late TextEditingController idController = TextEditingController();
  late TextEditingController userController = TextEditingController();
  late TextEditingController nameController = TextEditingController();
  late TextEditingController descriptionController = TextEditingController();
  late TextEditingController cityController = TextEditingController();
  late TextEditingController streetController = TextEditingController();
  late TextEditingController phoneNumberController = TextEditingController();
  CityModel? selectedCity;
  StreetModel? selectedStreet;

  void initialize(){
    idController = TextEditingController(text: profile?.id.toString()??'');
    userController = TextEditingController(text: profile?.user.toString());
    nameController = TextEditingController(text: profile?.name);
    descriptionController = TextEditingController(text: profile?.description.toString());
    phoneNumberController = TextEditingController(text: profile?.phoneNumber.toString());

  }

  void dispose(){
    image = null;
    profile = null;
    selectedCity= null;
    selectedStreet= null;
    // idController.dispose();
    // userController.dispose();
    // nameController.dispose();
    // descriptionController.dispose();
    // cityController.dispose();
    // streetController.dispose();
    // phoneNumberController.dispose();
  }


  Future picPicture() async{
    var picker = ImagePicker();
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);
    emit(ImageSelected());
    if (pickedFile == null) {
      return null;
    }
    image = File(pickedFile.path);
    emit(ImageSelected());
  }


  Future getProfile(String token,String userId) async{
    try {
      var headers = {"Authorization":"Bearer $token"};
      final response = await http.get(Uri.parse('${baseurl}users/$userId/restaurants/'),headers: headers) ;
      if (response.statusCode == 200) {
        var res = json.decode(response.body) as Map<String,dynamic>;
        print(response.body);
        profile = RestaurantProfileModel.fromJson(res);
        emit(ProfileInitial());
        return profile;
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


  Future PostProfile(String token,String userId) async{
    try {
      var headers = {"Authorization":"Bearer $token"};
      var request = http.MultipartRequest('PUT', Uri.parse('${baseurl}users/$userId/restaurants/'));
      request.fields.addAll({
        'id': profile?.id.toString()??'',
        'user': userId,
        'name': nameController.text.toString()??'',
        'description': descriptionController.text.toString()??'',
        'city': selectedCity == null?profile?.city.toString()??'':selectedCity?.id.toString()??'',
        'street':selectedStreet == null? profile?.street.toString()??'':selectedStreet?.id.toString()??'',
        'phone_number': phoneNumberController.text.toString()??''
      });
      if(image == null){
        // request.fields.addAll({
        //   'image': profile?.image.toString()??''
        // });
      }else{
        request.files.add(await http.MultipartFile.fromPath('image', image?.path??''));
      }
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        emit(ProfileInitial());
        print(await response.stream.bytesToString());
      }
      else {
        print(response.reasonPhrase);
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


}
