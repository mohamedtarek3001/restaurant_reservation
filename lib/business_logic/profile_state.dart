part of 'profile_cubit.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ImageSelected extends ProfileState {}

class Selected extends ProfileState {}