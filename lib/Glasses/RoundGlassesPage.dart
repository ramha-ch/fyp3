import 'package:flutter/material.dart';
import 'package:projectchashmart/Glasses/RG1Page.dart';

class RoundglassesScreen extends StatefulWidget {
  const RoundglassesScreen({super.key});
  @override
  State<RoundglassesScreen> createState() => _RoundglassesScreenState();
}
class _RoundglassesScreenState extends State<RoundglassesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF183765),
        title: Text('Roundglasses', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns
        ),
        itemCount: 6, // Number of items
        itemBuilder: (BuildContext context, int index) {
          // You can customize each container with different glasses and buttons here
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                Image.asset(
                  'assets/Glasses/roundglasses/RG${index+1}.PNG',
                  width: 100,
                  height: 100,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>RGDetailsPage( glassImage: 'assets/Glasses/roundglasses/RG${index+1}.PNG',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF183765),
                        minimumSize: Size(120, 40), // Adjust width and height as needed
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero, // No circular radius
                        ),
                      ),
                      child: Text(
                        'SEE DETAILS',
                        style: TextStyle(
                          color: Colors.white, // Set text color to white
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}