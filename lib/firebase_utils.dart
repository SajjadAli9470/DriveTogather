import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


String getCurrentUserId() {
  User? user = FirebaseAuth.instance.currentUser;
  return user?.uid ?? '';
}

class UserData {
  String name = '';
  String email = '';
  String phone = ''; // Assuming you have a phone field in your data
  String imageUrl = '';
}

Future<UserData> getUserDataFromFirestore(String userId) async {
  UserData userData = UserData();
  CollectionReference drivers = FirebaseFirestore.instance.collection('drivers');

  try {
    DocumentSnapshot userDoc = await drivers.doc(userId).get();

    if (userDoc.exists) {
      Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;

      if (data != null) {
        userData.name = data['name'] ?? '';
        userData.email = data['email'] ?? '';
        userData.phone = data['phone'] ?? '';
        userData.imageUrl = data['img_url'] ?? '';
      }
    }
  } catch (e) {
    print("Error fetching user data: $e");
  }

  return userData;
}
