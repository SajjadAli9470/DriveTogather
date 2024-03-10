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

class Ratings extends StatefulWidget {
  const Ratings({Key? key}) : super(key: key);

  @override
  State<Ratings> createState() => _RatingsState();
}

class _RatingsState extends State<Ratings> {
  TextEditingController RatingTextEditingController = TextEditingController();
  final CommonDrawer commonDrawer = CommonDrawer();
  int selectedRating = 1; // Default rating

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ratings'),
      ),
      drawer: commonDrawer.build(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 0, left: 30, right: 30, bottom: 30),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Image.asset("images/image.jpg", height: 100),
              ),
              SizedBox(height: 17),
              _buildRatingBar(context, selectedRating),
              SizedBox(height: 17),
              TextField(
                controller: RatingTextEditingController,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13, // Adjusted font size
                ),
                decoration: InputDecoration(
                  labelText: "Comments",
                  hintText: 'Comments (optional)',
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingBar(BuildContext context, int rating) {
    return Column(
      children: [
        const Text(
          "Rate Your Driver",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            5,
                (index) => IconButton(
              icon: Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
              ),
              onPressed: () {
                setState(() {
                  selectedRating = index + 1;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
