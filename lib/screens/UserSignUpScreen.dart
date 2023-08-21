import 'dart:convert';
// import 'dart:js';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as Path;
import 'package:path/path.dart';
import 'SignInScreen.dart';

class UserSignUpScreen extends StatefulWidget {
  @override
  _UserSignUpScreenState createState() => _UserSignUpScreenState();
}

class _UserSignUpScreenState extends State<UserSignUpScreen> {
  //  BuildContext? _currentContext;
  final _formKey = GlobalKey<FormState>();
  String logintext = "Sign Up";

  final TextEditingController numberController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _showSuccessDialog(BuildContext scontext) {
  showDialog(
    context: scontext,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Signup Success'),
        content: Text('Your signup was successful!'),
        actions: [
          TextButton(
            onPressed: () {
              // Close the dialog
              Navigator.of(context).pop();

              // Navigate to another screen after the dialog is closed
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignInScreen(), // Replace AnotherScreen with the desired screen you want to navigate to.
                ),
              );
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}


  void _showServerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Network Error'),
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

  Future<void> sendDataToServer() async {
    final url = Uri.parse(
        'http://192.168.18.154:3000/usersignup'); // Replace with your server endpoint

    // Prepare the data you want to send (in this example, we're sending a JSON object).
    final data = {
      'name': nameController.text,
      'number': numberController.text,
      'password': passwordController.text,
    };

    try {
      setState(() {
          logintext = "Signing Up...";
        });
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      // print("respose status: $response.statusCode");
      if (response.statusCode == 200) {
        setState(() {
          logintext = "Sign Up";
        });
        // Data successfully inserted into the table.
        print('Data inserted successfully!');
        _showSuccessDialog(this.context);
      } 
      else {
        // Request failed with an error status code.
        setState(() {
          logintext = "Sign Up";
        });
        print('Request failed with status: ${response.statusCode}');
        _showServerDialog(this.context);
      }
    } catch (e) {
      // An error occurred while making the request.
      setState(() {
          logintext = "Sign Up";
        });
      print('Error: $e');
      _showServerDialog(this.context);
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, handle the submission
      // Here you can perform any logic you need when the form is successfully submitted
      String number = numberController.text;
      String password = passwordController.text;
      String name = nameController.text;
      print('Number: $number');
      print('Password: $password');
      print('Name: $name');

      sendDataToServer();
    }
  }

  @override
  Widget build(BuildContext context) {
    Color darkblue = Color(0xFF062E70);
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: darkblue,
         automaticallyImplyLeading: false,
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
                child: const Text(
                  'User Sign Up',
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
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Full Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Full Name';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // Add your desired styles here
                    backgroundColor:Color(0xFF062E70), // Background color of the button
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
                    _submitForm();
                    // Implement user sign-up logic here
                  },
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  _goToSignInScreen(
                    context,
                  );
                },
                child: Row(
                  children: <Widget>[
                    Text("Already have an account?"),
                    const SizedBox(width: 5),
                    Text(
                      'Sign In',
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

  void _goToSignInScreen(
    BuildContext context,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
    );
  }
}
