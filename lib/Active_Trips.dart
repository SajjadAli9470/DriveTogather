import 'package:drivetogether/HomePage.dart';
import 'package:drivetogether/firebase_utils.dart';
import 'package:drivetogether/model/tripModel.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'MyDrawer.dart';
import 'TripDetails.dart';
// String? getCurrentUserId() {
//   FirebaseAuth auth = FirebaseAuth.instance;
//   User? user = auth.currentUser;

//   if (user != null) {
//     return user.uid;
//   }

//   return null;
// }
class ActiveTripsPage extends StatefulWidget {
  const ActiveTripsPage({super.key});

  @override
  _ActiveTripsPageState createState() => _ActiveTripsPageState();
}

class _ActiveTripsPageState extends State<ActiveTripsPage> {
  late List<Trip> activeTrips = [];
  int selectTrips = 0;
  @override
  void initState() {
    super.initState();
    fetchActiveTrips();
  }

  Future<void> fetchActiveTrips() async {
    String? currentUserId = getCurrentUserId();

    CollectionReference Trips = FirebaseFirestore.instance.collection('Trips');

    QuerySnapshot querySnapshot =
        await Trips.where('driverId', isEqualTo: currentUserId).get();

    List<Trip> tripsList = [];
    tripsList.clear();
    for (QueryDocumentSnapshot tripSnapshot in querySnapshot.docs) {
      var tripData = tripSnapshot.data();

      if (tripData != null && tripData is Map<String, dynamic>) {
        tripsList.add(Trip.fromMap(tripSnapshot.data() as Map));
      }
    }

    setState(() {
      activeTrips = tripsList;
    });
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
        title: const Text("Active Trips"),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      selectTrips = 0;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: selectTrips != 0
                                ? Colors.blue
                                : Colors.transparent),
                        color:
                            selectTrips == 0 ? Colors.blue : Colors.transparent,
                        borderRadius: BorderRadius.circular(10)),
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Center(
                        child: Text(
                      "Pending Trips",
                      style: TextStyle(
                          color: selectTrips == 0 ? Colors.white : Colors.blue,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      selectTrips = 1;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: selectTrips != 1
                                ? Colors.blue
                                : Colors.transparent),
                        color:
                            selectTrips == 1 ? Colors.blue : Colors.transparent,
                        borderRadius: BorderRadius.circular(10)),
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Center(
                        child: Text(
                      "Finish Trips",
                      style: TextStyle(
                          color: selectTrips == 1 ? Colors.white : Colors.blue,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                )
              ],
            ),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Trips')
                      .where('driverId', isEqualTo: getCurrentUserId())
                      .snapshots(),
                  builder: (context, snap) {
                    List<Trip> activeTrips = [];
                    List<Trip> activeTripsTemp = [];
                    if (snap.hasData) {
                      activeTripsTemp.addAll(
                          snap.data!.docs.map((e) => Trip.fromMap(e.data())));

                      activeTrips = activeTripsTemp
                          .where((element) => element.finish == selectTrips)
                          .toList();
                    }

                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: activeTrips.length,
                        itemBuilder: (context, index) {
                          final trip = activeTrips[index];

                          return ExtendedTripCard(
                            trip: trip,
                            onCancel: trip.finish == 1
                                ? null
                                : () =>
                                    showCancelTripPopup(context, trip),
                            onViewDetails: () => viewTripDetails(
                              trip.tripId,
                            ),
                            onFinishTrip: trip.finish == 1
                                ? null
                                : () => finishTrip(trip),
                            rateTheTrip: trip.finish != 1 ? null : () {},
                          );
                        });
                  }),
            )
            // for (var trip in activeTrips)
            //   ExtendedTripCard(
            //     trip: trip,
            //     onCancel: trip.finish == 1 ? null : () => showCancelTripPopup(context, trip.tripId),
            //     onViewDetails: () => viewTripDetails(
            //       trip.tripId,
            //     ),
            //     onFinishTrip:
            //         trip.finish == 1 ? null : () => finishTrip(trip),
            //     rateTheTrip: trip.finish != 1 ? null :  (){

            //     },
            //   ),
          ],
        ),
      ),
    );
  }

  Future<void> showCancelTripPopup(
      BuildContext context, Trip trip) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Trip'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to cancel this trip?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                cancelTrip(trip);
                Navigator.of(context).pop();
                showCancellationConfirmationPopup(context);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  // Future<void> cancelTrip(String documentId) async {
  //   await FirebaseFirestore.instance
  //       .collection('Trips')
  //       .doc(documentId)
  //       .delete();
  // }

  Future<void> showCancellationConfirmationPopup(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Trip Canceled'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You have canceled this trip.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate back to the homepage
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(builder: (context) => const MyDrawer()),
                // );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void viewTripDetails(String documentId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripDetailsPage(
          documentId: documentId,
        ),
      ),
    );
  }

  void finishTrip(Trip trip) async {
    final UpdatedTrip = trip.copyWith(finish: 1);
    await FirebaseFirestore.instance
        .collection('Trips')
        .doc(trip.tripId)
        .update(UpdatedTrip.toMap());
    // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    //   return const HomePage();
    // }));
  }

  void cancelTrip(Trip trip) async {
    final UpdatedTrip = trip.copyWith(finish: -1);
    await FirebaseFirestore.instance
        .collection('Trips')
        .doc(trip.tripId)
        .update(UpdatedTrip.toMap());
    // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    //   return const HomePage();
    // }));
  }
}

class ExtendedTripCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback? onCancel;
  final VoidCallback onViewDetails;
  final VoidCallback? onFinishTrip;
  final VoidCallback? rateTheTrip;

  const ExtendedTripCard(
      {super.key,
      required this.trip,
      this.onCancel,
      required this.onViewDetails,
      this.onFinishTrip,
      this.rateTheTrip});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black.withOpacity(0.2))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                trip.driverImage,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            title: Text('Driver: ${trip.driverName}'),
            subtitle: Text('Car Color: ${trip.carColor}'),
          ),
          ListTile(
            title: Text(
                'Destination: ${trip.destinationLocation.details.locality}'),
            subtitle: Text(
                'Start Location: ${trip.startingLocation.details.locality}'),
          ),
          ListTile(
            title: Text('Day: ${trip.date}'),
            subtitle: Text('Time: ${trip.time}'),
          ),
          ListTile(
            title: Text('Seats Available: ${trip.seat}'),
            subtitle: Text('Price per Seat: \$${trip.pricePerSeat}'),
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("drivers")
                  .doc(trip.driverId)
                  .snapshots(),
              builder: (c, s) {
                double rating = 0;
                if (s.hasData) {
                  rating =
                      double.parse((s.data!['rating'] ?? '0').toString());
                }
                return ListTile(
                  title: Text("Rating : ${rating.toStringAsFixed(1)}"),
                );
              }),
          
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (onFinishTrip != null)
                ElevatedButton(
                  onPressed: onCancel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                  ),
                  child: const Text(
                    "Cancel Trip",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ElevatedButton(
                onPressed: onViewDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                ),
                child: const Text(
                  "View Details",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              if (onFinishTrip != null)
                ElevatedButton(
                  onPressed: onFinishTrip,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                  ),
                  child: const Text(
                    "Finish Trip",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              // if (rateTheTrip != null && getCurrentUserId() != trip.driverId)
              //   ElevatedButton(
              //     onPressed: rateTheTrip,
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.green,
              //       padding: const EdgeInsets.symmetric(
              //           horizontal: 10, vertical: 10),
              //     ),
              //     child: const Text(
              //       "Rate this Trip",
              //       style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 16,
              //         fontWeight: FontWeight.normal,
              //       ),
              //     ),
              //   ),
            ],
          ),
        ],
      ),
    );
  }
}
