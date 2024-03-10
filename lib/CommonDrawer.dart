import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivetogether/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Active_Trips.dart';
import 'Chatlist.dart';
import 'Current_Active_Rides.dart';
import 'Wheretogo.dart';
import 'firebase_utils.dart'; // Import your utility functions and classes
import '/MyDrawer.dart';
import '/Profile/ProfilePage.dart';
import '/Rides/Logout.dart';
import '/Rides/Ratings.dart';
import '/Rides/Ride.dart';
import '/Rides/User.dart';
import '/PostTripforDriver/post_Trip_For_Driver.dart';
import '/Rides/ChatPage.dart';

class CommonDrawer extends StatelessWidget {
  const CommonDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    const startColor = Color.fromARGB(255, 189, 172, 22);
    return Drawer(
      child: FutureBuilder<UserData>(
        // Use FutureBuilder to fetch user data asynchronously
        future: getUserDataFromFirestore(getCurrentUserId()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // If the Future is still running, show a loading indicator
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // If there's an error, show an error message
            return Text('Error: ${snapshot.error}');
          } else {
            // If the Future is complete, build the UI with fetched user data
            UserData userData = snapshot.data!;

            return Column(
              children: <Widget>[
                Container(
                  color: Theme.of(context).primaryColor,
                  width: double.infinity,
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const ProfilePage()),
                          );
                        },
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 50.0),
                              child: CircleAvatar(
                                radius: 50,
                                // Use the user's image URL if available, else use a placeholder
                                backgroundImage: userData.imageUrl.isNotEmpty
                                    ? NetworkImage(userData.imageUrl)
                                    : const AssetImage('images/profille.jpg')
                                        as ImageProvider,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                // Use the fetched user name
                                userData.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 3),
                            StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("drivers")
                                    .doc(getCurrentUserId())
                                    .snapshots(),
                                builder: (c, s) {
                                  double rating = 0;
                                  if (s.hasData) {
                                    rating = double.parse(
                                        (s.data!['rating'] ?? '0').toString());
                                  }
                                  return
                                  
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(
                                          rating >= 1
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: startColor,
                                        ),
                                        onPressed: null,
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          rating >= 2
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: startColor,
                                        ),
                                        onPressed: null,
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          rating >= 3
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: startColor,
                                        ),
                                        onPressed: null,
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          rating >= 4
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: startColor,
                                        ),
                                        onPressed: null,
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          rating >= 5
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: startColor,
                                        ),
                                        onPressed: () {},
                                      ),
                                    ],
                                  );

                                  // ListTile(
                                  //   title: Text("Rating : ${rating.toStringAsFixed(1)}"),
                                  // );
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // List of ListTiles
                ListTile(
                  title: const Text("Home", style: TextStyle(fontSize: 17)),
                  leading: const Icon(Icons.home),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => const MyDrawer()));
                  },
                ),
                ListTile(
                  title: const Text("Post a Trips",
                      style: TextStyle(fontSize: 17)),
                  leading: const Icon(Icons.local_taxi),
                  onTap: () {
                    // Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => const PostTripForDrivers()));
                  },
                ),
                // ListTile(
                //   title: const Text("Chat", style: TextStyle(fontSize: 17)),
                //   leading: const Icon(Icons.home),
                //   onTap: () {
                //     Navigator.push(context,
                //         MaterialPageRoute(builder: (c) => ChatPage(id: '')));
                //   },
                // ),
                ListTile(
                  title:
                      const Text("All Trips", style: TextStyle(fontSize: 17)),
                  leading: const Icon(Icons.border_all_rounded),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => const ActiveTripsPage()));
                  },
                ),
                ListTile(
                  title:
                      const Text("ChatsList", style: TextStyle(fontSize: 17)),
                  leading: const Icon(Icons.chat),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => ChatListPage(
                                  userId: getCurrentUserId(),
                                )));
                  },
                ),
                ListTile(
                  title: const Text("Signout", style: TextStyle(fontSize: 17)),
                  leading: const Icon(Icons.logout),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) {
                      return const LoginPage();
                    }), (route) => false);
                  },
                ),
                // ... add other ListTiles as needed
              ],
            );
          }
        },
      ),
    );
  }
}
