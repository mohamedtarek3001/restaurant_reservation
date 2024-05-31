import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_reservation/widgets/restaurant_button.dart';

import 'views/auth_screens/login_screens/login_screen.dart';
import 'views/auth_screens/signup_screens/sign_up_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff104E41),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 55,
                ),
                Text('Welcome to ',style: TextStyle(color: Colors.white,fontSize: 18),textAlign: TextAlign.center,),
                SizedBox(
                  height: 10,
                ),
                Image.asset(
                  'assets/images/logo.jpeg',
                  height: kToolbarHeight * 1.5,
                ),
                // SizedBox(
                //   height: (MediaQuery.of(context).size.height * 0.2) - kToolbarHeight,
                // ),
                Spacer(),
                RestaurantButton(
                  title: 'Login',
                  onPressed: () {
                    Navigator.push(context, CupertinoPageRoute(builder: (context) {
                      return LoginScreen();
                    },));
                  },
                ),
                SizedBox(
                  height: (MediaQuery.of(context).size.height * 0.1) - kToolbarHeight,
                ),
                RestaurantButton(
                  title: 'Signup',
                  onPressed: () {
                    Navigator.push(context, CupertinoPageRoute(builder: (context) {
                      return SignUpScreen();
                    },));
                  },
                ),
                Spacer(flex: 2,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
