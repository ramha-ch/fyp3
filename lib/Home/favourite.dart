import 'package:flutter/material.dart';
import 'package:projectchashmart/Glasses/BG1Page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Color(0xFF183765),
        title: Text('Favorite Products', style: TextStyle(color: Colors.white)),
    leading: IconButton(
    icon: Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    ),
      body: currentUser != null
          ? _buildFavoriteList()
          : Center(
        child: Text('Please log in to view favorites.'),
      ),
    );
  }

  Widget _buildFavoriteList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Customers')
          .doc(currentUser!.uid)
          .collection('favorite')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No favorite items.'));
        } else {
          List<DocumentSnapshot> favorites = snapshot.data!.docs;

          return ListView.separated(
            itemCount: favorites.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, currentIndex) {
              Map<String, dynamic> data =
              favorites[currentIndex].data() as Map<String, dynamic>;
              return _buildFavoriteItem(data, context, currentIndex);
            },
          );
        }
      },
    );
  }

  Widget _buildFavoriteItem(
      Map<String, dynamic> data, BuildContext context, int index) {
    // Extract details from the data map
    String glassImage = data['glassId'];

    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.white, // Shadow color
            blurRadius: 5, // Spread radius
            offset: Offset(0, 3), // Offset in x and y
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Placeholder for the glass image
          ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: Image.asset(
              glassImage,
              width: 200,
              height: 120,

            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BGDetailsPage(glassImage: glassImage),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                 backgroundColor: Color(0xFF183765),
                  minimumSize: Size(120, 40),
                ),
                child: Text('SEE DETAILS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
