import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../bookride.dart';

class Ridepage extends StatefulWidget {
  final String destination;
  final String date;

  Ridepage({required this.destination, required this.date});

  @override
  _RidepageState createState() => _RidepageState();
}

class _RidepageState extends State<Ridepage> {
  late List<Map<String, dynamic>> rides = [];

  @override
  void initState() {
    super.initState();

  }


  Future<String> fetchDriverImage(String userId) async {
    try {
      var imageUrl = await firebase_storage.FirebaseStorage.instance
          .ref('drivers/$userId.jpg')
          .getDownloadURL();
      return imageUrl;
    } catch (e) {
      // Handle error, return a default image URL, or leave it empty based on your requirements.
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ride Profile"),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 0, left: 30, right: 30, bottom: 30),
          child: Column(
            children: [
              const SizedBox(height: 20),
              for (var ride in rides)
                ExtendedRideCard(
                  documentId: ride['documentId'],
                  Destination: ride['Destination'],
                  Rating: ride['Rating'],
                  StartLocation: ride['StartLocation'],
                  Day: ride['Day'],
                  Time: ride['Time'],
                  NumberOfSeats: ride['NumberOfSeats'],
                  PricePerSeat: ride['PricePerSeat'],
                  DriverName: ride['DriverName'],
                  CarColor: ride['CarColor'],
                  PostUserID:ride['PostUserID'],
                  DriverImage: ride['DriverImage'],
                  onPressed: () {
                    _navigateToBookRidePage(ride);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToBookRidePage(Map<String, dynamic> rideDetails) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookRidePage(rideDetails: rideDetails),
      ),
    );
  }
}

class ExtendedRideCard extends StatelessWidget {
  final String Destination;
  final String StartLocation;
  final String Day;
  final String Time;
  final int NumberOfSeats;
  final double PricePerSeat;
  final String DriverName;
  final String CarColor;
  final String DriverImage;
  final String documentId;
  final int Rating;
  final String PostUserID;

  final VoidCallback onPressed;

  ExtendedRideCard({
    required this.Destination,
    required this.StartLocation,
    required this.Day,
    required this.Time,
    required this.NumberOfSeats,
    required this.PricePerSeat,
    required this.DriverName,
    required this.CarColor,
    required this.DriverImage,
    required this.documentId,
    required this.Rating,
    required this.onPressed,
    required this.PostUserID,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 18.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First column for the image
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.network(
                    DriverImage,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Second column for details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Driver: $DriverName',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Car Color: $CarColor',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Destination: $Destination',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Start Location: $StartLocation',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Day: $Day',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Time: $Time',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Seats Available: $NumberOfSeats',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Price per Seat: \$${PricePerSeat.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: ElevatedButton(
                          onPressed: onPressed,
                          style: ElevatedButton.styleFrom(
                            
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                          ),
                          child: const Text(
                            "Book Now",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
