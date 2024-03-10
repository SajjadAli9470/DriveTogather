import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'MyDrawer.dart';
import 'Rides/ChatPage.dart';

class BookRidePage extends StatelessWidget {
  final Map<String, dynamic> rideDetails;

  const BookRidePage({super.key, required this.rideDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Ride"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RideDetailsCard(rideDetails: rideDetails),
      ),
      // Add additional booking logic or UI as needed
    );
  }
}

class RideDetailsCard extends StatefulWidget {
  final Map<String, dynamic> rideDetails;

  const RideDetailsCard({super.key, required this.rideDetails});

  @override
  _RideDetailsCardState createState() => _RideDetailsCardState();
}

class _RideDetailsCardState extends State<RideDetailsCard> {
  int selectedSeats = 1;
  late List<int> dropdownOptions;

  @override
  void initState() {
    super.initState();
    generateDropdownOptions();
  }

  void generateDropdownOptions() {
    int numberOfSeats = widget.rideDetails['NumberOfSeats'];
    dropdownOptions = List.generate(numberOfSeats, (index) => index + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 60,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.network(
                  widget.rideDetails['DriverImage'],
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Text(
            'Driver: ${widget.rideDetails['DriverName']}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Car Color: ${widget.rideDetails['CarColor']}',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Destination: ${widget.rideDetails['Destination']}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Start Location: ${widget.rideDetails['StartLocation']}',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Day: ${widget.rideDetails['Day']}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Time: ${widget.rideDetails['Time']}',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Seats Available: ${widget.rideDetails['NumberOfSeats']}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Price per Seat: \$${widget.rideDetails['PricePerSeat'].toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Rating: ${widget.rideDetails['Rating'].toString()}',
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (widget.rideDetails['NumberOfSeats'] > 1)
                Expanded(
                  child: Column(
                    children: [
                      const Text('Select Number of Seats:'),
                      dropdownOptions.isNotEmpty
                          ? DropdownButton<int>(
                              value: selectedSeats,
                              onChanged: (value) {
                                setState(() {
                                  selectedSeats = value!;
                                });
                              },
                              items: dropdownOptions.map((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text(value.toString()),
                                );
                              }).toList(),
                            )
                          : const Text('All seats are reserved'),
                    ],
                  ),
                ),
              if (widget.rideDetails['NumberOfSeats'] == 1)
                const Expanded(
                  child: Column(
                    children: [
                      Text('Select Number of Seats:'),
                      Text('1'),
                    ],
                  ),
                ),
              if (widget.rideDetails['NumberOfSeats'] == 0)
                const Expanded(
                  child: Column(
                    children: [
                      Text('All seats are reserved'),
                    ],
                  ),
                ),
              if (widget.rideDetails['NumberOfSeats'] > 0)
                ElevatedButton(
                  onPressed: widget.rideDetails['NumberOfSeats'] > 0
                      ? () {
                          bookRide(
                              widget.rideDetails['documentId'], selectedSeats);
                        }
                      : null, // Disable button if no seats available
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
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
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  String chatRoomId =
                      '${getCurrentUserId()}${widget.rideDetails["UsersID"]}';
                  final DocumentSnapshot<Map<String, dynamic>> chatRoomDoc =
                      await FirebaseFirestore.instance
                          .collection("chats")
                          .doc(chatRoomId)
                          .get();
                  if (!chatRoomDoc.exists) {
                    await FirebaseFirestore.instance
                        .collection("chats")
                        .doc(chatRoomId)
                        .set({
                      "driver_id": getCurrentUserId(),
                      "driver_name":
                          FirebaseAuth.instance.currentUser!.displayName!,
                      "driver_image":
                          FirebaseAuth.instance.currentUser!.photoURL!,
                      "user_id": widget.rideDetails["UsersID"],
                      "user_name": widget.rideDetails["name"],
                      "user_image": widget.rideDetails["img_url"]
                    });
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) => ChatPage(
                        id: widget.rideDetails["PostUserID"],
                        name: widget.rideDetails["DriverName"],
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text(
                  "Chat Now",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Add your "View On Map" logic here
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text(
                  "View On Map",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> bookRide(String documentId, int selectedSeats) async {
    String? currentUserId = getCurrentUserId();

    if (currentUserId != null) {
      CollectionReference driverTrips =
          FirebaseFirestore.instance.collection('DriverTrips');

      DocumentSnapshot tripSnapshot = await driverTrips.doc(documentId).get();
      var tripData = tripSnapshot.data() as Map<String, dynamic>?;

      if (tripData != null) {
        int availableSeats = tripData['seats'] ?? 0;

        if (tripData['User 1 ID'] == currentUserId ||
            tripData['User 2 ID'] == currentUserId ||
            tripData['User 3 ID'] == currentUserId) {
          // User has already booked this trip
          showPopup(
            "You've already booked this trip. Do you want to book more seats?",
            selectedSeats,
          );
          return; // Exit the function to prevent showing the success popup
        }

        if (availableSeats >= selectedSeats) {
          // Check if there are enough available seats

          if (tripData['User 1 ID'] == null) {
            // User 1 ID and Seats
            await driverTrips.doc(documentId).update({
              'User 1 ID': currentUserId,
              'User 1 Seats': selectedSeats,
              'seats': availableSeats - selectedSeats,
            });
          } else if (tripData['User 2 ID'] == null &&
              tripData['User 1 ID'] != currentUserId) {
            // User 2 ID and Seats
            await driverTrips.doc(documentId).update({
              'User 2 ID': currentUserId,
              'User 2 Seats': selectedSeats,
              'seats': availableSeats - selectedSeats,
            });
          } else if (tripData['User 3 ID'] == null &&
              tripData['User 1 ID'] != currentUserId &&
              tripData['User 2 ID'] != currentUserId) {
            // User 3 ID and Seats
            await driverTrips.doc(documentId).update({
              'User 3 ID': currentUserId,
              'User 3 Seats': selectedSeats,
              'seats': availableSeats - selectedSeats,
            });
          }

          // Refresh dropdown options after booking
          generateDropdownOptions();

          // Show success popup
          showSuccessPopup(context);
        } else {
          showPopup(
              "Not enough available seats. Please choose a smaller number.",
              selectedSeats);
        }
      }
    } else {
      print('User is not authenticated.');
    }
  }

  String? getCurrentUserId() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      return user.uid;
    }

    return null;
  }

  void showSuccessPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Booking Successful"),
          content: const Text("You have successfully booked a trip."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the success popup
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyDrawer()),
                );
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void showPopup(String message, int selectedSeats) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Booking Failed"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
            if (message.contains("already booked this trip"))
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  showConfirmationDialog(selectedSeats);
                },
                child: const Text("Yes"),
              ),
          ],
        );
      },
    );
  }

  void showConfirmationDialog(int selectedSeats) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Booking Confirmation"),
          content: const Text("Do you want to book more seats?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                updateDatabase(selectedSeats);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  void updateDatabase(int selectedSeats) async {
    // Your database update logic here
    // Example: update seats for User 1
    String? currentUserId = getCurrentUserId();
    String documentId = widget.rideDetails['documentId'];

    CollectionReference driverTrips =
        FirebaseFirestore.instance.collection('DriverTrips');
    DocumentSnapshot tripSnapshot = await driverTrips.doc(documentId).get();
    var tripData = tripSnapshot.data() as Map<String, dynamic>?;

    if (tripData != null) {
      int availableSeats = tripData['seats'] ?? 0;
      int user1Seats = tripData['User 1 Seats'] ?? 0;
      int user2Seats = tripData['User 2 Seats'] ?? 0;
      int user3Seats = tripData['User 3 Seats'] ?? 0;

      if (tripData['User 1 ID'] == currentUserId) {
        // User 1 has already booked this trip, add more seats
        await driverTrips.doc(documentId).update({
          'User 1 Seats': user1Seats + selectedSeats,
          'seats': availableSeats - selectedSeats,
        });
      } else if (tripData['User 2 ID'] == currentUserId) {
        // User 2 has already booked this trip, add more seats
        await driverTrips.doc(documentId).update({
          'User 2 Seats': user2Seats + selectedSeats,
          'seats': availableSeats - selectedSeats,
        });
      } else if (tripData['User 3 ID'] == currentUserId) {
        // User 3 has already booked this trip, add more seats
        await driverTrips.doc(documentId).update({
          'User 3 Seats': user3Seats + selectedSeats,
          'seats': availableSeats - selectedSeats,
        });
      }

      // Refresh dropdown options after booking
      generateDropdownOptions();

      // Show success popup
      showSuccessPopup(context);
    }
  }
}
