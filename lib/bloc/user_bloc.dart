import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/users_model.dart';
import '../services/app_web_api.dart';

class UserBloc extends Cubit<Users> {
  UserBloc() : super(Users(name: '', address: ''));

  void updateName(String newName) {
    emit(state.copyWith(name: newName));
  }

  void updateAddress(String newAddress) {
    emit(state.copyWith(address: newAddress));
  }

  void saveUser() async {
    // Implement your logic to save the user data
    print('Saving user: ${state.name}, ${state.address}');
    await WEB.API!.saveUser(Users(name: state.name, address: state.address));
  }
}