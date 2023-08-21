import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:queue_project/screens/UserTypeScreen.dart';
import 'package:queue_project/screens/notifications.dart';
import 'package:queue_project/screens/user_state.dart';

String serviceloginId = " ";
String comapnyname = " ";

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
  
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  String total = "0";
  List<Map<String, dynamic>> tickets = [];
  List<Map<String, dynamic>> notifications = [];

  

 Future<void> logout() async {
    final url1 = 'http://192.168.18.154:3000/logout'; // Replace with your API endpoint
    final headers1 = {'Content-Type': 'application/json'};
    final body1 = json.encode({'serviceid': serviceloginId, 'type': 'company'});

    try {
      final response1 = await http.post(Uri.parse(url1), headers: headers1, body: body1);
      // print('Response status code: ${response.statusCode}');
      if (response1.statusCode == 200) {
        print("HAUHDAS");
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

  // Future<void> fetchnoti() async {
  //   final url1 = 'http://192.168.18.154:3000/getnotifications'; // Replace with your API endpoint
  //   final headers1 = {'Content-Type': 'application/json'};
  //   final body1 = json.encode({'serviceid': serviceloginId});

  //   try {
  //     final response1 = await http.post(Uri.parse(url1), headers: headers1, body: body1);
  //     // print('Response status code: ${response.statusCode}');
  //     if (response1.statusCode == 200) {
  //       final jsonData1 = json.decode(response1.body);

  //       if (jsonData1.toString() != "0") {
  //         if (jsonData1 is Map) {
  //           // Handle JSON object (Map) response here
  //           // comapnyname = jsonData['businessName'].toString();
  //           // print("name: " + comapnyname);
  //           // print("A" + jsonData.toString());
  //           // print(jsonData1.toString());
  //           setState(() {
  //             // comapnyname = jsonData['businessName'].toString();

  //             notifications = List<Map<String, dynamic>>.from(jsonData1['notifications']);
  //           });
  //           // print(tickets[0]);
  //           // print(total);

  //           if (notifications.isNotEmpty) {
  //             final Map<String, dynamic> noti = notifications[0];

  //             //SHOW NOTIFICATIONS HERE

  //             //           NotificationHelper.showNotification(
  //             //   title: 'Dummy Notification',
  //             //   body: 'This is a dummy push notification.',
  //             // );

  //             for (int i = 0; i < notifications.length; i++) {
  //               print("nofti: " + notifications[i]['body'].toString());
  //             }
  //           } else {
  //             print('No Notifications found');
  //           }
  //         } else {
  //           throw FormatException("Invalid JSON format - Expected Map, got ${jsonData1.runtimeType}");
  //         }
  //       }
  //     } else {
  //       // POST request failed with an error status code, handle the error
  //       print('ErrorNOTI: ${response1.statusCode}');
  //       throw Exception('ErrorNOTI: ${response1.statusCode}');
  //     }
  //   } catch (error) {
  //     // An error occurred while sending the POST request, handle the error
  //     print('Error: $error');
  //     throw Exception('Error: $error');
  //   }
  // }

  Future<void> fetchData() async {
    final url = 'http://192.168.18.154:3000/companyalltickets'; // Replace with your API endpoint
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({'serviceid': serviceloginId});

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);
      // print('Response status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData.toString() != "0") {
          if (jsonData is Map) {
            // Handle JSON object (Map) response here
            comapnyname = jsonData['businessName'].toString();
            // print("name: " + comapnyname);
            // print("A" + jsonData.toString());
            setState(() {
              // comapnyname = jsonData['businessName'].toString();
              total = jsonData['total'].toString();
              tickets = List<Map<String, dynamic>>.from(jsonData['tickets']);
            });
            // print(tickets[0]);
            // print(total);

            if (tickets.isNotEmpty) {
              final Map<String, dynamic> firstTicket = tickets[0];
              final String companyName = firstTicket['businessName'].toString();
              // print("Company Name: $companyName");
              comapnyname = companyName;
              // print("name: " + comapnyname);
            } else {
              print('No tickets found');
            }
          } else {
            throw FormatException("Invalid JSON format - Expected Map, got ${jsonData.runtimeType}");
          }
        }
      } else {
        // POST request failed with an error status code, handle the error
        print('Error: ${response.statusCode}');
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (error) {
      // An error occurred while sending the POST request, handle the error
      print('Error: $error');
      throw Exception('Error: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    // fetchnoti();
    WidgetsBinding.instance!.addObserver(this);
  }

    @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('AppLifecycleState changed to: $state');
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached || state == AppLifecycleState.inactive) {
      // This callback is triggered when the app is going into the background or being terminated.
      // You can trigger your function here.
      print('App is going into the background or being terminated.');
      // Call your function here.
      logout();
    }
  }


  Future<void> refreshData() async {
    setState(() {
      total = "0";
      tickets.clear();
    });
    await fetchData();
    // await fetchnoti();
  }

  void _logout(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserTypeScreen()),
    );
  }
   void _gotoNotifications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotificationsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserState userState = Provider.of<UserState>(context);
   
    serviceloginId = userState.servideid.toString();
     print("Service username: " + serviceloginId);

    Color darkblue = Color(0xFF062E70);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkblue,
        automaticallyImplyLeading: false,
        title: Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        actions: [
           IconButton(
      icon: Icon(Icons.notifications),
      onPressed: (){_gotoNotifications(context);},
    ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              logout();
            },
          ),
        ],
        centerTitle: false,
        elevation: 2,
      ),
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Company Name Section
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Text(
                '$comapnyname',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Assuming you want to use black color
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Total Remaining Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF062E70),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(12),
                child: Text(
                  'Total Remaining: $total',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            // Tickets List
           Expanded(
              child: RefreshIndicator(
                onRefresh: refreshData,
                child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                    height: 0, // Adjust the height to control the spacing between list items
                    color: Colors.grey.shade300,
                  ),
                  itemCount: tickets.length,
                  itemBuilder: (context, index) {
                    final ticket = tickets[index];

                    final usern = ticket['username'];

                    final ticketId = ticket['ticketid'];
                    final fromTime = ticket['starttime'];
                    final to = ticket['endtime'];
                    final userid = ticket['userid'];

                    return Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      color: Color(0xFF105A90),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: AlignmentDirectional(0, 0),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                child: Text(
                                  usern,
                                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 25),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                              child: Text(
                                'Ticket Id: $ticketId',
                                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 7),
                              child: Text(
                                'From: 9 AM',
                                style: TextStyle(
                                  color: Color(0xFFF8F8F8),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 7),
                              child: Text(
                                'To: 5:30 PM',
                                style: TextStyle(
                                  color: Color(0xFFF8F8F8),
                                ),
                              ),
                            ),
                            // Add other ticket details as needed

                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  padding: EdgeInsets.all(2),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete_forever_rounded,
                                          size: 22,
                                          color: Color.fromARGB(255, 214, 48, 48),
                                        ),
                                        onPressed: () async {
                                          try {
                                            final url = 'http://192.168.18.154:3000/delticket';
                                            final headers = {'Content-Type': 'application/json'};
                                            final body = json.encode({'ticketid': ticketId});

                                            final response = await http.post(Uri.parse(url), headers: headers, body: body);

                                            if (response.statusCode == 200) {
                                              // POST request successful, do something with the response
                                              print('Response: ${response.body}');

                                              if ((response.body.toString()) == "1") {
                                                // The response indicates success, refresh data
                                                refreshData();
                                              }
                                            } else {
                                              // POST request failed with an error status code, handle the error
                                              print('Error: ${response.statusCode}');
                                            }
                                          } catch (error) {
                                            // An error occurred while sending the POST request, handle the error
                                            print('Error: $error');
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 252, 252, 252),
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  padding: EdgeInsets.all(2),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.check_circle,
                                          size: 22,
                                          color: Color.fromARGB(255, 30, 180, 0),
                                        ),
                                        onPressed: () async {
                                          try {
                                            final url = 'http://192.168.18.154:3000/markdone';
                                            final headers = {'Content-Type': 'application/json'};
                                            final body = json.encode({'ticketid': ticketId});

                                            final response = await http.post(Uri.parse(url), headers: headers, body: body);

                                            if (response.statusCode == 200) {
                                              // POST request successful, do something with the response
                                              print('Response: ${response.body}');

                                              if ((response.body.toString()) == "1") {
                                                // The response indicates success, refresh data
                                                refreshData();
                                              }
                                            } else {
                                              // POST request failed with an error status code, handle the error
                                              print('Error: ${response.statusCode}');
                                            }
                                          } catch (error) {
                                            // An error occurred while sending the POST request, handle the error
                                            print('Error: $error');
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
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