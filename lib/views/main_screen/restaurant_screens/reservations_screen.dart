import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_reservation/business_logic/login_cubit.dart';
import 'package:restaurant_reservation/business_logic/refresh_token_cubit.dart';
import 'package:restaurant_reservation/business_logic/restaurant_cubit.dart';
import 'package:restaurant_reservation/models/reservations_model.dart';
import 'package:restaurant_reservation/widgets/restaurant_button.dart';

class ReservationScreen extends StatelessWidget {
  final List<ReservationsModel> reservations;

  ReservationScreen({required this.reservations});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff104E41),
      appBar: AppBar(
        backgroundColor: Color(0xff104E41),
        automaticallyImplyLeading: false,
        title: const Text('Reservations',style: TextStyle(color: Colors.white),),
      ),
      body: ListView.builder(
        itemCount: reservations.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(10.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Reservation ID: ${reservations[index].id}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text('Order name: ${reservations[index].orderName}'),
                  //Text('Restaurant ID: ${reservations[index].restaurant}'),
                  Text('Table: ${BlocProvider.of<RestaurantCubit>(context).customerTables.firstWhere((element) => element.id == reservations[index].table).tableNumber}'),
                  const SizedBox(height: 10),
                  Text('Reservation Time: ${reservations[index].reservationTime}'),
                  Text('Total Price: ${reservations[index].totalPrice}'),
                  const SizedBox(height: 10),
                  (reservations[index].menuItems?.isNotEmpty??false)?Row(
                    children: [
                      Text('Menu Items: ('),
                      ...(reservations[index].menuItems??[]).map((e) {
                        return Text("${BlocProvider.of<RestaurantCubit>(context).customerMenus.firstWhere((element) => element.id == (e)).name}, ");
                      }),
                      Text(')'),
                    ],
                  ):Container(),
                  (reservations[index].desertItems?.isNotEmpty??false)?Row(
                    children: [
                      Text('Desert Items: ('),
                      ...(reservations[index].desertItems??[]).map((e) {
                        return Text("${BlocProvider.of<RestaurantCubit>(context).customerDeserts.firstWhere((element) => element.id == (e)).name}, ");
                      }),
                      Text(')'),
                    ],
                  ):Container(),
                  //(reservations[index].menuItems?.isNotEmpty??false)?Text('Menu Items: ${BlocProvider.of<RestaurantCubit>(context).customerMenus.firstWhere((element) => element.id == reservations[index].menuItems?[0]).name}'):Container(),
                  //(reservations[index].desertItems?.isNotEmpty??false)?Text('Desert Items: ${BlocProvider.of<RestaurantCubit>(context).customerDeserts.firstWhere((element) => element.id == reservations[index].desertItems?[0]).name}'):Container(),
                  const SizedBox(height: 10),
                  BlocBuilder<RestaurantCubit, RestaurantState>(
                    builder: (context, state) {
                      return RestaurantButton(
                        onPressed: () async {
                          showDialog(context: context, builder: (context) => const Center(child: CircularProgressIndicator()),);
                          String? token = await BlocProvider.of<RefreshTokenCubit>(context).get_access_token(BlocProvider.of<LoginCubit>(context).loggedUser?.refreshToken ?? '');
                          await context.read<RestaurantCubit>().ApproveReservation(token??'', reservations[index].id.toString());
                          Navigator.canPop(context)?Navigator.pop(context):false;
                          // Implement approval logic here
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Reservation Approved!')),
                          );
                        },
                        title: 'Approve Reservation',
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}