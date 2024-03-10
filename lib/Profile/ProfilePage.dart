import 'package:firebase_auth/firebase_auth.dart';
import 'package:drivetogether/firebase_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '../login_screen.dart';
import '/Profile/EditProfile.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();

  UserData userData = UserData(); // Instance to hold user data

  @override
  void initState() {
    super.initState();
    loadUserData(); // Load user data when the widget initializes
  }

  void signOutUser(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to the login page and clear the entire navigation stack
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
            (route) => false,
      );
    } catch (e) {
      // Handle sign-out errors, if any.
      print("Error signing out: $e");
    }
  }

  // Function to load user data from Firestore
  void loadUserData() async {
    String userId = getCurrentUserId();
    UserData loadedData = await getUserDataFromFirestore(userId);

    // Update the state with the loaded data
    setState(() {
      userData = loadedData;
      // Assign the loaded values to text controllers
      nameTextEditingController.text = userData.name;
      emailTextEditingController.text = userData.email;
      phoneTextEditingController.text = userData.phone;
    });
  }

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      // Handle the picked image as needed
    }
  }

  void saveProfileSettings() {
    // Implement saving profile settings if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                // Use the user's image URL if available, else use a placeholder
                backgroundImage: userData.imageUrl.isNotEmpty
                    ? NetworkImage(userData.imageUrl)
                    : AssetImage('images/profille.jpg') as ImageProvider,
              ),
            ),

            const SizedBox(height: 17),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (c) => EditProfile()));
                    },
                    style: ElevatedButton.styleFrom(
                      
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    ),
                    child: const Text(
                      "Edit Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 17),

            // Display user name
            Row(
              children: [
                Icon(Icons.person, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  'Name: ${userData.name}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 17),

            // Display user email
            Row(
              children: [
                Icon(Icons.email, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  'Email: ${userData.email}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Button for signing out
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: ElevatedButton(
                    onPressed: () {
                      // Implement sign out logic if needed
                      signOutUser(context);
                    },
                    style: ElevatedButton.styleFrom(
                      
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    ),
                    child: const Text(
                      "Signout",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
