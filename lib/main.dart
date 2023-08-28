import 'package:flutter/material.dart';
import 'package:ussd_advanced/ussd_advanced.dart';

import 'models/users_model.dart';
import 'offline/sqlite/sqlite_db.dart';
import 'offline/sqlite/sqlite_offline_api.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SqliteDB.CreateLocalDB();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Users> users = [];

  void saveUser() async {
    await Offline.API!.saveUser();
  }

  void getUser() async {
    users = await Offline.API!.getUsersList();
    print('user ${users.length}');
    if(users.isNotEmpty) {
      print(users[0].name);
      print(users[0].address);
      print(users[1].name);
      print(users[1].address);
    }
  }

  late TextEditingController _controller;
  String? _response;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    // saveUser();
    getUser();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          // text input
          TextField(
            controller: _controller,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'Ussd code'),
          ),
          // dispaly responce if any
          if (_response != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(_response!),
            ),
          // buttons
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  UssdAdvanced.sendUssd(code: _controller.text, subscriptionId: 1);
                },
                child: const Text('norma\nrequest'),
              ),
              ElevatedButton(
                onPressed: () async {
                  String? _res = await UssdAdvanced.sendAdvancedUssd(code: _controller.text, subscriptionId: 1);
                  setState(() {
                    _response = _res;
                  });
                },
                child: const Text('single session\nrequest'),
              ),
              // ElevatedButton(
              //   onPressed: () async {
              //     String? _res = await UssdAdvanced.multisessionUssd(code: _controller.text, subscriptionId: 1);
              //     setState(() {
              //       _response = _res;
              //     });
              //     String? _res2 = await UssdAdvanced.sendMessage('0');
              //     setState(() {
              //       _response = _res2;
              //     });
              //     await UssdAdvanced.cancelSession();
              //   },
              //   child: const Text('multi session\nrequest'),
              // ),
            ],
          )
        ],
      ),
    );
  }
}
