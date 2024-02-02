import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late String _name;
  late String _email;
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? currentUser;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      currentUser = _auth.currentUser;

      if (currentUser != null) {
        String currentUserId = currentUser!.uid;
        DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('Customers').doc(currentUserId).get();

        print("Fetched user data: ${userSnapshot.data()}");
        setState(() {
          _name = userSnapshot.get('name') ?? '';
          _email = userSnapshot.get('email') ?? '';
        });

        print("Name: $_name, Email: $_email");
      } else {
        print('No current user found');
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Color(0xFF183765),
        title: Text('Update your Profile', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 30),
                Image.asset(
                  'assets/home/update.gif',
                  width: 300,
                  height: 300,
                ),
                SizedBox(height: 50),
                buildTextField('Name', _name, (value) {
                  setState(() {
                    _name = value;
                  });
                }),
                SizedBox(height: 16),
                // Email field is now read-only
                buildReadOnlyField('Email', _email),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {

                      await FirebaseFirestore.instance.collection('Customers').doc(currentUser?.uid).update({
                        'name': _name,
                        // Do not update 'email' field here
                      });

                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF183765),
                   foregroundColor: Colors.white, // Text color
                    padding: EdgeInsets.symmetric(vertical: 13, horizontal: 120),
                    shape: const RoundedRectangleBorder(),
                  ),
                  child: Text(
                    'Update Profile',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, String initialValue, ValueChanged<String> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.white,
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200.withOpacity(0.5),
              spreadRadius: 4,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: TextFormField(
          readOnly: labelText == 'Email', // Make email field read-only
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF183765),
          ),
          decoration: InputDecoration(
            labelText: labelText,
            border: InputBorder.none,
          ),
          onChanged: onChanged,
          initialValue: initialValue,
          validator: (value) {
            if (labelText == 'Email' && !isValidEmail(value ?? '')) {
              return 'Enter a valid email address';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget buildReadOnlyField(String labelText, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          border: Border.all(
            color: Colors.grey.shade200,
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200.withOpacity(0.5),
              spreadRadius: 4,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: TextFormField(
          readOnly: true,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF183765),
          ),
          decoration: InputDecoration(
            labelText: labelText,
            border: InputBorder.none,
          ),
          initialValue: value,
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$',
    ).hasMatch(email);
  }
}
