// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_reservation/business_logic/login_cubit.dart';
import 'package:restaurant_reservation/business_logic/signup_cubit.dart';
import 'package:restaurant_reservation/views/auth_screens/login_screens/login_screen.dart';
import 'package:restaurant_reservation/views/main_screen/customer_screens/home.dart';
import 'package:restaurant_reservation/widgets/auth_body.dart';
import 'package:restaurant_reservation/widgets/custom_button.dart';
import 'package:restaurant_reservation/widgets/custom_drop_menu.dart';
import 'package:restaurant_reservation/widgets/custom_role_drop_menu.dart';
import 'package:restaurant_reservation/widgets/custom_street_drop_menu.dart';
import 'package:restaurant_reservation/widgets/custom_text_field.dart';

class SignUpTwoScreen extends StatelessWidget {
  SignUpTwoScreen({super.key});

  static final _formKey = GlobalKey<FormState>();
  FocusNode emailNode = FocusNode();
  FocusNode passNode = FocusNode();
  FocusNode confirmPassNode = FocusNode();

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
      body: SizedBox(
        height: MediaQuery.of(context).size.height - kToolbarHeight,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: (MediaQuery.of(context).size.height * 0.2) - kToolbarHeight,
              ),
              AuthBody(
                formKey: _formKey,
                mainHeight: 420,
                secondaryHeight:310,
                emailNode: emailNode,
                passNode: passNode,
                child: BlocBuilder<SignupCubit, SignupState>(
                  builder: (context, state) {
                    return SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10, left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 45,),
                              CustomCityDropMenu(
                                list: context.read<SignupCubit>().cities,
                                city: context.read<SignupCubit>().selectedCity,
                                onChanged: (p0) {
                                  context.read<SignupCubit>().selectCity(p0);
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomStreetDropMenu(
                                list: context.read<SignupCubit>().streets,
                                street: context.read<SignupCubit>().selectedStreet,
                                onChanged: (p0) {
                                  context.read<SignupCubit>().selectStreet(p0);
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomRoleDropMenu(
                                list: context.read<SignupCubit>().roles.keys.toList(),
                                role: context.read<SignupCubit>().role,
                                onChanged: (p0) {
                                  context.read<SignupCubit>().selectRole(p0);
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomButton(
                                title: 'Register',
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    FocusScope.of(context).unfocus();
                                    if(context.read<SignupCubit>().selectedStreet == null || context.read<SignupCubit>().selectedCity == null || context.read<SignupCubit>().role == null){
                                      return;
                                    }
                                    showDialog(context: context, builder: (context) => const Center(child: CircularProgressIndicator()),);

                                    var res = await context.read<SignupCubit>().register();
                                    Navigator.canPop(context)? Navigator.pop(context):false;
                                    if(res is bool){
                                      if(res){
                                        context.read<SignupCubit>().Dispose();
                                        Navigator.popUntil(context, (route) => route.isFirst);
                                        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => LoginScreen(),));
                                      }else{
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('not registered')));
                                      }
                                    }else{
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$res')));
                                    }

                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


