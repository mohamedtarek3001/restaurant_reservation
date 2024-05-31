import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_reservation/business_logic/login_cubit.dart';
import 'package:restaurant_reservation/business_logic/signup_cubit.dart';
import 'package:restaurant_reservation/views/auth_screens/signup_screens/sign_up_more.dart';
import 'package:restaurant_reservation/widgets/auth_body.dart';
import 'package:restaurant_reservation/widgets/custom_button.dart';
import 'package:restaurant_reservation/widgets/custom_text_field.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  static final _formKey = GlobalKey<FormState>();
  FocusNode emailNode = FocusNode();
  FocusNode passNode = FocusNode();
  FocusNode confirmPassNode = FocusNode();
  FocusNode userIdNode = FocusNode();

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
                mainHeight: 510,
                secondaryHeight:400,
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
                              CustomTextField(
                                node: userIdNode,
                                controller: context.read<SignupCubit>().userIdController,
                                suffixIcon: const Icon(Icons.person),
                                title: 'User ID',
                                hint: 'Enter your user ID',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a username';
                                  }
                                  if (!RegExp(r'^[a-zA-Z][a-zA-Z0-9_]{2,14}$').hasMatch(value)) {
                                    return 'Invalid username (3-15 characters, letters, numbers, underscores, starts with letter)';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomTextField(
                                node: passNode,
                                controller: context.read<SignupCubit>().passwordController,
                                suffixIcon: const Icon(Icons.lock),
                                title: 'Password',
                                hint: 'Enter your Password',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a password';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomTextField(
                                node: confirmPassNode,
                                controller: context.read<SignupCubit>().confPassController,
                                suffixIcon: const Icon(Icons.lock),
                                title: 'Confirm password',
                                hint: 'Enter your Password Confirmation',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a password';
                                  }else if (context.read<SignupCubit>().passwordController.text != value){
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomTextField(
                                node: emailNode,
                                controller: context.read<SignupCubit>().emailController,
                                suffixIcon: const Icon(Icons.email),
                                title: 'Email Address',
                                hint: 'Enter your Email Address',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter an email';
                                  }
                                  if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                                    return 'Invalid email format';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),
                              CustomButton(
                                title: 'Next',
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    FocusScope.of(context).unfocus();
                                    Navigator.push(context, CupertinoPageRoute(builder: (context) => SignUpTwoScreen(),));

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


