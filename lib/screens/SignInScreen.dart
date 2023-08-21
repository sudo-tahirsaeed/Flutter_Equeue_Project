import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:queue_project/main.dart';
import 'package:queue_project/screens/CategoryScreen.dart';
import 'package:queue_project/screens/UserTypeScreen.dart';
import 'package:queue_project/screens/forgotpass.dart';
import 'package:queue_project/screens/user_state.dart';
import 'UserSignUpScreen.dart';
import 'notification_helper.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'user_state.dart';
import 'package:provider/provider.dart';

String fullname = '';
 
class SignInScreen extends StatefulWidget {
  // final String userType;

  // SignInScreen({required this.userType});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
 
  bool _isLoading = false;
  String logintext = "Login";

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  // final storage = FlutterSecureStorage();

  void _resetPassword() async {
    setState(() {
      _isLoading = true;
    });

    final phone = _phoneController.text;
    final password = _passwordController.text;

    // Replace '192.168.18.154' with your server IP if running on a real device.
    final url = Uri.parse('http://192.168.18.154:3000/resetpassword');

    final response = await http.post(url, body: {
      'phone': phone,
      'password': password,
      'user': 'user',
    });

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      // print(responseData['code']);
      if (responseData['code'] == '1') {
        _showAlertDialog('Password Reset Successful');
      } else {
        _showAlertDialog('Cannot Reset Password');
      }
    } else {
      _showAlertDialog('Something went wrong. Please try again.');
    }
  }

  void _showAlertDialog(String message) {
    showDialog(
      context: this.context,
      builder: (context) => AlertDialog(
        title: Text('Password Reset'),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  final _formKey = GlobalKey<FormState>(); // Create a global key for the form
  final TextEditingController numberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _goToSignUpScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserSignUpScreen()),
    );
  }

  void _gotoForgotPassScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
    );
  }
  static Route<void> _signInNavigation(context,arguemnents) =>
  MaterialPageRoute(builder: (context) => BottomNavigationScreen());


  void _showInvalidDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invalid Credentials'),
          content: Text('Incorrect Phone number or Password!'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showd(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cant Login on Multiple Devices'),
          content: Text('Account is Being used on other device!'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showFailedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Check Your Internet Connection!'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> authenticateUser(String phone, String password) async {
    final url = Uri.parse('http://192.168.18.154:3000/checkcredentialsusers');
    final data = {
      'data1': {
        'phone': phone,
        'password': password,
      },
    };

    try {
      setState(() {
          logintext = "Logging In...";
        });

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      
      if (response.statusCode == 200) {
        
        // Authentication successful, check the response for the result
        final result = response.body; // The result will be either "1" or "0"

        final responseData = json.decode(response.body);
        // print(responseData['data']);
        print(responseData['status']);
        

        if (responseData['status'] == "1") {
        fullname = responseData['data'][0]['fullname'] ?? [];
        // final authToken = responseData['data'][0]['authToken'];
        print('Fullname: $fullname');

          print('User authentication successful!');
          setState(() {
            logintext = "Login";
          });

          
          Navigator.restorablePush(context, _signInNavigation);
          // userState.setUserName('John Doe');
        } else if (responseData['status'] == "7") {
          print('Account is being Used on other Device!');
          showd(context);
          setState(() {
            logintext = "Login";
          });
        } else {
          print('Invalid phone number or password.' + result.toString());
          _showInvalidDialog(context);
          setState(() {
            logintext = "Login";
          });
        }
      } else {
        // Request failed with an error status code.
        print('Request failed with status: ${response.statusCode}');
        setState(() {
          logintext = "Login";
        });
      }
    } catch (e) {
      // An error occurred while making the request.
      print('Error: $e');
      _showFailedDialog(context);
      setState(() {
        logintext = "Login";
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, handle the submission
      // Here you can perform any logic you need when the form is successfully submitted
      String number = numberController.text;
      String password = passwordController.text;
      print('Number: $number');
      print('Password: $password');

      await authenticateUser(number, password);

      // Now that the authentication is complete, set the user name
      final userState = Provider.of<UserState>(context, listen: false);
      userState.setUserName(number);
      userState.setName(fullname);
    }
  }

  void _logout(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserTypeScreen()),
    );
  }
   bool _passwordVisible = false;
    @override
    void initState() {
      _passwordVisible = false;
      super.initState();
      // _checkLoggedIn();

    }
//     void _checkLoggedIn() async {
//   final authToken = await storage.read(key: 'authToken');
//   if (authToken != null) {
//     // You have a stored token, perform automatic login
//     // Replace this with your actual authentication logic
//     final userState = Provider.of<UserState>(context, listen: false);
//     userState.setUserName(numberController.text); // Set the user's name if needed
//     Navigator.restorablePush(context, _signInNavigation);
//   }
// }

  @override
  Widget build(BuildContext context) {
  
    Color darkblue = Color(0xFF062E70);
    UserState userState = Provider.of<UserState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        backgroundColor: darkblue,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
                Icons.home_filled), // You can choose any logout icon you like
            onPressed: () {
              _logout(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey, // Associate the form key with the Form widget
          child: ListView(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'E-QUEUE',
                  style: TextStyle(
                    color: Color(0xFF062E70),
                    fontWeight: FontWeight.w500,
                    fontSize: 30,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: Text(
                  'User Login',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: numberController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Number',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your number';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                   obscureText: !_passwordVisible, // 
                  controller: passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 5),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => _buildResetPasswordDialog(),
                    );
                  },
                  child: const Text('Forgot Password'),
                ),
              ),
              SizedBox(height: 5),
              Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // Add your desired styles here
                    backgroundColor:
                        Color(0xFF062E70), // Background color of the button
                    foregroundColor:
                        Colors.white, // Text color of the button when pressed
                    textStyle: TextStyle(
                        fontSize: 16), // Style for the text within the button
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8.0), // Rounded corners
                    ),
                    padding: EdgeInsets.all(10), // Padding inside the button
                  ),
                  child: Text(logintext),
                  onPressed: () {
                    userState.setUserName(numberController.text);
                    _submitForm();
                    userState.setName(fullname);
                  },
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  _goToSignUpScreen(context);
                },
                child: Row(
                  children: <Widget>[
                    Text("Don't have an account?"),
                    const SizedBox(width: 5),
                    Text(
                      'Sign up',
                      style: TextStyle(
                          fontSize: 16, color: Color.fromRGBO(16, 90, 174, 1)),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResetPasswordDialog() {
    return AlertDialog(
      title: Text('Reset Password'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(labelText: 'Phone Number'),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: 'New Password'),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(this.context).pop();
            _resetPassword();
          },
          child: Text('Done'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(this.context).pop(),
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
