import 'package:flutter/material.dart';
import '/HomePage.dart';
import '/CommonDrawer.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final CommonDrawer commonDrawer = CommonDrawer();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("HomePage"),
      ),
      drawer: commonDrawer.build(context),
      body: HomePage(),
    );
  }
}