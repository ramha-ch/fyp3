import 'package:flutter/material.dart';

class FAQPage extends StatefulWidget {
  static _FAQPageState of(BuildContext context) =>
      context.findAncestorStateOfType<_FAQPageState>()!;

  @override
  _FAQPageState createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  List<FAQItem> faqList = [
    FAQItem(
      question: 'What is Chashmart Glasses?',
      answer: 'Chashmart Glasses is a mobile application that allows you to explore and purchase a wide range of eyeglasses conveniently from your device.',
    ),
    FAQItem(
      question: 'How can I purchase glasses through the app?',
      answer: 'To purchase glasses, simply browse the catalog, choose your favorite pair, and follow the checkout process. You can securely pay through various payment options.',
    ),
    FAQItem(
      question: 'Is there a try-on feature for glasses?',
      answer: 'Yes, the app offers a 3D try-on feature, allowing you to virtually try on glasses before making a purchase. It helps you visualize how the glasses will look on your face.',
    ),
    FAQItem(
      question: 'Can I use the app for an eye test?',
      answer: 'Yes, the app includes a basic eye test feature. This allows you to check your vision within the app, providing a convenient way to assess your eyesight.',
    ),
    FAQItem(
      question: 'How does the AI recommendation system work?',
      answer: 'The AI recommendation system analyzes your preferences, previous purchases, and virtual try-on results to suggest eyeglasses that match your style and facial features.',
    ),
    FAQItem(
      question: 'Are the virtual try-on results accurate?',
      answer: 'While the virtual try-on provides a realistic representation, variations may occur based on factors such as device screen calibration. It\'s designed to give you a close idea of how the glasses will look on you.',
    ),
    FAQItem(
      question: 'What payment methods are accepted?',
      answer: 'We accept various payment methods, including credit/debit cards, mobile wallets, and other secure payment options. You can choose the one that suits you best during the checkout process.',
    ),
    FAQItem(
      question: 'Is my personal information secure?',
      answer: 'Yes, we prioritize the security of your personal information. Our app employs encryption and follows industry best practices to protect your data.',
    ),
    FAQItem(
      question: 'Can I track my order?',
      answer: 'Yes, you can track your order through the app. Once your order is shipped, you\'ll receive a tracking number and updates on the delivery status.',
    ),
    FAQItem(
      question: 'What is your return policy?',
      answer: 'Our return policy allows you to return glasses within a specified period if you\'re not satisfied. Please check our Returns and Exchanges section for more details.',
    ),
    // Add more questions as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF183765),
        title: Text('FAQS', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: faqList.length,
          itemBuilder: (context, index) {
            return FAQItemWidget(
              faqItem: faqList[index],
            );
          },
        ),
      ),
    );
  }
}

class AskQuestionPage extends StatelessWidget {
  final TextEditingController questionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ask a Question'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: questionController,
              decoration: InputDecoration(labelText: 'Your Question'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String newQuestion = questionController.text.trim();
                if (newQuestion.isNotEmpty) {
                  // Check if the question already exists in the FAQ list
                  if (!FAQPage.of(context).faqList.any((faq) => faq.question == newQuestion)) {
                    // Add the new question to the FAQ list
                    FAQPage.of(context).faqList.add(FAQItem(
                      question: newQuestion,
                      answer: 'Answer to the new question goes here.',
                    ));
                  }
                  // You can add additional logic here, such as storing the question in a database.
                  // For simplicity, we are not implementing database logic in this example.
                }
                Navigator.pop(context);
              },
              child: Text('Submit Question'),
            ),
          ],
        ),
      ),
    );
  }
}

class FAQItemWidget extends StatefulWidget {
  final FAQItem faqItem;

  FAQItemWidget({required this.faqItem});

  @override
  _FAQItemWidgetState createState() => _FAQItemWidgetState();
}

class _FAQItemWidgetState extends State<FAQItemWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      onExpansionChanged: (bool expanded) {
        setState(() {
          isExpanded = expanded;
        });
      },
      title: Text(
        widget.faqItem.question,
        style: TextStyle(
          color: isExpanded ? Colors.red : Color(0xFF183765),
          fontWeight: FontWeight.bold, // Add this line for bold text
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(widget.faqItem.answer),
        ),
      ],
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}