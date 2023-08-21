// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:queue_project/screens/Tickethistory.dart';
import 'package:queue_project/screens/UserTypeScreen.dart';
import 'package:queue_project/screens/user_state.dart';
import 'package:provider/provider.dart';
import 'package:queue_project/screens/globals.dart';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

String serviceid = "";
String appuserid = "";
String servicename = "";
String ticketnum = "";
String appuser_name = "";

class TicketCard {
  final String name;
  final String ticketNumber;
  final String ticketsAhead;
  final String waitingTime;
  final String ticketId; // Add this property
  final String phone;
  final int waitingTimeInMinutes;

  TicketCard({
    required this.name,
    required this.ticketNumber,
    required this.ticketsAhead,
    required this.waitingTime,
    required this.ticketId, // In
    required this.phone, // In
    required this.waitingTimeInMinutes,
  });
}

class CardScreen extends StatefulWidget {
  @override
  _CardScreenState createState() => _CardScreenState();

  final String data;

  CardScreen({
    required this.data,
  });
}

class _CardScreenState extends State<CardScreen> with WidgetsBindingObserver{

   final RestorableString _appuserid = RestorableString('');
   @override
  String get restorationId => 'card_screen';
  bool isLoading = true;



  // Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // late Future<String> _userid;

  // Future<void> restoreScreen() async {
  //   final SharedPreferences prefs = await _prefs;
  //   final String id = (prefs.getString('appuserid')??'');
  //    setState(() {
  //     _userid = prefs.setString("appuserid", appuserid).then((bool success)){
  //        return appuserid;
  //     };
  //   });
  // }

  List<TicketCard> cards = [];
  int counter = 0;
  // @override
  // void initState() {
  //   super.initState();
    
  //   // _userid = _prefs.then((SharedPreferences prefs){
  //   //   return (prefs.getString('appuserid')??'');
  //   // });
  // }

  @override
  void didChangeDependencies() {
    // Access the InheritedWidget value here instead of initState
    UserState userState = Provider.of<UserState>(this.context);
    print("username: " + userState.userName);

    // Call the fetchUserAllTickets function here with the user ID
    fetchUserAllTickets(globalVariable);

    super.didChangeDependencies();
  }

  Future<void> fetchUserAllTickets(String userId) async {
    String serviceId = '201';
    final url = Uri.parse('http://192.168.18.154:3000/useralltickets');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'userid': userId, 'serviceid': serviceId}),
    );

    if (response.statusCode == 200) {
      // If the request is successful, parse the response data
      final data = json.decode(response.body);
      print('Data received: $data');

      setState(() {
        cards = List<TicketCard>.from(data.map((item) {
          // Generate a random ticket ID for each entry
          Random random = Random();
          int randomNumber = 1000 + random.nextInt(9000);
          String ticketid = randomNumber.toString();
          print(ticketid);
          ticketnum = ticketid;
          int rem = item['result'];
          String remtick = rem.toString();
          serviceid = item['phone'];
          servicename = item['businessname'];
          print('remaining tickets: ' + remtick);
          int remainingTickets = int.parse(remtick);
          int waitingTimeInMinutes = (16 - remainingTickets) * 30;
          // Create TicketCard object with the random ticket ID and other data
          return TicketCard(
            name: item['businessname'],
            ticketNumber: ticketid,
            ticketsAhead: remtick,
            waitingTime: item['address'],
            ticketId: ticketid,
            phone: item['phone'],
            waitingTimeInMinutes: waitingTimeInMinutes,
          );
        }));

        // Save individual values from the response data in variables
        // Add more assignments for other values if needed
        isLoading = false;
      });
    } else {
      // If the request fails, handle the error
      print('Request failed with status: ${response.statusCode}');
    }
  }

  int counter1 = 0;
  Future<void> refreshData(BuildContext context) async {
    setState(() {
      counter1 = counter1 + 1;
    });
    await fetchUserAllTickets(globalVariable);
    // await fetchnoti();
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
    final body1 = json.encode({'serviceid': globalVariable, 'type': 'user'});

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
    globalVariable = widget.data;
  }
   @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }


 @override
Widget build(BuildContext context) {
  UserState userState = Provider.of<UserState>(context);
  print("Ticket username: " + userState.userName);
  appuserid = userState.userName;
  appuser_name = userState.name;

  print('name: ' + userState.name);
  print(globalVariable);

  Color darkblue = Color(0xFF062E70);
  return Scaffold(
    appBar: AppBar(
      title: Text('Tickets'),
      backgroundColor: darkblue,
    ),
    body: isLoading
        ? Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () async {
              await refreshData(context);
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      return TicketCardWidget(
                        card: cards[index],
                        onTicketBooked: () {
                          refreshData(context); // Call the refreshData function
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
  );
}

}

class TicketCardWidget extends StatelessWidget {
  final TicketCard card;

  final VoidCallback onTicketBooked; // Add this line

  TicketCardWidget({
    Key? key, // Add the named key parameter
    required this.card,
    required this.onTicketBooked, // Add this line
  }) : super(key: key);

  Color darkblue = Color(0xFF062E70);

  void _showBookedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ticket Booked'),
          content: Text('Ticket Booked Succesfully!'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
                onTicketBooked();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> bookTicket(BuildContext context, String ticketId1) async {
    DateTime currentDateTime = DateTime.now();
    print(currentDateTime);
    String dateTimeString = currentDateTime.toIso8601String();

    final ticket = {
      "ticketid": card.ticketNumber.toString(),
      "businessname": card.name.toString(),
      "businessType": globalVariable,
      "userid": appuserid,
      "serviceid": card.phone.toString(),
      "generationtime": dateTimeString,
      "status": "0",
      "username": appuser_name,
    };
    print(ticket);

    final url = Uri.parse('http://192.168.18.154:3000/bookticket');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode(ticket);

    try {
      final response = await http.post(url, headers: headers, body: body);
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        print("Ticket booked successfully");
        _showBookedDialog(context);

        // Handle success
      } else {
        print("Failed to book ticket: ${response.statusCode}");
        // Handle error
      }
    } catch (e) {
      print("Error occurred: $e");
      // Handle error
    }
  }

  // TicketCardWidget({required this.card});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: darkblue, width: 2), // Border color and width
      ),
      elevation: 4, // Add shadow
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              card.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: darkblue,
              ),
            ),
            SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Ticket ID ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  '${card.ticketNumber}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(234, 52, 255, 1),
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tickets Remaining',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(121, 106, 106, 106),
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${card.ticketsAhead}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Address',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(121, 106, 106, 106),
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${card.waitingTime}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.right, // Align to the right
                ),
              ],
            ),
            SizedBox(height: 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Waiting Time',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(121, 106, 106, 106),
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${card.waitingTimeInMinutes} mins', // Display waiting time here
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.right, // Align to the right
                ),
              ],
            ),
            SizedBox(height: 20), // Add spacing before the button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    bookTicket(context, card.ticketNumber.toString());
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // Button background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.bookmark_add_outlined,
                          color: Colors.white), // Cancel icon
                      SizedBox(width: 8),
                      Text(
                        'Book Ticket',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
