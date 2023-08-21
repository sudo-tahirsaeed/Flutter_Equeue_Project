import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_project/screens/TicketCard.dart';
import 'package:queue_project/screens/UserTypeScreen.dart';
import 'package:queue_project/screens/notifications.dart';
import 'package:queue_project/screens/user_state.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as Path;
import 'dart:convert';

import 'package:queue_project/screens/usernotifications.dart';
String loginId='';
class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> with WidgetsBindingObserver {
  // Rest of your existing code

  void _logout(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserTypeScreen()),
    );
  }

   void _gotoNotifications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => userNotificationScreen()),
    );
  }
   Future<void> logout() async {
    final url1 = 'http://192.168.18.154:3000/logout'; // Replace with your API endpoint
    final headers1 = {'Content-Type': 'application/json'};
    final body1 = json.encode({'serviceid': loginId, 'type': 'user'});

    try {
      final response1 = await http.post(Uri.parse(url1), headers: headers1, body: body1);
      // print('Response status code: ${response.statusCode}');
      if (response1.statusCode == 200) {
        print("user logout");
        final result = response1.body; // The result will be either "1" or "0"
        _logout(context);
        if (result == "1") {}
      } else {
        // POST request failed with an error status code, handle the error
        print('ErrorLogout: ${response1.statusCode}');
        throw Exception('ErrorLogout: ${response1.statusCode}');
      }
    } catch (error) {
      // An error occurred while sending the POST request, handle the error
      print('Error: $error');
      throw Exception('Error: $error');
    }
  }

  
@override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('AppLifecycleState changed to: $state');
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive || state == AppLifecycleState.detached) {
      // App is going into the background or being terminated
      // Add your code here to perform any cleanup or save data if necessary.
       print('going to recent apps');
      logout();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  
  
  @override
  Widget build(BuildContext context) {
     UserState userState = Provider.of<UserState>(context);

    loginId = userState.userName;
        print("username: " + loginId); 

     Color darkblue = Color(0xFF062E70);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: darkblue,
         automaticallyImplyLeading: false,
         actions: [
  
   IconButton(
      icon: Icon(Icons.notifications),
      onPressed: (){_gotoNotifications(context);},
    ),
      IconButton(
      icon: Icon(Icons.logout),
      onPressed: (){logout();},
    ),
  ],
),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10), // Add vertical padding
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CategoryCard(
                  title: 'Hospital',
                  icon: Icons.local_hospital,
                  color: Colors.red,
                ),
                SizedBox(height: 20),
                CategoryCard(
                  title: 'Banks',
                  icon: Icons.account_balance,
                  color: Colors.green,
                ),
                SizedBox(height: 20),
                CategoryCard(
                  title: 'Ministries',
                  icon: Icons.home_work,
                  color: Colors.orange,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const CategoryCard({
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth * 0.9;

    final String bank = "Bank";
    final String hospital = "Hospital";
    final String ministry = "Ministry";
 UserState userState = Provider.of<UserState>(context);
    // Use switch case to navigate to different screens based on the category title
    void _onCardTapped() {
      switch (title) {
        case 'Hospital':
        Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CardScreen(
            data:hospital,
      
          ),
        ),
      );
          break;
        case 'Banks':
         Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CardScreen(
            data:bank,
           
          ),
        ),
      );
          break;
        case 'Ministries':
         Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CardScreen(
            data:ministry,
            
          ),
        ),
      );
          break;
        default:
          break;
      }
    }

    return GestureDetector(
      onTap: _onCardTapped, // Call the _onCardTapped function when the card is tapped
      child: Container(
        width: containerWidth,
        height: 200,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Colors.white,
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
