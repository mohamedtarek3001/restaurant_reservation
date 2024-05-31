import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_reservation/business_logic/login_cubit.dart';
import 'package:restaurant_reservation/business_logic/profile_cubit.dart';
import 'package:restaurant_reservation/business_logic/refresh_token_cubit.dart';
import 'package:restaurant_reservation/business_logic/restaurant_cubit.dart';
import 'package:restaurant_reservation/business_logic/signup_cubit.dart';
import 'package:restaurant_reservation/onboarding_screen.dart';
import 'views/main_screen/customer_screens/home.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => LoginCubit()..Initialize(),),
      BlocProvider(create: (context) => SignupCubit()..Initialize()..getCities()..getStreets(),lazy: false,),
      BlocProvider(create: (context) => RestaurantCubit()),
      BlocProvider(create: (context) => RefreshTokenCubit()),
      BlocProvider(create: (context) => ProfileCubit()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reserva',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff104E41)),
        useMaterial3: true,
      ),
      //home: SignUpScreen(),
      //home: LoginScreen(),
      home: OnboardingScreen(),
    );
  }
}
