import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:restaurant_reservation/app_brain/api_endpoint.dart';
import 'package:restaurant_reservation/models/desert_model.dart';
import 'package:restaurant_reservation/models/menus_model.dart';
import 'package:restaurant_reservation/models/nearby_restaurants_model.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_reservation/models/notification_model.dart';
import 'package:restaurant_reservation/models/reservation_request_model.dart';
import 'package:restaurant_reservation/models/reservations_model.dart';
import 'package:restaurant_reservation/models/restaurant_desert_model.dart';
import 'package:restaurant_reservation/models/restaurant_menus_model.dart';
import 'package:restaurant_reservation/models/restaurant_tables_model.dart';
import 'package:restaurant_reservation/models/tables_model.dart';

part 'restaurant_state.dart';

class RestaurantCubit extends Cubit<RestaurantState> {
  RestaurantCubit() : super(RestaurantInitial());
  TextEditingController orderName = TextEditingController();
  List<NearbyRestaurantsModel> restaurants = [];
  List<RestaurantTablesModel> customerTables = [];
  List<RestaurantDesertModel> customerDeserts = [];
  List<RestaurantMenusModel> customerMenus = [];
  List<RestaurantMenusModel> SelectedMenus = [];
  List<RestaurantDesertModel> SelectedDeserts = [];
  double totalPrice = 0;
  double dessertPrice = 0;
  double menuPrice = 0;

  List<TablesModel> tables = [];
  List<DesertModel> deserts = [];
  List<MenuModel> menus = [];
  List<NotificationModel> notifications = [];
  List<ReservationsModel> reservations = [];

  NearbyRestaurantsModel? activeRestaurant;

  RestaurantTablesModel? selectedTable;

  RestaurantDesertModel? selectedDesert;

  RestaurantMenusModel? selectedMenu;

  ReservationRequestModel? reservationRequest;

  void selectTable(RestaurantTablesModel? table) {
    selectedTable = table;
    emit(Selected());
  }

  void selectMenus(RestaurantMenusModel value){
    SelectedMenus.add(value);
    double pr = double.tryParse(value.price.toString())??0;
    menuPrice+= pr;
    totalPrice += pr;
    emit(Selected());
  }
  clearMenuPrice(){
    totalPrice -= menuPrice;
    menuPrice = 0;
    emit(Selected());
  }

  void selectDesert(RestaurantDesertModel value){
    SelectedDeserts.add(value);
    double pr = double.tryParse(value.price.toString())??0;
    dessertPrice+= pr;
    totalPrice += pr;
    emit(Selected());
  }
  clearDesertPrice(){
    totalPrice -= dessertPrice;
    dessertPrice = 0;
    emit(Selected());
  }


  void dispose() {
    customerTables.clear();
    customerDeserts.clear();
    customerMenus.clear();
    activeRestaurant = null;
    selectedTable = null;
    selectedDesert = null;
    selectedMenu = null;
    reservationRequest = null;
  }

