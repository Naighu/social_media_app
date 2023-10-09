import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:social_media/domain/auth/i_auth_repo.dart';
import 'package:social_media/domain/core/dll/injectable.dart';
import 'package:social_media/screens/auth/login_page.dart';
import 'package:social_media/screens/starting_screen.dart';

import 'screens/home/homepage.dart';

Future<void> main() async {
  await initHiveForFlutter();

  ///Configuring the getIt and initalizing the variables
  await configureInjection();
  runApp(const MyApp());
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Social Media App',
        navigatorObservers: [routeObserver],
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              background: Color.fromARGB(255, 208, 205, 205)),
          useMaterial3: true,
        ),
        home: const StartingScreen());
  }
}
