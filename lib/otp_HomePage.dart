import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/MyDrawer.dart';
import 'package:get/get.dart';
import 'login_screen.dart'; // Import the LoginPage widget here

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController whereTextEditingController = TextEditingController();

  void signOutUser(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => LoginPage()));
    } catch (e) {
      // Handle sign-out errors, if any.
      print("Error signing out: $e");
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white54,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset('images/image.jpg', height: 120)],
          ),
          actions: [
            ElevatedButton(
              onPressed: (){
                signOutUser(context);
              }, // Call the sign-out function
              child: Text("Sign Out"),
            ),
          ],
        ),
      ),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 17),
            TextField(
              showCursor: false,
              autofocus: false,
              controller: whereTextEditingController,
              style: const TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: "Where To Go?",
                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black),
                ),
                labelStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                ),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
