import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectchashmart/Home/Shareit.dart';
import 'package:projectchashmart/Home/cart.dart';
import 'package:projectchashmart/Home/favourite.dart';
import 'package:projectchashmart/Support/help.dart';
import 'dart:ui';
import '../Profile/EditProfile.dart';
import 'AboutUsPage.dart';
import 'DashBoardPage.dart';
import 'ReviewRateApp.dart';

class ZoomIconButton extends StatefulWidget {
  final IconData icon;
  final Function onPressed;

  ZoomIconButton({required this.icon, required this.onPressed});

  @override
  _ZoomIconButtonState createState() => _ZoomIconButtonState();
}

class _ZoomIconButtonState extends State<ZoomIconButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          isPressed = false;
        });
        widget.onPressed();
      },
      onTapCancel: () {
        setState(() {
          isPressed = false;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        padding: EdgeInsets.all(isPressed ? 10 : 0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isPressed ? Colors.indigo : Colors.white,
        ),
        child: Icon(
          widget.icon,
          color: Color(0xFF183765),
          size: isPressed ? 100 : 40,
        ),
      ),
    );
  }
}

class ProfilePageScreen extends StatefulWidget {
  final String userID;

  ProfilePageScreen({required this.userID});

  @override
  _ProfilePageScreenState createState() => _ProfilePageScreenState();
}

class _ProfilePageScreenState extends State<ProfilePageScreen> {
  Map<String, dynamic>? userData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('Customers')
                .doc(widget.userID)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              if (snapshot.hasData && snapshot.data!.exists) {
                userData = snapshot.data!.data() as Map<String, dynamic>? ?? {};
              } else {
                userData = {};
                return Center(
                  child: Text('User data not found'),
                );
              }

              return Column(
                children: [
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    child: Container(
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                        color: Color(0xFF183765),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(300),
                          bottomRight: Radius.circular(300),
                        ),
                        // Adjust the blur intensity as needed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 40),
                            Text(
                              'CHASHMART',
                              style: TextStyle(
                                fontSize: 35,
                                color: Colors.white,
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                            const SizedBox(height: 70),
                            Text(
                              '${userData!['name']}',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white),
                            ),
                            Text(
                              '-${userData!['email']}',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.person,
                      color: Color(0xFF183765),
                    ),
                    title: Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF183765),
                      ),
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditProfilePage()),
                      );
                      // Refresh user data after returning from EditProfilePage
                      setState(() {});
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.help,
                      color: Color(0xFF183765),
                    ),
                    title: Text(
                      'Help',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF183765),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HelpPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.home,
                      color: Color(0xFF183765),
                    ),
                    title: Text(
                      'Home',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF183765),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Dashboard(userID: widget.userID)),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.info,
                      color: Color(0xFF183765),
                    ),
                    title: Text(
                      'About Us',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF183765),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AboutUsPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.favorite,
                      color: Color(0xFF183765),
                    ),
                    title: Text(
                      'My Favorites',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF183765),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FavoritePage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.shopping_cart,
                      color: Color(0xFF183765),
                    ),
                    title: Text(
                      'Cart',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF183765),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CartPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.share,
                      color: Color(0xFF183765),
                    ),
                    title: Text(
                      'Share with your friends',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF183765),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyHomePage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.rate_review,
                      color: Color(0xFF183765),
                    ),
                    title: Text(
                      'Rate this App',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF183765),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReviewPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ZoomIconButton(
                  icon: Icons.home,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Dashboard(userID: widget.userID),
                      ),
                    );
                  },
                ),
                ZoomIconButton(
                  icon: Icons.person,
                  onPressed: () {
                    // Handle profile button press
                  },
                ),
                ZoomIconButton(
                  icon: Icons.share,
                  onPressed: () {
                    // Handle share button press
                  },
                ),
                ZoomIconButton(
                  icon: Icons.logout,
                  onPressed: () {
                    // Handle logout button press
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
