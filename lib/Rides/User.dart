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


class UserProfilePage extends StatelessWidget {

  final CommonDrawer commonDrawer = CommonDrawer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Profile"),
      ),
      drawer: commonDrawer.build(context), // Use CommonDrawer here
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 0, left: 30, right: 30, bottom: 30),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Image.asset("images/image.jpg", height: 120),
              ),
              const SizedBox(height: 20),
              UserProfileCard(
                Username: 'Humza',
                Email: 'Humza01@gmail.com',
                Phone: '123-456-7890',
                Age: 20,
                Destination: 'Hyderabad, Pakistan',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserProfileCard extends StatelessWidget {
  final String Username;
  final String Email;
  final String Phone;
  final int Age;
  final String Destination;

  UserProfileCard({
    required this.Username,
    required this.Email,
    required this.Phone,
    required this.Age,
    required this.Destination,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset("images/image.jpg", height: 130),
          ListTile(
            title: Text(
              'User Profile',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
          ListTile(
            title: Text('Name: $Username'),
          ),
          ListTile(
            title: Text('Email: $Email'),
          ),
          ListTile(
            title: Text('Phone: $Phone'),
          ),

          ListTile(
            title: Text('Destination: $Destination'),
          ),
        ],
      ),
    );
  }
}
