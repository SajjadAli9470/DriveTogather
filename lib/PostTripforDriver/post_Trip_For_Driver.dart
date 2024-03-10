import 'dart:developer';

import 'package:drivetogether/MapsScreens/getStartOrTarget.dart';
import 'package:drivetogether/model/tripModel.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../firebase_utils.dart';
import 'package:intl/intl.dart';
import '/CommonDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostTripForDrivers extends StatefulWidget {
  const PostTripForDrivers({super.key});

  @override
  State<PostTripForDrivers> createState() => _PostTripForDriversState();
}

class _PostTripForDriversState extends State<PostTripForDrivers> {
  final CommonDrawer commonDrawer = const CommonDrawer();

  @override
  void initState() {
    getCurrentLocation();
    // TODO: implement initState
    super.initState();
  }

// Location

  TextEditingController startingPositionController = TextEditingController();
  TextEditingController endingPositionController = TextEditingController();
  LatLng? startingPosition;
  LatLng? endingPosition;
  Placemark? startingPlaceMark;
  Placemark? endPlaceMark;

  getCurrentLocation() async {
    final permission = await Geolocator.checkPermission();
    // log(permission.toString());
    if (permission != LocationPermission.denied &&
        permission != LocationPermission.deniedForever) {
      if (startingPosition == null) {
        final currentPositions = await Geolocator.getCurrentPosition();
        setState(() {
          startingPosition =
              LatLng(currentPositions.latitude, currentPositions.longitude);
        });
      }
    } else {
      await Geolocator.requestPermission();
      getCurrentLocation();
    }
  }

