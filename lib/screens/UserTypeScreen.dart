import 'package:flutter/material.dart';
import 'package:queue_project/screens/ServiceProviderSignInScreen.dart';
import 'package:queue_project/screens/SignInScreen.dart';

class UserTypeScreen extends StatelessWidget {
  void _goToSignInScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
    );
  }

  void _goToServiceProviderSignInScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ServiceProviderSignInScreen()),
    );
  }

  Color darkblue = Color(0xFF062E70);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null, // Setting the app bar to null will remove the header
      backgroundColor: Color.fromRGBO(177, 223, 243, 1),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: 50.0, left: 20.0), // Add top margin for the text
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'WELCOME',
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: darkblue,
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 20.0), // Add top margin for the text
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'To E-QUEUE Application',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: darkblue,
                  ),
                ),
              ),
            ),
            Expanded(
               child: Center(
                child: Image.asset( 'assets/queue1.png', // Replace with the path to your image asset
                  height: 200,
                  width: 200,
                ),
              ),
            ),
            // Padding(
            // padding: EdgeInsets.only(bottom: 20.0), // Add bottom margin for the buttons
            Container(
              height: 45,
              width: 280,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(16, 90, 174, 1),
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing:1.5, // Adjust the value to set letter spacing
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28.0),
                  ),
                  padding: EdgeInsets.all(10),
                ),
                child: const Text('User'),
                onPressed: () {
                  _goToSignInScreen(context);
                },
              ),
            ),

            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(
                  bottom: 120.0), // Add bottom margin for the buttons
              child: Container(
                height: 45,
                width: 280,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color.fromRGBO(16, 90, 174, 1),
                    textStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing:1.0, ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28.0),
                    ),
                    padding: EdgeInsets.all(10),
                  ),
                  child: const Text('Service Provider'),
                  onPressed: () {
                    _goToServiceProviderSignInScreen(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
