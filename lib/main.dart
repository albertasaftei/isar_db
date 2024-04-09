import 'package:flutter/material.dart';
import 'package:isar_db/models/user.dart';
import 'package:isar_db/models/user_database.dart';
import 'package:isar_db/pages/homepage.dart';
import 'package:isar_db/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserDatabase.initDatabase();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => UserDatabase()),
    ChangeNotifierProvider(create: (context) => ThemeProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Isar DB Test',
      theme: context.watch<ThemeProvider>().themeData,
      home: const Homepage(),
    );
  }
}
