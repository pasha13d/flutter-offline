import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/user_bloc.dart';
import 'offline/sqlite/sqlite_db.dart';
import 'pages/pages.dart';

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
      home: BlocProvider(
        create: (context) => UserBloc(),
        child: AddUserPage(),
      ),
    );
  }
}
