import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:queue_project/screens/UserTypeScreen.dart';

String ticketid='';

enum TicketStatus {
  waiting,
  attended,
  cancelled,
}

class Ticket {
  final String name;
  final int ticketNumber;
  final String date;
  final String time;
  final TicketStatus status;

  Ticket({
    required this.name,
    required this.ticketNumber,
    required this.date,
    required this.time,
    required this.status,
  });

     factory Ticket.fromJson(Map<String, dynamic> json) {
    String dateString = json['generationtime'] ?? '';
   String ticketIdString = json['ticketid'];
    int ticketId = 0; // Default value, you can change it to any suitable default value

    if (ticketIdString != null && ticketIdString.isNotEmpty) {
      try {
        ticketId = int.parse(ticketIdString);
      } catch (e) {
        // Handle the error when the 'ticketid' is not a valid integer string
        // For example, you can log the error or display an error message
        print('Error parsing ticketid: $e');
      }
    }

    TicketStatus status;
    String statusValue = json['status'];
    switch (statusValue) {
      case '0':
        status = TicketStatus.waiting;
        break;
      case '1':
        status = TicketStatus.attended;
        break;
      case '2':
        status = TicketStatus.cancelled;
        break;
      default:
        status = TicketStatus.waiting; // Set a default status in case of unexpected value
        break;
    }
    // int id=12;
  DateTime dateTime = DateTime.parse(dateString); // Parse the date string into DateTime
  String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime); 
   String formattedTime = DateFormat('hh:mm a').format(dateTime);
    return Ticket(
      name: json['businessName'],
      ticketNumber: ticketId,
      date:formattedDate,
      time: formattedTime,
      status: status,
    );
  }
}

class TicketHistory extends StatefulWidget {
  final String userId;

  TicketHistory({required this.userId});

  @override
  _TicketHistoryState createState() => _TicketHistoryState();
}


