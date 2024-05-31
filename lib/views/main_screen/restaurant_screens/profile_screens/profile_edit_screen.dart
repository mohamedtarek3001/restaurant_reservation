// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_reservation/business_logic/login_cubit.dart';
import 'package:restaurant_reservation/business_logic/profile_cubit.dart';
import 'package:restaurant_reservation/business_logic/refresh_token_cubit.dart';
import 'package:restaurant_reservation/business_logic/signup_cubit.dart';
import 'package:restaurant_reservation/models/restaurant_profile_model.dart';
import 'package:restaurant_reservation/widgets/custom_drop_menu.dart';
import 'package:restaurant_reservation/widgets/custom_street_drop_menu.dart';
import 'package:restaurant_reservation/widgets/restaurant_button.dart';

class ProfileFormScreen extends StatelessWidget {
  final RestaurantProfileModel profile;

  ProfileFormScreen({required this.profile});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: InkWell(
                        onTap: () async {
                          await context.read<ProfileCubit>().picPicture();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: context.read<ProfileCubit>().image == null
                                ? CachedNetworkImage(
                                    //https://moustafa.pythonanywhere.com/
                                    imageUrl: "${profile.image ?? ''}",
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) => Image.network(
                                      'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Image.file(
                                    context.read<ProfileCubit>().image!,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: context.read<ProfileCubit>().idController,
                      decoration: const InputDecoration(labelText: 'ID'),
                      readOnly: true,
                    ),
                    TextFormField(
                      controller: context.read<ProfileCubit>().userController,
                      decoration: const InputDecoration(labelText: 'User ID'),
                      readOnly: true,
                    ),
                    TextFormField(
                      controller: context.read<ProfileCubit>().nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: context.read<ProfileCubit>().descriptionController,
                      decoration: const InputDecoration(labelText: 'Description'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomCityDropMenu(
                      onChanged: (p0) {
                        context.read<ProfileCubit>().selectCity(p0);
                      },
                      city: context.read<ProfileCubit>().selectedCity,
                      list: BlocProvider.of<SignupCubit>(context).cities,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomStreetDropMenu(
                      onChanged: (p0) {
                        context.read<ProfileCubit>().selectStreet(p0);
                      },
                      street: context.read<ProfileCubit>().selectedStreet,
                      list: BlocProvider.of<SignupCubit>(context).streets,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: context.read<ProfileCubit>().phoneNumberController,
                      decoration: const InputDecoration(labelText: 'Phone Number'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: RestaurantButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            showDialog(
                              context: context,
                              builder: (context) => const Center(child: CircularProgressIndicator()),
                            );
                            String? token = await BlocProvider.of<RefreshTokenCubit>(context).get_access_token(BlocProvider.of<LoginCubit>(context).loggedUser?.refreshToken ?? '');
                            await context.read<ProfileCubit>().PostProfile(token ?? '', BlocProvider.of<LoginCubit>(context).loggedUser?.user?.id.toString() ?? '');
                            await context.read<ProfileCubit>().getProfile(token ?? '', BlocProvider.of<LoginCubit>(context).loggedUser?.user?.id.toString() ?? '');
                            Navigator.canPop(context)?Navigator.pop(context):false;
                            Navigator.canPop(context)?Navigator.pop(context):false;
                            //print('Updated Profile: ${updatedProfile.id}, ${updatedProfile.user}, ${updatedProfile.name}, ${updatedProfile.description}, ${updatedProfile.city}, ${updatedProfile.street}, ${updatedProfile.phoneNumber}');
                            //Navigator.of(context).pop(updatedProfile);
                          }
                        },
                        title: 'Save',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
