import 'package:blinkit/repository/screens/home/Homescreen.dart';
import 'package:blinkit/repository/screens/login/loginscreen.dart';
import 'package:blinkit/repository/screens/spalsh/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (ctx) => CartProvider(),
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BlinkIT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      home: spalshscreen()
    );
  }
}

