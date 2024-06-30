// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_reservation/business_logic/login_cubit.dart';
import 'package:restaurant_reservation/business_logic/profile_cubit.dart';
import 'package:restaurant_reservation/business_logic/refresh_token_cubit.dart';
import 'package:restaurant_reservation/business_logic/restaurant_cubit.dart';
import 'package:restaurant_reservation/business_logic/signup_cubit.dart';
import 'package:restaurant_reservation/models/restaurant_profile_model.dart';
import 'package:restaurant_reservation/onboarding_screen.dart';
import 'package:restaurant_reservation/views/auth_screens/login_screens/login_screen.dart';
import 'package:restaurant_reservation/views/auth_screens/signup_screens/sign_up_screen.dart';
import 'package:restaurant_reservation/views/main_screen/customer_screens/restaurant_details_screen.dart';
import 'package:restaurant_reservation/views/main_screen/restaurant_screens/profile_screens/profile_screen.dart';
import 'package:restaurant_reservation/views/main_screen/restaurant_screens/reservations_screen.dart';
import 'package:restaurant_reservation/views/main_screen/restaurant_screens/restaurant_home.dart';
import 'package:restaurant_reservation/views/notification_screens/notification_screen.dart';
import 'package:restaurant_reservation/widgets/restaurant_button.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  FocusNode node = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: BlocProvider.of<LoginCubit>(context).loggedUser?.user?.role != '2' ? const Color(0xff104E41) : Colors.grey[200],
      appBar: AppBar(
        backgroundColor: const Color(0xff104E41),
        title: Image.asset(
          'assets/images/logo.jpeg',
          height: kToolbarHeight * 0.8,
        ),
        actions: [
          BlocBuilder<RestaurantCubit, RestaurantState>(
            builder: (context, state) {
              return IconButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) => const Center(child: CircularProgressIndicator()),
                    );
                    String? token = await BlocProvider.of<RefreshTokenCubit>(context).get_access_token(BlocProvider.of<LoginCubit>(context).loggedUser?.refreshToken ?? '');
                    await context.read<RestaurantCubit>().getNotification(BlocProvider.of<LoginCubit>(context).loggedUser?.user?.id ?? 0, token ?? '');
                    Navigator.canPop(context) ? Navigator.pop(context) : false;
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => NotificationScreen(notifications: context.read<RestaurantCubit>().notifications),
                        ));
                  },
                  icon: const Icon(
                    Icons.notifications,
                    color: Colors.deepOrange,
                  ));
            },
          ),
          Builder(builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
            );
          }),
        ],
      ),
      endDrawer: const CustomDrawer(),
      body: BlocProvider.of<LoginCubit>(context).loggedUser?.user?.role != '2' ? CustomerHome(node: node) : const RestaurantHome(),
    );
  }
}

class CustomerHome extends StatelessWidget {
  const CustomerHome({
    super.key,
    required this.node,
  });

