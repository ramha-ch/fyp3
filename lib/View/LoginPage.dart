import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:projectchashmart/Home/DashBoardPage.dart';
import 'package:projectchashmart/Home/ProfilePage.dart';
import 'package:projectchashmart/View/SignUpPage.dart';
final FirebaseAuth auth = FirebaseAuth.instance;
class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  Future<void> _loginWithEmailAndPassword(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        if (userCredential.user != null) {
          var userID = userCredential.user!.uid;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard(userID: userID),
            ),
          );
        }
      } catch (e) {
        print('Login Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login failed. Please check your email and password.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Align(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 90),
              Container(
                height: 200,
                width: 200,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/namelogo.PNG'),
                  ),
                ),
              ),

              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Login to your Account',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Form(
                      key:  _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Container(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                // Set the background color of the box
                                border: Border.all(
                                  color: Colors.white,
                                  width:
                                  2.0, // Set the border width to make it bold
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                    Colors.grey.shade200.withOpacity(0.5),
                                    // Shadow color
                                    spreadRadius: 4,
                                    // Spread radius
                                    blurRadius: 7,
                                    // Blur radius
                                    offset: Offset(0, 3),
                                    // Offset from the top-left of the box
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                controller: emailController,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF183765),
                                ),
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  hintText: 'xyz@gmail.com',
                                  border: InputBorder.none,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Container(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                // Set the background color of the box
                                border: Border.all(
                                  color: Colors.white,
                                  width:
                                  2.0, // Set the border width to make it bold
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                    Colors.grey.shade200.withOpacity(0.5),
                                    // Shadow color
                                    spreadRadius: 4,
                                    // Spread radius
                                    blurRadius: 7,
                                    // Blur radius
                                    offset: Offset(0, 3),
                                    // Offset from the top-left of the box
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                controller: passwordController,
                                obscureText: true,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF183765),
                                ),
                                decoration: const InputDecoration(
                                  labelText: 'Password',
                                  hintText: '*********',
                                  border: InputBorder.none,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: () async {
                              await _loginWithEmailAndPassword(context);
                            },

                            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(),
                              backgroundColor: Color(0xFF183765),
                              minimumSize: Size(350, 55),
                            ),
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),

                          ),
                          SizedBox(height: 40),
                          Text("- Or sign in with -"),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  GoogleSignUpHelper googleSignUpHelper = GoogleSignUpHelper();
                                  UserCredential? userCredential = await googleSignUpHelper.signUpWithGoogle();

                                  if (userCredential != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProfilePageScreen(userID: userCredential.user!.uid),
                                      ),
                                    );
                                  } else {
                                    // Handle sign-up failure here.
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                 backgroundColor: Colors.white, // Set your desired background color here
                                  fixedSize: Size(250, 30), // Set your desired size here
                                  shadowColor: null, // Remove the shadow
                                  elevation: 0, // Remove the shadow
                                ),
                                child: Image.asset(
                                  'assets/View/google1.png',
                                  fit: BoxFit.contain, // Choose the fit mode according to your requirements
                                ),
                              ),
                            ],
                          ),

                          MaterialButton(onPressed: () {}),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't  have an account"),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignUpScreen()),
                                    );
                                  },
                                  child: Text("Sign Up"))
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
}

class GoogleSignUpHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<UserCredential?> signUpWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuth = await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuth.accessToken,
          idToken: googleSignInAuth.idToken,
        );
        return await _auth.signInWithCredential(credential);
      }
    } catch (error) {
      print("Google Sign-Up Error: $error");
    }
    return null;
  }
}