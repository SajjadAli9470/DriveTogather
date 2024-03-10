import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../MyDrawer.dart';
import '../otp_HomePage.dart';
import '../authentication/Signup_As_Drivers.dart';
import '../login_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  startTimer() {
    Timer(const Duration(seconds: 4), () async {
      // Check if the user is already authenticated
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // If the user is authenticated, check for the Firestore document
        final snapshot = await FirebaseFirestore.instance.collection('drivers').doc(user.uid).get();

        if (snapshot.exists) {
          // User document exists in Firestore, redirect to HomePage.
          Navigator.push(context, MaterialPageRoute(builder: (context) => const MyDrawer()));
        } else {
          // User document does not exist, redirect to SignUpScreen.
          Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
        }
      } else {
        // If the user is not authenticated, redirect to LoginPage.
        Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/image.jpg", height: 260),
              const SizedBox(height: 15),
              const Text(
                "Drive Together",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
