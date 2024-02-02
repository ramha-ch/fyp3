import 'package:flutter/material.dart';

class Message {
  final String senderName;
  final String senderEmail;
  final String text;

  Message({
    required this.senderName,
    required this.senderEmail,
    required this.text,
  });
}

class User {
  final String name;
  final String email;

  User({required this.name, required this.email});
}

class ChatProvider extends ChangeNotifier {
  User? currentUser;
  List<Message> messages = [];

  void setUser(User user) {
    currentUser = user;
    notifyListeners();
  }

  void addMessage(Message message) {
    messages.add(message);
    notifyListeners();
  }
}
