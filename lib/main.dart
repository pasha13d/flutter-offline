import 'package:flutter/material.dart';

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // saveUser();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Text('Test'),
      ),
    );
  }
}
