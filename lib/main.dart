import 'package:flutter/material.dart';
import 'package:mobile_project/routes/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Testing Stuff',
        debugShowCheckedModeBanner: true,
        theme: ThemeData(),
        routes: Routes.getroutes);
    //home: const MyHomePage(title: 'Demo Home Page'));
  }
}
