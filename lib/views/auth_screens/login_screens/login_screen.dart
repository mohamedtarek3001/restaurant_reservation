import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_reservation/business_logic/login_cubit.dart';
import 'package:restaurant_reservation/business_logic/refresh_token_cubit.dart';
import 'package:restaurant_reservation/business_logic/restaurant_cubit.dart';
import 'package:restaurant_reservation/models/user_model.dart';
import 'package:restaurant_reservation/views/main_screen/customer_screens/home.dart';
import 'package:restaurant_reservation/widgets/auth_body.dart';
import 'package:restaurant_reservation/widgets/custom_button.dart';
import 'package:restaurant_reservation/widgets/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  static final _formKey = GlobalKey<FormState>();
  FocusNode emailNode = FocusNode();
  FocusNode passNode = FocusNode();

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
                mainHeight: 400,
                secondaryHeight:290,
                emailNode: emailNode,
                passNode: passNode,
                child: BlocBuilder<LoginCubit, LoginState>(
                  builder: (context, state) {
                    return Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10, left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CustomTextField(
                              node: emailNode,
                              controller: context.read<LoginCubit>().emailController,
                              suffixIcon: const Icon(Icons.person),
                              title: 'User ID',
                              hint: 'Enter your user ID',
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomTextField(
                              node: passNode,
                              controller: context.read<LoginCubit>().passwordController,
                              suffixIcon: const Icon(Icons.lock),
                              title: 'Password',
                              hint: 'Enter your Password',
                            ),
                            const SizedBox(height: 15),
                            CustomButton(
                              title: 'LOGIN',
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  FocusScope.of(context).unfocus();
                                  showDialog(context: context, builder: (context) => const Center(child: CircularProgressIndicator()),);
                                  var res = await context.read<LoginCubit>().Login();
                                  if(res is LoginResponseModel){
                                    String token = await BlocProvider.of<RefreshTokenCubit>(context).get_access_token(res.refreshToken??"");
                                    await BlocProvider.of<RestaurantCubit>(context).getNearbyRestaurants(res.user?.id??0, token);
                                    if(context.read<LoginCubit>().loggedUser?.user?.role == "2"){
                                      context.read<RestaurantCubit>().dispose();
                                      //showDialog(context: context, builder: (context) => const Center(child: CircularProgressIndicator()),);
                                      //String? token = await BlocProvider.of<RefreshTokenCubit>(context).get_access_token(BlocProvider.of<LoginCubit>(context).loggedUser?.refreshToken??'');
                                      await BlocProvider.of<RestaurantCubit>(context).getRestaurantTables(context.read<LoginCubit>().RestaurantId??'', token??'');
                                      await BlocProvider.of<RestaurantCubit>(context).getRestaurantMenus(context.read<LoginCubit>().RestaurantId??'', token??'');
                                      await BlocProvider.of<RestaurantCubit>(context).getRestaurantDesert(context.read<LoginCubit>().RestaurantId??'', token??'');
                                      //Navigator.canPop(context)?Navigator.pop(context):false;
                                    }
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => HomeScreen(),));
                                  }else{
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(res),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ],
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


