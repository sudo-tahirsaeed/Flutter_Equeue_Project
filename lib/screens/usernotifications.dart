import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:queue_project/screens/UserTypeScreen.dart';
import 'package:queue_project/screens/user_state.dart';

String serviceloginId = " ";
String comapnyname = " ";

class userNotificationScreen extends StatefulWidget  {
  @override
  _MyNotiState createState() => _MyNotiState();
}

class _MyNotiState extends State<userNotificationScreen> with WidgetsBindingObserver {
  List<Map<String, dynamic>> notifications = [];

  Future<void> fetchnoti() async {
    final url1 = 'http://192.168.18.154:3000/getnotifications'; // Replace with your API endpoint
    final headers1 = {'Content-Type': 'application/json'};
    final body1 = json.encode({'serviceid': serviceloginId});

    try {
      final response1 = await http.post(Uri.parse(url1), headers: headers1, body: body1);
      // print('Response status code: ${response.statusCode}');
      if (response1.statusCode == 200) {
        final jsonData1 = json.decode(response1.body);
        // print("data"+jsonData1.toString());

        if (jsonData1.toString() != "0") {
          if (jsonData1 is Map) {
            // Handle JSON object (Map) response here
            // comapnyname = jsonData['businessName'].toString();
            // print("name: " + comapnyname);
            // print("A" + jsonData.toString());
            // print(jsonData1.toString());
            setState(() {
              // comapnyname = jsonData['businessName'].toString();

              notifications = List<Map<String, dynamic>>.from(jsonData1['notifications']);
            });
            // print(tickets[0]);
            // print(total);

            if (notifications.isNotEmpty) {
              final Map<String, dynamic> noti = notifications[0];

              //SHOW NOTIFICATIONS HERE

              //           NotificationHelper.showNotification(
              //   title: 'Dummy Notification',
              //   body: 'This is a dummy push notification.',
              // );

              for (int i = 0; i < notifications.length; i++) {
                print("nofti: " + notifications[i]['body'].toString());
              }
            } else {
              print('No Notifications found');
            }
          } else {
            throw FormatException("Invalid JSON format - Expected Map, got ${jsonData1.runtimeType}");
          }
        }
      } else {
        // POST request failed with an error status code, handle the error
        print('ErrorNOTI: ${response1.statusCode}');
        throw Exception('ErrorNOTI: ${response1.statusCode}');
      }
    } catch (error) {
      // An error occurred while sending the POST request, handle the error
      print('Error: $error');
      throw Exception('Error: $error');
    }
  }
 @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    UserState userState = Provider.of<UserState>(context);
    serviceloginId = userState.userName.toString();
    print("Service username: " + serviceloginId);

    fetchnoti();
  }
  
 
   void _logout(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserTypeScreen()),
    );
  }
   Future<void> logout() async {
    final url1 = 'http://192.168.18.154:3000/logout'; // Replace with your API endpoint
    final headers1 = {'Content-Type': 'application/json'};
    final body1 = json.encode({'serviceid': serviceloginId, 'type': 'user'});

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
    fetchnoti();
  }
   @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

 


  Future<void> refreshData() async {
    setState(() {});

    await fetchnoti();
  }

  @override
  Widget build(BuildContext context) {
    // UserState userState = Provider.of<UserState>(context);
    // //
    // serviceloginId = userState.userName.toString();
    //  print("Service username: $serviceloginId" );

    Color darkblue = Color(0xFF062E70);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkblue,
        automaticallyImplyLeading: true,
        title: Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.logout),
          //   onPressed: () {},
          // ),
        ],
        centerTitle: false,
        elevation: 2,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        // reverse: true,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Color.fromARGB(255, 201, 19, 19),
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            title: Text(this.notifications[index]['body'].toString()),
          );
        },
      ),
    );
  }
}