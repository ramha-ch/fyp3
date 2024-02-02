import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projectchashmart/Glasses/BG1Page.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF183765),
        title: Text('Shopping Cart', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: currentUser != null
          ? _buildCartList()
          : Center(
        child: Text('Please log in to view cart items.'),
      ),
    );
  }

  Widget _buildCartList() {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Customers')
                .doc(currentUser!.uid)
                .collection('Cart')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No items in the cart.'));
              } else {
                List<DocumentSnapshot> cartItems = snapshot.data!.docs;

                return Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        itemCount: cartItems.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 3,
                        ),
                        itemBuilder: (context, index) {
                          Map<String, dynamic> data =
                          cartItems[index].data() as Map<String, dynamic>;

                          return _buildCartItem(data, context);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Implement your "Buy Now" logic here
                              // For example, you can navigate to the checkout page.
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => Buynow(),
                              //   ),
                              // );
                            },
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(120, 50),
                              backgroundColor: Color(0xFF183765),
                              shape: const RoundedRectangleBorder(),
                            ),
                            child: Text(
                              'Buy Now',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _deleteAllItems();
                            },
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(120, 50),
                              backgroundColor: Colors.red,
                              shape: const RoundedRectangleBorder(),
                            ),
                            child: Text(
                              'add',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _deleteAllItems();
                            },
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(120, 50),
                              backgroundColor: Colors.red,
                              shape: const RoundedRectangleBorder(),
                            ),
                            child: Text(
                              'Delete All',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCartItem(Map<String, dynamic> data, BuildContext context) {
    String glassImage = data['glassId'];
    String selectedColor = data['selectedColor'];
    int quantity = data['quantity'];

    return Dismissible(
      key: Key(glassImage),
      onDismissed: (direction) {
        // Remove the item from Firestore when dismissed
        FirebaseFirestore.instance
            .collection('Customers')
            .doc(currentUser!.uid)
            .collection('Cart')
            .doc(glassImage)
            .delete();
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.only(right: 16),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BGDetailsPage(glassImage: glassImage),
            ),
          );
        },
        child: ListTile(
          title: Text('Color: $selectedColor | Quantity: $quantity'),
          leading: Image.asset(
            glassImage,
            width: 150,
            height: 150,
          ),
        ),
      ),
    );
  }

  void _deleteAllItems() async {
    // Get a reference to the Cart collection
    CollectionReference cartCollection = FirebaseFirestore.instance
        .collection('Customers')
        .doc(currentUser!.uid)
        .collection('Cart');

    // Get all documents in the Cart collection
    QuerySnapshot cartSnapshot = await cartCollection.get();

    // Delete each document in the Cart collection
    for (QueryDocumentSnapshot doc in cartSnapshot.docs) {
      await doc.reference.delete();
    }
  }
}
