import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';

import 'MyDrawer.dart';

class CurrentActiveRidesPage extends StatefulWidget {
  const CurrentActiveRidesPage({super.key});

  @override
  _CurrentActiveRidesPageState createState() => _CurrentActiveRidesPageState();
}

class _CurrentActiveRidesPageState extends State<CurrentActiveRidesPage> {
  late List<Map<String, dynamic>> activeRides = [];

  // late BuildContext _context;

  @override
  void initState() {
    super.initState();
    fetchActiveRides();
  }

  Future<void> fetchActiveRides() async {
    String? currentUserId = await getCurrentUserId();

    if (currentUserId != null) {
      CollectionReference driverTrips = FirebaseFirestore.instance.collection(
          'DriverTrips');

      QuerySnapshot querySnapshot = await driverTrips
          .where('User 1 ID', isEqualTo: currentUserId)
          .get();

      QuerySnapshot querySnapshot2 = await driverTrips
          .where('User 2 ID', isEqualTo: currentUserId)
          .get();

      QuerySnapshot querySnapshot3 = await driverTrips
          .where('User 3 ID', isEqualTo: currentUserId)
          .get();

      // Combine the results
      List<QueryDocumentSnapshot> documents = [
        ...querySnapshot.docs,
        ...querySnapshot2.docs,
        ...querySnapshot3.docs,
      ];
      List<Map<String, dynamic>> ridesList = [];

      for (QueryDocumentSnapshot tripSnapshot in documents) {
        var tripData = tripSnapshot.data();

        if (tripData != null && tripData is Map<String, dynamic>) {

            ridesList.add({
              'documentId': tripSnapshot.id,
              'PostUserID': tripData['postuserId'],
              'Destination': tripData['destinationCity'],
              'StartLocation': tripData['startingLocation'],
              'Day': tripData['date'],
              'Time': tripData['time'],
              'NumberOfSeats': getBookedSeats(tripData, currentUserId),
              'PricePerSeat': double.parse(tripData['pricePerSeat'].toString()),
              'DriverName': tripData['DriverName'],
              'Rating': tripData['DriverRating'],
              'CarColor': tripData['DriverCarColor'],
              'DriverImage': tripData["DriveImg"],
            });
          }
        }

      setState(() {
        activeRides = ridesList;
      });
    }
  }
  int getBookedSeats(Map<String, dynamic> tripData, String? currentUserId) {
    if (currentUserId != null) {
      if (tripData['User 1 ID'] == currentUserId) {
        return tripData['User 1 Seats'] ?? 0;
      } else if (tripData['User 2 ID'] == currentUserId) {
        return tripData['User 2 Seats'] ?? 0;
      } else if (tripData['User 3 ID'] == currentUserId) {
        return tripData['User 3 Seats'] ?? 0;
      }
    }
    return 0;
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

  Future<String?> getCurrentUserId() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      return user.uid;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    // _context = context;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Current Active Rides"),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              for (var ride in activeRides)
                ExtendedRideCard(
                  documentId: ride['documentId'] ?? '',
                  postUserId: ride['postUserId'] ?? '',
                  Destination: ride['Destination'] ?? '',
                  Rating: ride['Rating'] ?? 0,
                  StartLocation: ride['StartLocation'] ?? '',
                  Day: ride['Day'] ?? '',
                  Time: ride['Time'] ?? '',
                  NumberOfSeats: ride['NumberOfSeats'] ?? 0,
                  PricePerSeat: ride['PricePerSeat'] ?? 0.0,
                  DriverName: ride['DriverName'] ?? '',
                  CarColor: ride['CarColor'] ?? '',
                  DriverImage: ride['DriverImage'] ?? '',
                  onPressedViewMap: () {
                    // Handle tap on "View On Map" button
                  },
                  onPressedChat: () {
                    // Handle tap on "Chat" button
                  },
                  onPressedCancelRide: () {
                    // Show the confirmation dialog
                    showCancelRideConfirmationDialog(
                      ride['documentId'] ?? '',
                      ride['postUserId'] ?? '',
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showCancelRideConfirmationDialog(String documentId,
      String postUserId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Ride'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to cancel this ride?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                // Perform the cancellation logic
                await cancelRide(documentId, postUserId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> cancelRide(String documentId, String postUserId) async {
    try {
      // Get the document reference
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('DriverTrips')
          .doc(documentId);

      // Get the trip data
      DocumentSnapshot tripSnapshot = await documentReference.get();
      var tripData = tripSnapshot.data();

      if (tripData != null && tripData is Map<String, dynamic>) {
        // Identify the user ID field based on the current user
        String currentUserId = await getCurrentUserId() ?? '';
        String userSeatsField = '';

        if (currentUserId == tripData['User 1 ID']) {
          userSeatsField = 'User 1 Seats';
          await documentReference.update({
            'User 1 ID': null,
            'User 1 Seats': null,
          });
        } else if (currentUserId == tripData['User 2 ID']) {
          userSeatsField = 'User 2 Seats';
          await documentReference.update({
            'User 2 ID': null,
            'User 2 Seats': null,
          });
        } else if (currentUserId == tripData['User 3 ID']) {
          userSeatsField = 'User 3 Seats';
          await documentReference.update({
            'User 3 ID': null,
            'User 3 Seats': null,
          });
        }

        // Update the available seats based on the user's cancellation
        int availableSeats = tripData['seats'] + tripData[userSeatsField];
        await documentReference.update({
          'seats': availableSeats,
        });
      }
      // Close the current dialog
      Navigator.pop(context);

      // Show a success popup
      await showCancellationSuccessPopup();
    } catch (e) {
      print('Error cancelling ride: $e');
      // Handle the error as needed
    }
  }


  Future<void> showCancellationSuccessPopup() async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancellation Successful'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You have cancelled the ride successfully.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the success popup
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyDrawer()),
                );
              },
            ),
          ],
        );
      },
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
  final String postUserId;
  final VoidCallback onPressedViewMap;
  final VoidCallback onPressedChat;
  final VoidCallback onPressedCancelRide;

  const ExtendedRideCard({super.key, 
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
    required this.postUserId,
    required this.onPressedViewMap,
    required this.onPressedChat,
    required this.onPressedCancelRide,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 18.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
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
          ListTile(
            title: Text('Driver: $DriverName'),
            subtitle: Text('Car Color: $CarColor'),
          ),
          ListTile(
            title: Text('Destination: $Destination'),
            subtitle: Text('Start Location: $StartLocation'),
          ),
          ListTile(
            title: Text('Day: $Day'),
            subtitle: Text('Time: $Time'),
          ),
          ListTile(
            title: Text('Seats Booked: $NumberOfSeats'),
            subtitle: Text('Price per Seat: \$${PricePerSeat.toStringAsFixed(2)}'),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: onPressedViewMap,
                style: ElevatedButton.styleFrom(
                  
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text(
                  "View On Map",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: onPressedChat,
                style: ElevatedButton.styleFrom(
                  
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text(
                  "Chat",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: onPressedCancelRide,
                style: ElevatedButton.styleFrom(
                  
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text(
                  "Cancel Ride",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: CurrentActiveRidesPage(),
  ));
}
