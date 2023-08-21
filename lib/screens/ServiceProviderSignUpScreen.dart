import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:queue_project/screens/ServiceProviderSignInScreen.dart';

class ServiceProviderSignUpScreen extends StatefulWidget {
  @override
  _ServiceProviderSignUpScreenState createState() =>
      _ServiceProviderSignUpScreenState();
}

class _ServiceProviderSignUpScreenState
    extends State<ServiceProviderSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController businessnameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
String logintext = "Register";
  // List of available types
  List<String> type = ['Hospital', 'Bank', 'Ministry'];
  String selectedType = 'Hospital';

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
                  builder: (context) => ServiceProviderSignInScreen(), // Replace AnotherScreen with the desired screen you want to navigate to.
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
        'http://192.168.18.154:3000/companysignup'); // Replace with your server endpoint

    // Prepare the data you want to send (in this example, we're sending a JSON object).
    final data = {
      'businessname': businessnameController.text,
      'phone': numberController.text,
      'password': passwordController.text,
      'address': addressController.text,
      'type':selectedType,
    };

    try {
      setState(() {
          logintext = "Registering...";
        });
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        // Data successfully inserted into the table.
        setState(() {
          logintext = "Register";
        });
        print('Data inserted successfully!');
        _showSuccessDialog(this.context);
         setState(() {
          logintext = "Register";
        });

      } else {
        // Request failed with an error status code.
        print('Request failed with status: ${response.statusCode}');
        _showServerDialog(this.context);
         setState(() {
          logintext = "Register";
        });
      }
    } catch (e) {
      // An error occurred while making the request.
      print('Error: $e');
      _showServerDialog(this.context);
       setState(() {
          logintext = "Register";
        });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, handle the submission
      // Here you can perform any logic you need when the form is successfully submitted
      String number = numberController.text;
      String password = passwordController.text;
      String bussname = businessnameController.text;
      String address = addressController.text;
      String type = selectedType;
      print('Number: $number');
      print('Password: $password');
      print('Business name: $bussname');
      print('Address: $address');
      print('Business Type: $type');

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
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // Drop-down menu for selecting the business type
           

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
                  'Service Provider Registration',
                  style: TextStyle(fontSize: 20),
                ),
              ),
                 Container(
                padding: const EdgeInsets.all(10),
                child: DropdownButtonFormField<String>(
                  value: selectedType,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedType = newValue!;
                    });
                  },
                  items: type.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Business Type',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a Business Type';
                    }
                    return null;
                  },
                ),
              ),

              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: businessnameController,
                  // keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Business Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Business Name';
                    }
                    return null;
                  },
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
                  controller: addressController,
                  // keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Address',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Address';
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
              SizedBox(height: 10),
              Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // Add your desired styles here
                    backgroundColor: Color(0xFF062E70), // Background color of the button
                    foregroundColor: Colors.white, // Text color of the button when pressed
                    textStyle: TextStyle(
                      fontSize: 16, // Style for the text within the button
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Rounded corners
                    ),
                    padding: EdgeInsets.all(10), // Padding inside the button
                  ),
                  child: Text(logintext),
                  onPressed: () {
                    // Implement service provider registration logic here
                    _submitForm();
                  },
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  _goToSignInScreen(context);
                },
                child: Row(
                  children: <Widget>[
                    Text("Already have an account?"),
                    const SizedBox(width: 5),
                    Text(
                      'Sign In',
                      style: TextStyle(fontSize: 16, color: Colors.blue),
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

  void _goToSignInScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ServiceProviderSignInScreen()),
    );
  }
}
