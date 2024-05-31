import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_reservation/business_logic/refresh_token_cubit.dart';
import 'package:restaurant_reservation/business_logic/restaurant_cubit.dart';
import 'package:restaurant_reservation/models/restaurant_desert_model.dart';
import 'package:restaurant_reservation/models/restaurant_menus_model.dart';
import 'package:restaurant_reservation/models/restaurant_tables_model.dart';
import 'package:restaurant_reservation/widgets/credit_widget.dart';
import 'package:restaurant_reservation/widgets/custom_button.dart';
import 'package:restaurant_reservation/widgets/restaurant_button.dart';

import '../../../business_logic/login_cubit.dart';

class RestaurantDetailsScreen extends StatelessWidget {
  RestaurantDetailsScreen({super.key});

  FocusNode node = FocusNode();
  //List<String?> tables = ['table 1', 'table 2', 'table 3', 'table 4', 'table 5', 'table 6'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff104E41),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff104E41),
        title: Image.asset(
          'assets/images/logo.jpeg',
          height: kToolbarHeight * 0.8,
        ),
      ),
      body: BlocBuilder<RestaurantCubit, RestaurantState>(
        builder: (context, state) {
          return SizedBox(
            height: MediaQuery.of(context).size.height - kToolbarHeight,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: (MediaQuery.of(context).size.height - kToolbarHeight) * 0.36,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      //image: const DecorationImage(image: NetworkImage('https://images.unsplash.com/photo-1414235077428-338989a2e8c0?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'), fit: BoxFit.cover),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: "https://moustafa1.pythonanywhere.com${context.read<RestaurantCubit>().activeRestaurant?.image??''}",
                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Image.network('https://images.unsplash.com/photo-1414235077428-338989a2e8c0?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',fit: BoxFit.cover,),
                        //imageUrl: ,
                      ),
                    ),
                  ),
                  Center(
                      child: Text(
                        context.read<RestaurantCubit>().activeRestaurant?.name??'not available',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 22),
                  )),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: TextField(
                          controller: context.read<RestaurantCubit>().orderName,
                          focusNode: node,
                          onTapOutside: (event) => node.unfocus(),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            hintText: 'Order Name . . . . . . . . .',
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 18.0, left: 18, right: 18),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            //hintText: 'Order Name . . . . . . . . .',
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2.0,
                              ),
                            ),
                          ),
                          child: DropdownButton<RestaurantTablesModel>(
                            isExpanded: true,
                            isDense: true,
                            underline: Container(),
                            menuMaxHeight: 200,
                            borderRadius: BorderRadius.circular(15),
                            value: context.read<RestaurantCubit>().selectedTable,
                            hint: const Text('Choose the available table!'),
                            items: context.read<RestaurantCubit>().customerTables
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(
                                          child: Center(child:!(e.isReserved??false)? Text("${e.tableNumber ?? ''}"):Text("${e.tableNumber ?? ''} reserved",style: TextStyle(color: Colors.grey),)),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if(!(value?.isReserved??false)){
                                context.read<RestaurantCubit>().selectTable(value);
                              }
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 18.0, left: 18, right: 18),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            //hintText: 'Order Name . . . . . . . . .',
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2.0,
                              ),
                            ),
                          ),
                          child: DropdownButton<RestaurantMenusModel>(
                            isExpanded: true,
                            isDense: true,
                            underline: Container(),
                            menuMaxHeight: 200,
                            borderRadius: BorderRadius.circular(15),
                            value: context.read<RestaurantCubit>().selectedMenu,
                            hint: const Text('Food Menu!'),
                            items: context.read<RestaurantCubit>().customerMenus
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(
                                          child: Center(child: Text(e.name ?? '')),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              context.read<RestaurantCubit>().selectMenu(value);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 18.0, left: 18, right: 18),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            //hintText: 'Order Name . . . . . . . . .',
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2.0,
                              ),
                            ),
                          ),
                          child: DropdownButton<RestaurantDesertModel>(
                            isExpanded: true,
                            isDense: true,
                            underline: Container(),
                            menuMaxHeight: 200,
                            borderRadius: BorderRadius.circular(15),
                            value: context.read<RestaurantCubit>().selectedDesert,
                            hint: const Text('Desert Menu!'),
                            items: context.read<RestaurantCubit>().customerDeserts
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(
                                          child: Center(
                                            child: Text(e.name ?? ''),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              context.read<RestaurantCubit>().selectDesert(value);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RestaurantButton(onPressed: () {
                        showCreditCardPaymentDialog(context);
                      }, title: 'Credit'),
                      RestaurantButton(onPressed: () async {
                        if(context.read<RestaurantCubit>().orderName.text.isEmpty){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Enter order name')));
                          return;
                        }else if(context.read<RestaurantCubit>().selectedTable == null){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Select table')));
                          return;
                        } else if(context.read<RestaurantCubit>().selectedMenu == null){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Select menu')));
                          return;
                        } else if(context.read<RestaurantCubit>().selectedDesert == null){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Select desert')));
                          return;
                        }
                        showDialog(context: context, builder: (context) => const Center(child: CircularProgressIndicator()),);
                        String? token = await BlocProvider.of<RefreshTokenCubit>(context).get_access_token(BlocProvider.of<LoginCubit>(context).loggedUser?.refreshToken??'');
                        var res = await context.read<RestaurantCubit>().requestReservation(BlocProvider.of<LoginCubit>(context).loggedUser?.user?.id??0, token??'');
                        // Add your payment processing logic here
                        if(res is bool){
                          if(res == true){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successful payment')));
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed payment')));
                          }
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.toString())));
                        }
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      }, title: 'Cash'),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  void showCreditCardPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Credit Card Details'),
          content: CreditCardPaymentForm(),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Pay'),
              onPressed: () async {
                if(context.read<RestaurantCubit>().orderName.text.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Enter order name')));
                  return;
                }else if(context.read<RestaurantCubit>().selectedTable == null){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Select table')));
                  return;
                } else if(context.read<RestaurantCubit>().selectedMenu == null){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Select menu')));
                  return;
                } else if(context.read<RestaurantCubit>().selectedDesert == null){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Select desert')));
                  return;
                }
                showDialog(context: context, builder: (context) => const Center(child: CircularProgressIndicator()),);
                String? token = await BlocProvider.of<RefreshTokenCubit>(context).get_access_token(BlocProvider.of<LoginCubit>(context).loggedUser?.refreshToken??'');
                var res = await context.read<RestaurantCubit>().requestReservation(BlocProvider.of<LoginCubit>(context).loggedUser?.user?.id??0, token??'');
                // Add your payment processing logic here
                if(res is bool){
                  if(res == true){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successful payment')));
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed payment')));
                  }
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.toString())));
                }
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}