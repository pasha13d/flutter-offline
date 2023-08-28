import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_bloc.dart';
import '../models/users_model.dart';
import '../services/app_web_api.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({Key? key}) : super(key: key);

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  getUserList() async{
    List<Users> userList = await WEB.API!.getUsersList();
    print('userList ${userList.length}');
  }

  @override
  void initState() {
    super.initState();
    getUserList();
  }

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User Info'),
      ),
      body: BlocBuilder<UserBloc, Users>(
        builder: (context, user) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  initialValue: user.name,
                  decoration: const InputDecoration(labelText: 'Name'),
                  onChanged: (newName) => userBloc.updateName(newName),
                ),
                TextFormField(
                  initialValue: user.address,
                  decoration: const InputDecoration(labelText: 'Address'),
                  onChanged: (newAddress) => userBloc.updateAddress(newAddress),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    userBloc.saveUser();
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
