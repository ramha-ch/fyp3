import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SGDetailsPage extends StatefulWidget {
  final String glassImage;

  SGDetailsPage({required this.glassImage});

  @override
  _SGDetailsPageState createState() => _SGDetailsPageState();
}

class _SGDetailsPageState extends State<SGDetailsPage> {
  String selectedColor = 'Black'; // Default color
  int quantity = 1;
  bool isFavorite = false;

  void _addToCart() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('Customers')
            .doc(currentUser.uid)
            .collection('Cart')
            .add({
          'glassId': widget.glassImage,
          'selectedColor': selectedColor,
          'quantity': quantity,
        });
      } else {
        print('Error: currentUser is null');
      }
    } catch (error) {
      print('Error adding to cart: $error');
      // Add more specific error handling if needed
    }
  }

  void _toggleFavorite() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('Customers')
            .doc(currentUser.uid)
            .collection('favorite')
            .add({
          'glassId': widget.glassImage,
          'selectedColor': selectedColor,
          'quantity': quantity,
        });
      } else {
        print('Error: currentUser is null');
      }
    } catch (error) {
      print('Error toggling favorite: $error');
      // Add more specific error handling if needed
    }
  }

  Widget _buildColorCircle(String colorName, Color color) {
    bool isSelected = selectedColor == colorName;

    return InkWell(
      onTap: () {
        setState(() {
          selectedColor = colorName;
        });
      },
      child: Container(
        width: 20,
        height: 20,
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: isSelected ? Border.all(color: Colors.black, width: 4) : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF183765),
        title: Text('Glass Details', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Image.asset(
              widget.glassImage,
              fit: BoxFit.contain,
              height: 200,
              width: 800,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  Text(
                    'Select Color:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      _buildColorCircle('Black', Colors.black),
                      _buildColorCircle('White', Colors.white),
                      _buildColorCircle('Pink', Colors.pink),
                      _buildColorCircle('Green', Colors.green),
                      _buildColorCircle('Blue', Colors.blue),
                    ],
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Quantity:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (quantity > 1) {
                              quantity--;
                            }
                          });
                        },
                      ),
                      Text(quantity.toString()),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Description:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Elevate your style with our exquisite sunglasses collection. Experience fashion-forward eyewear with unmatched quality.',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                  ),
                  onPressed: _toggleFavorite,
                ),
                ElevatedButton(
                  onPressed: _addToCart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF183765),
                    shape: const RoundedRectangleBorder(),
                    fixedSize: Size(150, 50), // Set the width and height of the button
                  ),
                  child: Text(
                    'Add to Cart',
                    style: TextStyle(
                      fontSize: 16, // Adjust the font size as needed
                      color: Colors.white, // Set the text color to white
                    ),
                  ),
                ),

                ElevatedButton(
                  onPressed: _addToCart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF183765),
                    shape: const RoundedRectangleBorder(),
                    fixedSize: Size(150, 50), // Set the width and height of the button
                  ),
                  child: Text(
                    'Buy Now',
                    style: TextStyle(
                      fontSize: 16, // Adjust the font size as needed
                      color: Colors.white, // Set the text color to white
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
