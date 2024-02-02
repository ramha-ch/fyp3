import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Share Plus"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Share eclectify University with your friends:'),
            SizedBox(height: 10),
            IconButton(
              onPressed: () => sharePressed(context),
              icon: Icon(Icons.share, color: Colors.redAccent),
            ),
            Image.asset(
              "assets/lunch_break.png",
              width: MediaQuery.of(context).size.width * 0.6,
            ),
          ],
        ),
      ),
    );
  }

  void sharePressed(BuildContext context) {
    String message =
        'Check out eclectify University, where you can become an Elite Flutter Developer in no time: https://eclectify-university.web.app';
    Share.share(message, subject: 'Become An Elite Flutter Developer');
  }
}