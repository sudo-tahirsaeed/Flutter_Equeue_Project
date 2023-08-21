import 'package:flutter/material.dart';
import 'package:queue_project/screens/CategoryScreen.dart';
import 'package:queue_project/screens/SPtickethistory.dart';
import 'package:queue_project/screens/TicketCard.dart';
import 'package:queue_project/screens/Tickethistory.dart';
import 'package:queue_project/screens/myhomepage.dart';
import 'package:queue_project/screens/notification_helper.dart';
import 'package:queue_project/screens/user_state.dart';
import './screens/UserTypeScreen.dart';
import 'package:provider/provider.dart';
import 'package:queue_project/screens/globals.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationHelper.initNotifications();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserState(), // Provide an instance of UserState
      child: RootRestorationScope(
        restorationId: 'root',
        child: MaterialApp(
          restorationScopeId: "root",
          debugShowCheckedModeBanner: false,
          home: UserTypeScreen(),
        ),
      ),
    );
  }
}




class BottomNavigationScreen extends StatefulWidget {
  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> with RestorationMixin {


    final RestorableString _appuserid = RestorableString('');
  
    @override
    String? get restorationId => 'bottom_navigation_screen';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    // Step 2: Read the restored value from the bucket and set it to _appuserid
    registerForRestoration(_appuserid, 'appuserid');
    appuserid = _appuserid.value; // Update appuserid with the restored value
  }

  @override
  void saveState(RestorationBucket? oldBucket, bool initialSave) {
    // Step 3: Save the current appuserid value to the bucket
    _appuserid.value = appuserid;
    print('Saved appuserid: ${_appuserid.value}');
  }

  @override
void initState() {
  super.initState();
  // Your initState code
}

  int _currentIndex = 0;
   Color darkblue = Color(0xFF062E70);

  @override
  Widget build(BuildContext context) {
     UserState userState = Provider.of<UserState>(context);
     print("username: " +userState.userName);
     username = userState.userName;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('My App'),
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.logout),
      //       onPressed: () {
      //         // Implement logout functionality here
      //       },
      //     ),
      //   ],
      // ),
      body: _buildScreen(_currentIndex),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return CategoryScreen();
      case 1:
        return TicketHistory(userId: username,);
      default:
        return Container();
    }
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, -1),
            blurRadius: 18,
          ),
        ],
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: darkblue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.queue),
          //   label: 'Tickets',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }
}

class BottomNavigationScreen2 extends StatefulWidget {
  @override
  _BottomNavigationScreenState2 createState() => _BottomNavigationScreenState2();
}

class _BottomNavigationScreenState2 extends State<BottomNavigationScreen2> {
  Color darkblue = Color(0xFF062E70);
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {

     UserState userState = Provider.of<UserState>(context);
     print("username: " +userState.servideid);
     comapnyid = userState.servideid;

    return Scaffold(
      body: _buildScreen(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: darkblue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        
        ],
      ),
    );
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return MyHomePage();
      case 1:
        return SPTicketHistory(serviceid:comapnyid);

      default:
        return Container();
    }
  }
}