class _TicketHistoryState extends State<TicketHistory> with WidgetsBindingObserver {
 List<Ticket> ticketList = [];
 bool _isLoading = false; 
int counter1 = 0;
   Future<void> refreshData( BuildContext context) async {
    setState(() {
      counter1 = counter1+1;
      
    });
    await  fetchUserAllTickets(widget.userId);
    // await fetchnoti();
  }
   void _logout(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserTypeScreen()),
    );
  }

  Future<void> logout() async {
    final url1 =
        'http://192.168.18.154:3000/logout'; // Replace with your API endpoint
    final headers1 = {'Content-Type': 'application/json'};
    final body1 =
        json.encode({'serviceid': widget.userId, 'type': 'user'});

    try {
      final response1 =
          await http.post(Uri.parse(url1), headers: headers1, body: body1);
      // print('Response status code: ${response.statusCode}');
      if (response1.statusCode == 200) {
        print("company logout");
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
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive || state == AppLifecycleState.detached ) {
      // App is going into the background or being terminated
      // Add your code here to perform any cleanup or save data if necessary.

      print('going to recent apps');
      logout();
    }
  }

    @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this); // Add observer here
    fetchUserAllTickets(widget.userId);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this); // Remove observer here
    super.dispose();
  }

 

  

 Future<void> fetchUserAllTickets(String userId) async {

   setState(() {
      _isLoading = true; // Set isLoading to true before making the request
    });

  final url = Uri.parse('http://192.168.18.154:3000/historyalltickets');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'userid': userId}),
  );

  if (response.statusCode == 200) {
    // If the request is successful, parse the response data
    final dynamic responseData = json.decode(response.body);

    if (responseData is int || responseData == null ) {
      // Handle the case when there is no data in the response
      print('No tickets found.');
      setState(() {
        ticketList = [];
        _isLoading = false; 
      });
      return;
    }

    final List<dynamic> data = responseData;

    ticketList = data.map((item) => Ticket.fromJson(item)).toList();
    ticketList.sort((a, b) {
      // Custom sorting based on the status enum order (waiting -> attended -> cancelled)
      return a.status.index.compareTo(b.status.index);
    });

    setState(() {
      // Update the ticketList with the parsed data
      ticketList = data.map((item) => Ticket.fromJson(item)).toList();
    });
    print('Data received: $data');
  } else {
    // If the request fails, handle the error
    print('Request failed with status: ${response.statusCode}');
  }
   setState(() {
      _isLoading = false; // Set isLoading to false after receiving the response
    });
}




   @override
  Widget build(BuildContext context) {
    Color darkblue = Color(0xFF062E70);
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket History'),
        backgroundColor: darkblue,
        automaticallyImplyLeading: false,
      ),
      body: _isLoading // Show the loader if _isLoading is true
          ? Center(child: CircularProgressIndicator())
          : ticketList.isNotEmpty
          ? SingleChildScrollView(
              // Wrap the ListView.builder with SingleChildScrollView
              child: Column(
                children: [
                  // Waiting cards
                  ...ticketList
                      .where((ticket) => ticket.status == TicketStatus.waiting)
                      .map((ticket) => TicketCard(ticket: ticket))
                      .toList(),
                  // Attended cards
                  ...ticketList
                      .where((ticket) => ticket.status == TicketStatus.attended)
                      .map((ticket) => TicketCard(ticket: ticket))
                      .toList(),
                  // Cancelled cards
                  ...ticketList
                      .where((ticket) => ticket.status == TicketStatus.cancelled)
                      .map((ticket) => TicketCard(ticket: ticket))
                      .toList(),
                ],
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/empty.png',
                   width: 100, // Replace 100 with your desired width
                   height: 100, 
                  ), // Replace 'assets/no_tickets.png' with your image asset path
                  SizedBox(height: 16),
                  Text(
                    'No Tickets History',
                    style: TextStyle(
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

class TicketCard extends StatelessWidget {

  void _showCancelledDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ticket Cancelled'),
          content: Text('Ticket Cancelled Succesfully!'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
                // refreshData(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  final Ticket ticket;
  void cancelTickets(BuildContext context,String ticketId) async {
    final url = Uri.parse('http://192.168.18.154:3000/cancelTickets');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({'ticketid': ticketId});

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print("Ticket Cancelled Successfully");
        print("Response: ${response.body}");
        _showCancelledDialog(context);

      } else {
        print("Failed to cancel ticket. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  TicketCard({required this.ticket});

  @override
  Widget build(BuildContext context) {
    Color darkblue = Color(0xFF062E70);
    Color statusColor;
    String statusText;
    bool showCancelButton = false; // Flag to determine if Cancel button should be shown

    switch (ticket.status) {
      case TicketStatus.waiting:
        statusColor = const Color.fromARGB(255, 249, 227, 27);
        statusText = 'Waiting';
        showCancelButton = true; // Show Cancel button for Waiting status
        break;
      case TicketStatus.attended:
        statusColor = Colors.green;
        statusText = 'Attended';
        break;
      case TicketStatus.cancelled:
        statusColor = Colors.red;
        statusText = 'Cancelled';
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Unknown';
    }
TextStyle waitingTextStyle = TextStyle(
    color: Colors.black, // Change to black text color for Waiting status
    fontWeight: FontWeight.bold,
  );
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: statusColor, width: 2),
      ),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ticket.name,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: darkblue),
            ),
            SizedBox(height: 8),
            _buildTicketInfo('Ticket# ', '${ticket.ticketNumber}'),
            _buildTicketInfo('Date', '${ticket.date}'),
            _buildTicketInfo('Time', '${ticket.time}'),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: statusColor,
              ),
              child: Center(
                child: Text(
                  statusText,
                 style: ticket.status == TicketStatus.waiting
              ? waitingTextStyle // Use the waitingTextStyle for Waiting status
              : TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                ),
              ),
            ),
            SizedBox(height: 12), // Add spacing before the button
            if (showCancelButton) // Conditionally show Cancel button
              ElevatedButton(
                onPressed: () {
                  cancelTickets(context,ticket.ticketNumber.toString());
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // Button background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cancel, color: Colors.white), // Cancel icon
                    SizedBox(width: 8),
                    Text(
                      'Cancel Ticket',
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
      ),
    );
  }

  Widget _buildTicketInfo(String heading, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          heading,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }

}
