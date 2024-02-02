import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReviewPage extends StatefulWidget {
  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final _commentController = TextEditingController();
  double _userRating = 0;

  List<String> chasmartLetters = ['C', 'CH', 'CHA', 'CHAS', 'CHASH', 'CHASHM', 'CHASHMA', 'CHASMAR', 'CHASMART'];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startDisplay();
  }

  void _startDisplay() {
    Future.delayed(Duration(milliseconds: 300), () {
      if (currentIndex < chasmartLetters.length - 1) {
        setState(() {
          currentIndex++;
        });
        _startDisplay();
      }
    });
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }


  void _submitReview(String review, double rating) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('Customers')
            .doc(currentUser.uid)
            .collection('reviews')
            .add({
          'review': review,
          'rating': rating,
          'timestamp': FieldValue.serverTimestamp(),
        });

        _showDialog('Review Submitted', 'Thank you for submitting your review!');
      } else {
        _showDialog('Error', 'There was an error submitting your review. Please try again later. User is null.');
      }
    } catch (error) {
      print('Error submitting review: $error');
      _showDialog('Error', 'There was an error submitting your review. Please try again later.');
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF183765),
        title: Text('Review Page', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0),
              Text(
                chasmartLetters[currentIndex],
                style: TextStyle(
                  fontSize: screenWidth * 0.1,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF183765),
                ),
              ),

              Container(
                height: screenHeight * 0.2,
                width: screenWidth * 0.5,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/home/rate.PNG'),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'How would you Rate our App Experience?',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 1; i <= 5; i++)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _userRating = i.toDouble();
                          });
                        },
                        child: Icon(
                          Icons.star,
                          color: i <= _userRating ? Color(0xFF183765) : Colors.grey,
                          size: screenWidth * 0.1,
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Share your thoughts',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: TextFormField(
                  controller: _commentController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: 'Any Suggestions.....',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_userRating > 0) {
                    _submitReview(
                      _commentController.text,
                      _userRating,
                    );
                    Navigator.pop(context);
                  } else {
                    _showRatingErrorDialog();
                  }

                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF183765),
                  minimumSize: Size(screenWidth * 0.8, screenHeight * 0.06),
                  shape: const RoundedRectangleBorder(),
                ),
                child: Text(
                  'Submit Review',
                  style: TextStyle(fontSize: screenWidth * 0.04 , color: Colors.white),
                ),

              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRatingErrorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Rating Error'),
          content: Text('Please select a rating before submitting.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
