import 'package:flutter/material.dart';
import 'package:projectchashmart/Glasses/RoundGlassesPage.dart';
import 'package:projectchashmart/Glasses/SunGlassesPage.dart';

import '../Glasses/ButterflyGlassesPage.dart';

import 'ProfilePage.dart';
class Dashboard extends StatelessWidget {
  final String userID;
  Dashboard({required this.userID});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GlassesPage(userID: userID),
    );
  }
}

class ZoomIconButton extends StatefulWidget {
  final IconData icon;
  final Function onPressed;

  ZoomIconButton({required this.icon, required this.onPressed});

  @override
  _ZoomIconButtonState createState() => _ZoomIconButtonState();
}

class _ZoomIconButtonState extends State<ZoomIconButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          isPressed = false;
        });
        widget.onPressed();
      },
      onTapCancel: () {
        setState(() {
          isPressed = false;
        });
      },
      child: AnimatedContainer(
          duration: Duration(milliseconds: 100),
          padding: EdgeInsets.all(isPressed ? 10 : 0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isPressed ? Colors.indigo:Colors.white,
          ),
          child: Icon(
            widget.icon,
            color:Color(0xFF183765),
            size: isPressed ? 80 : 30,
          )
      ),
    );
  }
}

class GlassesPage extends StatefulWidget {
  final String userID; // Add a member variable to store the userID
  GlassesPage({required this.userID});
  @override
  _GlassesPageState createState() => _GlassesPageState();
}

class _GlassesPageState extends State<GlassesPage> {
  int currentIndex = 0;

  List<String> images = [
    "assets/home/mainvedio.gif",
    "assets/home/pic2.jpg",
    "assets/home/pic1.PNG",
  ];

  List<String> glassTypes = [
    "Sun Glasses",
    "3D Try-On",
    "Round Glasses",
    "Eye Test",
    "Butterfly Glasses",
    "SpectraScan AI",
  ];

  List<String> glassImages = [
    "assets/Glasses/sunglasses/sunglasses1.PNG",
    "assets/Glasses/3D/3D.gif",
    "assets/Glasses/roundglasses/roundglasses.PNG",
    "assets/Glasses/eyetest.PNG",
    "assets/Glasses/Butterfly/butterflyglasses.PNG",
    "assets/Glasses/ai.PNG",
  ];

  @override
  Widget build(BuildContext context) {return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.white,
      leading: Row(
        children: [
          IconButton(
            icon: Icon(Icons.menu, size: 40, color: Color(0xFF183765)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePageScreen(userID: widget.userID),
                ),
              );
            },
          ),
        ],
      ),
    ),
      body: Column(
        children: [

          // Top Images Carousel
          Container(
            height: 320,
            child: PageView.builder(
              itemCount: images.length,
              controller: PageController(
                initialPage: currentIndex,
              ),
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(
                    images[index],
                    fit: BoxFit.fitWidth,
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < images.length; i++)
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Icon(
                    Icons.brightness_1,
                    size: 12,
                    color: i == currentIndex ? Color(0xFF183765) : Colors.grey,
                  ),
                ),
            ],
          ),

          // Glasses Containers
          Expanded(

            child: GridView.count(
              crossAxisCount: 2,
              children: List.generate(
                glassTypes.length,
                    (index) {
                  return GestureDetector(
                    onTap: () {
                       if (glassTypes[index] == "Sun Glasses") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SunglassesScreen(),
                          ),
                        );
                      }
                      else if (glassTypes[index] == "Butterfly Glasses") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ButterFlyGlassesScreen(),
                          ),
                        );
                      }
                       else if (glassTypes[index] == "Round Glasses") {
                         Navigator.push(
                           context,
                           MaterialPageRoute(
                             builder: (context) => RoundglassesScreen(),
                           ),
                         );
                       }
                    },
                    child: Container(

                      margin: EdgeInsets.all(7),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                     color: Colors.grey.shade100,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1), // Shadow color
                            blurRadius: 5, // Spread radius
                            offset: Offset(0, 3), // Offset in x and y
                          ),
                        ],
                      ),
                      child: Column(

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Image.asset(

                              glassImages[index],
                              width: 180,
                            ),
                          ),
                          Text(
                            glassTypes[index],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w200,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(

            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ZoomIconButton(
                  icon: Icons.home,
                  onPressed: () {
                    // Handle home button press
                  },
                ),

                ZoomIconButton(

                  icon: Icons.person,

                    onPressed: () {
                      Navigator.push(
                       context,
                       MaterialPageRoute(builder: (context) => ProfilePageScreen(userID: widget.userID)),
                       );

                  },
                ),
                ZoomIconButton(
                  icon: Icons.share,
                  onPressed: () {

                  },
                ),
                ZoomIconButton(
                  icon: Icons.logout,
                  onPressed: () {
                    // Handle about us button press
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