  TextEditingController destinationcityTextEditingController =
      TextEditingController();
  TextEditingController startinglocTextEditingController =
      TextEditingController();
  TextEditingController priceTextEditingController = TextEditingController();
  TextEditingController timeTextEditingController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        timeTextEditingController.text = picked.format(context);
      });
    }
  }

  TextEditingController seatsTextEditingController = TextEditingController();
  TextEditingController dateTextEditingController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      final formattedDate = DateFormat("dd-MM-yyyy").format(picked);
      setState(() {
        selectedDate = picked;
        dateTextEditingController.text = formattedDate;
      });
    }
  }

  int _convertToInt(String value) {
    // Use int.tryParse to safely convert the string to an integer
    // Return 0 if the conversion fails
    return int.tryParse(value) ?? 0;
  }

  Future<void> _submitForm() async {
    // Validate form entries before submitting
    if (_validateForm()) {
      // Get a reference to the "DriverTrips" collection
      CollectionReference driverTrips =
          FirebaseFirestore.instance.collection('Trips');

      // Generate a new document with a random ID
      DocumentReference newTripRef = driverTrips.doc();

      // Get the current user's ID (you can replace this with the appropriate user ID)
      String userId = getCurrentUserId();

      DocumentSnapshot<Map<String, dynamic>> driverSnapshot =
          await FirebaseFirestore.instance
              .collection('drivers')
              .doc(getCurrentUserId())
              .get();

      String driverName = "";
      String driveImg = "";
      String drivercarcolor = "";
      int driverrating = 0;

      log(userId.toString());

      try {
        if (driverSnapshot.data() != null) {
          driverName = driverSnapshot.data()!["name"];
          driveImg = driverSnapshot.data()!["img_url"];
          drivercarcolor = driverSnapshot.data()!["carColor"];
          
        }

        // Save the trip details to Firestore
        await newTripRef.set(Trip(
            tripId: newTripRef.id,
            userId: userId,
            driverId: getCurrentUserId(),
            startingLocation: RouteLocation(
                details: startingPlaceMark!,
                lng: startingPosition!.longitude,
                lat: startingPosition!.latitude),
            destinationLocation: RouteLocation(
                details: endPlaceMark!,
                lng: endingPosition!.longitude,
                lat: endingPosition!.latitude),
            date: selectedDate,
            time: timeTextEditingController.text,
            seat: _convertToInt(seatsTextEditingController.text),
            pricePerSeat: priceTextEditingController.text,
            driverName: driverName,
            driverImage: driveImg,
            carColor: drivercarcolor,
            driverRating: 0,
            finish: 0,
            bookedSeats: []).toMap());

        log("trip posted");
      } catch (e) {
        log("Error while posting a trip");
      }
      // await newTripRef.set({
      //   'postuserId': userId,
      //   'destinationCity': destinationcityTextEditingController.text.toLowerCase(),
      //   'startingLocation': startinglocTextEditingController.text,
      //   'date': dateTextEditingController.text,
      //   'time': timeTextEditingController.text,
      //   'seats': _convertToInt(seatsTextEditingController.text),
      //   'pricePerSeat': priceTextEditingController.text,
      //   'DriverName' : driverName,
      //   'DriveImg': driveImg,
      //   'DriverCarColor': drivercarcolor,
      //   'DriverRating' : driverrating,
      //   'DriverID' : getCurrentUserId(),
      //   'User 1 ID': null,
      //   'User 2 ID': null,
      //   'User 3 ID': null,
      //   'User 1 Seats': null,
      //   'User 2 Seats': null,
      //   'User 3 Seats': null,
      // });

      // Optionally, you can clear the form fields after submitting
      // _clearForm();

      // Display a success message or navigate to another screen
      // For example, you can show a SnackBar with a success message:
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Trip submitted successfully!"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Validate form entries
  bool _validateForm() {
    return _formKeynew.currentState!.validate();
  }

  // Clear form fields after submission
  void _clearForm() {
    destinationcityTextEditingController.clear();
    startinglocTextEditingController.clear();
    dateTextEditingController.clear();
    timeTextEditingController.clear();
    seatsTextEditingController.clear();
    priceTextEditingController.clear();
    startingPositionController.clear();
    endingPositionController.clear();
  }

  final _formKeynew = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trip post"),
      ),
      drawer: commonDrawer.build(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(27.0),
          child: Form(
            key: _formKeynew,
            child: Column(
              children: [
                // const SizedBox(height: 20),
                // Padding(
                //   padding: const EdgeInsets.all(20.0),
                //   child: Image.asset("images/image.jpg", height: 120),
                // ),
                // const SizedBox(
                //   height: 20,
                // ),
                const Text(
                  "POST A TRIP",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(height: 17),
                TextFormField(
                  controller: endingPositionController,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: "Destination City",
                    suffixIcon: startingPosition != null
                        ? InkWell(
                            onTap: () {
                              log("tapped");
                              Get.to(MapScreen(
                                  lotlocation: (positions) async {
                                    List<Placemark> placemarks =
                                        await placemarkFromCoordinates(
                                            positions.latitude,
                                            positions.longitude);
                                    setState(() {
                                      endPlaceMark = placemarks.first;
                                      endingPosition = LatLng(
                                          positions.latitude,
                                          positions.longitude);
                                      endingPositionController.text =
                                          "${placemarks.first.locality},${placemarks.first.administrativeArea}";
                                    });
                                  },
                                  initLoc: endingPosition != null
                                      ? endingPosition!
                                      : startingPosition!));
                            },
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.black,
                            ))
                        : null,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                  validator: (value) {
                    if (endPlaceMark == null ||
                        endingPosition == null ||
                        value == null) {
                      return 'Please select your destination';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 17),
                TextFormField(
                  controller: startingPositionController,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: "Starting location",
                    suffixIcon: startingPosition != null
                        ? InkWell(
                            onTap: () {
                              log("tapped");
                              Get.to(MapScreen(
                                  lotlocation: (positions) async {
                                    List<Placemark> placemarks =
                                        await placemarkFromCoordinates(
                                            positions.latitude,
                                            positions.longitude);

                                    setState(() {
                                      startingPlaceMark = placemarks.first;
                                      startingPosition = LatLng(
                                          positions.latitude,
                                          positions.longitude);

                                      startingPositionController.text =
                                          "${placemarks.first.locality},${placemarks.first.administrativeArea}";
                                    });
                                  },
                                  initLoc: startingPosition!));
                            },
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.black,
                            ))
                        : null,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                  validator: (value) {
                    if (startingPlaceMark == null ||
                        value == null ||
                        startingPosition == null) {
                      return 'Please select your starting location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 17),
                TextFormField(
                  controller: dateTextEditingController,
                  keyboardType: TextInputType.text,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Pick A Date",
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the date';
                    }
                    return null;
                  },
                  onTap: () {
                    _selectDate(context);
                  },
                ),
                const SizedBox(height: 17),
                TextFormField(
                  controller: timeTextEditingController,
                  keyboardType: TextInputType.datetime,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: "Time",
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a time';
                    }
                    return null;
                  },
                  onTap: () {
                    _selectTime(context);
                  },
                ),
                const SizedBox(height: 17),
                TextFormField(
                  controller: seatsTextEditingController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Number of Seat",
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter number of seats available';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 17),
                TextFormField(
                  controller: priceTextEditingController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Price per Seat",
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the price per seat';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                if (startingPosition != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 0),
                      ),
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
