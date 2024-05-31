import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_reservation/business_logic/login_cubit.dart';
import 'package:restaurant_reservation/business_logic/profile_cubit.dart';
import 'package:restaurant_reservation/business_logic/signup_cubit.dart';
import 'package:restaurant_reservation/models/restaurant_profile_model.dart';
import 'package:restaurant_reservation/views/main_screen/restaurant_screens/profile_screens/profile_edit_screen.dart';

class ProfileScreen extends StatelessWidget {
  final RestaurantProfileModel profile;

  ProfileScreen({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              return IconButton(
                onPressed: () {
                  context.read<ProfileCubit>().initialize();
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => ProfileFormScreen(profile: profile),));
                },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.deepOrange,
                ),
              );
            },
          ),
        ],
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return SingleChildScrollView(
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
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      profile.name ?? '',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(profile.description ?? ''),
                  const SizedBox(height: 16),
                  const Text(
                    'Phone Number',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(profile.phoneNumber ?? ''),
                  const SizedBox(height: 16),
                  const Text(
                    'Address',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  profile.city != null?Text('City: ${BlocProvider.of<SignupCubit>(context).cities.firstWhere((element) => element.id == profile.city).cityname}'):Container(),
                  profile.street != null?Text('Street: ${BlocProvider.of<SignupCubit>(context).streets.firstWhere((element) => element.id == profile.street).streetName}'):Container(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
