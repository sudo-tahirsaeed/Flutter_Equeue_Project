import 'package:flutter/material.dart';
// import 'package:path/path.dart' as Path;
import 'dart:convert';
import 'package:http/http.dart' as http;
class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool _isLoading = false;

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _resetPassword() async {
    setState(() {
      _isLoading = true;
    });

    final phone = _phoneController.text;
    final password = _passwordController.text;

    // Replace 'localhost' with your server IP if running on a real device.
    final url = Uri.parse('http://localhost:3000/resetpassword');

    final response = await http.post(url, body: {
      'phone': phone,
      'password': password,
      'user': 'company',
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
      context: context,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forgot Password')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                     
                    },
                    child: Text('Forgot Password'),
                  ),
                ],
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
            Navigator.of(context).pop();
            _resetPassword();
          },
          child: Text('Done'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
      ],
    );
  }
}