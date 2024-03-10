import 'package:flutter/material.dart';
import '/HomePage.dart';
import '/PostTripforDriver/post_Trip_For_Driver.dart';
import '/Rides/ChatPage.dart';
import '/Rides/Logout.dart';
import '/main.dart';
import '/CommonDrawer.dart';
import '/Profile/ProfilePage.dart';
import '/Rides/Ratings.dart';
import '/Rides/Ride.dart';


class Logout extends StatefulWidget {
  const Logout({super.key});

  @override
  State<Logout> createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {

  final CommonDrawer commonDrawer = CommonDrawer();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Logout"),
      ),
      drawer: commonDrawer.build(context),

      body: Center(
          child: Text("Logout"),
        ),
    );
  }
}