  final FocusNode node;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - kToolbarHeight,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            child: Container(
              height: (MediaQuery.of(context).size.height - kToolbarHeight) * 0.290,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/backImage.jpeg'), fit: BoxFit.cover)),
            ),
          ),
          Positioned(
            bottom: 0,
            height: (MediaQuery.of(context).size.height - kToolbarHeight) * 0.695,
            width: MediaQuery.of(context).size.width,
            child: Container(
              decoration: const BoxDecoration(color: Color(0xff40564A), borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
              child: BlocBuilder<RestaurantCubit, RestaurantState>(
                builder: (context, state) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(color: Color(0xff104E41), borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
                        child: Center(
                            child: Text(
                          'Number of restaurants: ${context.read<RestaurantCubit>().restaurants.length}',
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: TextField(
                          focusNode: node,
                          onTapOutside: (event) => node.unfocus(),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            hintText: 'Search a restaurant',
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
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(),
                          child: ListView.builder(
                            itemCount: context.read<RestaurantCubit>().restaurants.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  context.read<RestaurantCubit>().dispose();
                                  context.read<RestaurantCubit>().activeRestaurant = context.read<RestaurantCubit>().restaurants[index];
                                  showDialog(
                                    context: context,
                                    builder: (context) => const Center(child: CircularProgressIndicator()),
                                  );
                                  context.read<RestaurantCubit>().SelectedMenus.clear();
                                  context.read<RestaurantCubit>().orderName = TextEditingController();
                                  context.read<RestaurantCubit>().SelectedDeserts.clear();
                                  String? token = await BlocProvider.of<RefreshTokenCubit>(context).get_access_token(BlocProvider.of<LoginCubit>(context).loggedUser?.refreshToken ?? '');
                                  await context.read<RestaurantCubit>().getRestaurantTables((context.read<RestaurantCubit>().restaurants[index].id ?? 0).toString(), token ?? '');
                                  await context.read<RestaurantCubit>().getRestaurantMenus((context.read<RestaurantCubit>().restaurants[index].id ?? 0).toString(), token ?? '');
                                  await context.read<RestaurantCubit>().getRestaurantDesert((context.read<RestaurantCubit>().restaurants[index].id ?? 0).toString(), token ?? '');
                                  Navigator.canPop(context) ? Navigator.pop(context) : false;

                                  await Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => RestaurantDetailsScreen(),
                                    ),
                                  );
                                  context.read<RestaurantCubit>().activeRestaurant = null;
                                },
                                child: RestaurantItem(
                                  image: context.read<RestaurantCubit>().restaurants[index].image,
                                  name: context.read<RestaurantCubit>().restaurants[index].name,
                                  description: context.read<RestaurantCubit>().restaurants[index].description,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RestaurantItem extends StatelessWidget {
  RestaurantItem({
    super.key,
    required this.name,
    required this.description,
    required this.image,
  });

  String? name;
  String? description;
  String? image;

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.red,
      height: 170,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 10, top: 10, left: 15, right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 150,
            width: MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
                    width: 120,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        imageUrl: "https://moustafa1.pythonanywhere.com${image ?? ''}",
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Image.network(
                          'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Name: ${name ?? "not available"}',
                        style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Description: ${description ?? 'not available'}',
                        style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Divider(
            height: 5,
            color: Colors.deepOrange[800]!,
            thickness: 3,
            indent: 10,
            endIndent: 10,
          ),
        ],
      ),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromRGBO(155, 0, 0, 0.3),
      width: MediaQuery.of(context).size.width * 0.55,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(255, 50, 50, 0.7),
              Color.fromRGBO(155, 0, 0, 0.3),
              Color.fromRGBO(255, 50, 50, 0.7),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: (MediaQuery.of(context).size.height - kToolbarHeight) * 0.4,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18,top: 5),
                child: RestaurantButton(
                  title: BlocProvider.of<LoginCubit>(context).loggedUser == null ? 'Login' : 'Logout',
                  onPressed: () {
                    if(BlocProvider.of<LoginCubit>(context).loggedUser == null){
                      Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    }else{
                      Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => OnboardingScreen(),
                        ),
                      );
                    }

                  },
                ),
              ),
              BlocBuilder<SignupCubit, SignupState>(builder: (signupContext, state) {
                return Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18,top: 5),
                  child: RestaurantButton(
                    title: 'Register',
                    onPressed: () {
                      signupContext.read<SignupCubit>().Initialize();
                      Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => SignUpScreen(),
                        ),
                      );
                    },
                  ),
                );
              }),
              BlocProvider.of<LoginCubit>(context).loggedUser?.user?.role != '1'
                  ? BlocBuilder<RestaurantCubit, RestaurantState>(
                      builder: (context, state) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 18.0, left: 18,top: 5),
                          child: RestaurantButton(
                            title: 'Reservations',
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (context) => const Center(child: CircularProgressIndicator()),
                              );
                              String? token = await BlocProvider.of<RefreshTokenCubit>(context).get_access_token(BlocProvider.of<LoginCubit>(context).loggedUser?.refreshToken ?? '');
                              await context.read<RestaurantCubit>().getReservatrions(BlocProvider.of<LoginCubit>(context).loggedUser?.user?.id.toString() ?? '', token ?? '');
                              Navigator.canPop(context) ? Navigator.pop(context) : false;
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => ReservationScreen(reservations: context.read<RestaurantCubit>().reservations),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.only(right: 18.0, left: 18,top: 5),
                child: RestaurantButton(
                  title: 'Contact us',
                  onPressed: () {},
                ),
              ),
              BlocProvider.of<LoginCubit>(context).loggedUser?.user?.role != '1'
                  ? BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (profileContext, state) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 18.0, left: 18,top: 5),
                          child: RestaurantButton(
                            title: 'Profile',
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (context) => const Center(child: CircularProgressIndicator()),
                              );
                              profileContext.read<ProfileCubit>().dispose();
                              String? token = await BlocProvider.of<RefreshTokenCubit>(context).get_access_token(BlocProvider.of<LoginCubit>(context).loggedUser?.refreshToken ?? '');
                              await profileContext.read<ProfileCubit>().getProfile(token ?? '', BlocProvider.of<LoginCubit>(context).loggedUser?.user?.id.toString() ?? '');
                              Navigator.canPop(context) ? Navigator.pop(context) : false;
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => ProfileScreen(profile: profileContext.read<ProfileCubit>().profile ?? RestaurantProfileModel()),
                                ),
                              );
                              // Update the state of the app.
                              // ...
                            },
                          ),
                        );
                      },
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
