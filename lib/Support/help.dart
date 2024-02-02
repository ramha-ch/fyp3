import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kommunicate_flutter/kommunicate_flutter.dart';
import 'FQS.dart';

class HelpPageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HelpPage(),
    );
  }
}

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF183765),
        title: const Text('Support Center', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 450.0,
              height: 250.0,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image:  AssetImage('assets/home/help.webp'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            // Header Section
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child:  const Column(
                children: [
                   Text(
                    'Welcome to the Support Center!',
                    style: TextStyle(
                      color: Color(0xFF183765),
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
               SizedBox(height: 8.0),
                 Text(
                    'How can we assist you today?',
                    style: TextStyle(
                      color: Color(0xFF183765),
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50.0),

            // Rounded Buttons
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF183765),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: () {
                // Navigate to FAQ page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FAQPage()),
                );
              },
              child: Padding(
                padding:  EdgeInsets.all(12.0),
                child: const Text(
                  'FAQs - Frequently Asked Questions',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF183765),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: () async {
                try {
                  const dynamic conversationObject = {
                    'appId': '37d9b712d94c4fb34978fa786695ec6a5',
                  };
                  final dynamic result = await KommunicateFlutterPlugin.buildConversation(conversationObject);
                  print("Conversation builder success : " + result.toString());
                } catch (e) {
                  print("Conversation builder error occurred : " + e.toString());
                }

                 User? currentUser = FirebaseAuth.instance.currentUser;

                if (currentUser != null) {
                  String currentUserId = currentUser.uid;

                  DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
                      .collection('Customers')
                      .doc(currentUserId)
                      .get();

                 String currentUserName = userSnapshot.get('name') ?? 'Default Name';

                  Message message = Message(
                    senderId: currentUserId,
                    senderName: currentUserName,
                    text: 'Hello, I have a question!',
                    timestamp: DateTime.now(),
                  );

                  // Use currentUserId as the collection name
                  await FirebaseFirestore.instance.collection('Chat').add(message.toMap());
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HelpPage()),
                  );
                } else {
                  // Handle the case where the user is not authenticated
                  print('User is not authenticated');
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: const Text(
                  'Ask a Question',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Message {
  final String senderId;
  final String senderName;
  final String text;
  final DateTime timestamp;

  Message({
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'text': text,
      'timestamp': timestamp,
    };
  }
}