  Future getNearbyRestaurants(int userId, String token) async {
    try {
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
      };
      final response = await http.get(Uri.parse('${baseurl}restaurantsList/$userId/'), headers: headers);
      print(response.body);
      var res = json.decode(response.body) as List;
      if (response.statusCode == 200) {
        //print(response.body);
        restaurants = res.map((e) => NearbyRestaurantsModel.fromJson(e)).toList();
        emit(added());

        return restaurants;
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

  Future getRestaurantTables(String userId, String token) async {
    try {
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
      };
      final response = await http.get(Uri.parse('${baseurl}restaurants/$userId/tables/'), headers: headers);
      print(response.body);
      var res = json.decode(response.body) as List;
      if (response.statusCode == 200) {
        //print(response.body);
        customerTables = res.map((e) => RestaurantTablesModel.fromJson(e)).toList();
        emit(added());

        return customerTables;
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

  Future getRestaurantMenus(String userId, String token) async {
    try {
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
      };
      final response = await http.get(Uri.parse('${baseurl}restaurants/$userId/menu/'), headers: headers);
      print(response.body);
      var res = json.decode(response.body) as List;
      if (response.statusCode == 200) {
        //print(response.body);
        customerMenus = res.map((e) => RestaurantMenusModel.fromJson(e)).toList();
        emit(added());

        return customerMenus;
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

  Future getRestaurantDesert(String userId, String token) async {
    try {
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
      };
      final response = await http.get(Uri.parse('${baseurl}restaurants/$userId/Desert/'), headers: headers);
      print(response.body);
      var res = json.decode(response.body) as List;
      if (response.statusCode == 200) {
        //print(response.body);
        emit(added());
        customerDeserts = res.map((e) => RestaurantDesertModel.fromJson(e)).toList();
        emit(added());

        return customerDeserts;

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




  makeReservation(String paymentWay) async {
    List<int>? desserts = [];
    double price = 0;
    for(var v in SelectedDeserts){
      desserts.add(v.id??0);
      price += double.tryParse(v.price.toString())??0;
    }
    List<int>? menus = [];
    for(var v in SelectedMenus){
      menus.add(v.id??0);
      price += double.tryParse(v.price.toString())??0;
    }
    print(price);
    print(menus);
    print(desserts);
    reservationRequest = ReservationRequestModel(
      totalPrice: price.toString(),
      desertItems: desserts,
      menuItems: menus,
      //reservationTime: ,
      restaurant: activeRestaurant?.id.toString(),
      table: selectedTable?.id.toString(),
      OrderName: "${orderName.text} ($paymentWay)",
    );
  }

  Future requestReservation(int userId, String token,String paymentWay)async{
    try {
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      };
      makeReservation(paymentWay);
      final response = await http.post(
          Uri.parse('${baseurl}reservations/create/$userId'),
          body: jsonEncode(reservationRequest?.toJson()),
          headers: headers,
      );
      print(response.body);
      //var res = json.decode(response.body) as List;
      if (response.statusCode == 201) {
        //print(response.body);
        //restaurants = res.map((e) => NearbyRestaurantsModel.fromJson(e)).toList();
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

  Future PostTables(String token,TablesModel table) async {
    try {
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
      };
      final response = await http.post(Uri.parse('${baseurl}tables/'), headers: headers,body: table.toJson(0));
      print(response.body);
      var res = json.decode(response.body) as Map;
      if (response.statusCode == 201) {
        emit(added());

        //print(response.body);
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

  Future PostMenus(String token,MenuModel menu) async {
    try {
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
      };
      final response = await http.post(Uri.parse('${baseurl}menus/'), headers: headers,body: menu.toJson(0));
      print(response.body);
      var res = json.decode(response.body) as Map;
      if (response.statusCode == 201) {
        emit(added());
        //print(response.body);
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

  Future PostDesert(String token,DesertModel desert) async {
    try {
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
      };
      final response = await http.post(Uri.parse('${baseurl}Desert/'), headers: headers,body: desert.toJson(0));
      print(response.body);
      var res = json.decode(response.body) as Map;
      if (response.statusCode == 201) {
        emit(added());

        //print(response.body);
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

  Future PutTables(String token,TablesModel table) async {
    try {
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
      };
      final response = await http.put(Uri.parse('${baseurl}tables/${table.id}/'), headers: headers,body: table.toJson(1));
      //print(response.body);
      var res = json.decode(response.body) as Map;
      if (response.statusCode == 200) {
        emit(added());

        //print(response.body);
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

  Future PutMenus(String token,MenuModel menu) async {
    try {
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
      };
      final response = await http.put(Uri.parse('${baseurl}menus/${menu.id}/'), headers: headers,body: menu.toJson(1));
      print(response.body);
      var res = json.decode(response.body) as Map;
      if (response.statusCode == 200) {
        emit(added());
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

  Future PutDesert(String token,DesertModel? desert) async {
    try {
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
      };
      //final response = await http.put(Uri.parse('${baseurl}Desert/${desert?.id}/'), headers: headers,body: desert?.toJson(1));
      var request = http.MultipartRequest('PUT', Uri.parse('${baseurl}Desert/${desert?.id}/'));

      request.fields.addAll({
        'id': desert?.id.toString()??"",
        'restaurant': desert?.restaurant.toString()??"",
        'name': desert?.name.toString()??"",
        'description': desert?.description.toString()??"",
        'price': desert?.price.toString()??""
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      print(response.reasonPhrase);
      //var res = json.decode(response.body) as Map;
      if (response.statusCode == 200) {
        emit(added());
        //print(response.body);
        return true;
      } else if (response.statusCode == 404) {
        throw Exception('Item not found');
      } else if (response.statusCode == 500) {
        throw Exception('Server error');
      } else {
        throw Exception('Failed to load item: ${response.stream.toString()}');
      }
    } catch (error) {
      // Log the error or handle it in an appropriate way
      print('Error occurred: $error');
      //throw Exception('Failed to load item');
      return (error as Exception).toString();
    }
  }

  Future getNotification(int userId, String token) async{
    try {
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
      };
      final response = await http.get(Uri.parse('${baseurl}notifications/$userId/'), headers: headers);
      print(response.body);

      if (response.statusCode == 200) {
        var res = json.decode(response.body) as List;
        //print(response.body);
        notifications = res.map((e) => NotificationModel.fromJson(e)).toList();
        emit(added());

        return notifications;

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

  Future getReservatrions(String userId, String token) async {
    try {
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
      };
      final response = await http.get(Uri.parse('${baseurl}restaurants/$userId/Reservations/'), headers: headers);
      print(response.body);

      if (response.statusCode == 200) {
        var res = json.decode(response.body) as List;
        //print(response.body);
        reservations = res.map((e) => ReservationsModel.fromJson(e)).toList();
        emit(added());

        return reservations;

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

  Future ApproveReservation(String token,String reservationId) async {
    try {
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
      };
      final response = await http.post(Uri.parse('${baseurl}reservations/$reservationId/approve/'), headers: headers);
      print(response.body);

      if (response.statusCode == 200) {
        var res = json.decode(response.body) as Map;
        emit(added());
        //print(response.body);
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


}
