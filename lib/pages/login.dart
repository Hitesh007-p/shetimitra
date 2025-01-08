import 'package:shetimitra/pages/home_page.dart';
import 'package:shetimitra/pages/registration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  TextEditingController countrycode = TextEditingController();
  TextEditingController cnumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isObscured = true;

  @override
  void initState() {
    countrycode.text = '+91';
    super.initState();
    // _checkLoginStatus();
  }

  // Future<void> _checkLoginStatus() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool? isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  //   if (isLoggedIn) {
  //     Navigator.pushReplacementNamed(context, 'home_page');
  //   }
  // }

  // Future<void> loginUser() async {
  //   String cnumber = cnumberController.text;
  //   String password = passwordController.text;

  //   var url = Uri.parse('https://vegetable.mrnetwork.in/api/login');

  //   if (cnumber.isEmpty || password.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Please enter both phone number and password")),
  //     );
  //     return;
  //   }

  //   try {
  //     var response = await http.post(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode({
  //         'cnumber': cnumber,
  //         'password': password,
  //       }),
  //     );

  //     print(response.body);
  //     if (response.statusCode == 200) {
  //       var responseData = jsonDecode(response.body);

  //       if (responseData['message'] == 'Login successful') {
  //         SharedPreferences prefs = await SharedPreferences.getInstance();
  //         await prefs.setBool('isLoggedIn', true);

  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text("Login successful!")),
  //         );

  //         Navigator.pushReplacementNamed(context, 'home');
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text("Login failed: ${responseData['message']}")),
  //         );
  //       }
  //     } else {
  //       var errorData = jsonDecode(response.body);
  //       String errorMessage = errorData['message'] ?? 'Login failed';
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Error: $errorMessage")),
  //       );
  //     }
  //   } catch (error) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Failed to log in: $error")),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/shetimitra.png',
                width: 340,
                height: 340,
              ),
              Text(
                'आधुनिक शेतीसाठी आधुनिक साथीदार!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'तुमच्या शेतासाठी सर्वोत्तम माहिती आणि साधने',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 50),
              Text(
                'तुमच्या खात्यात प्रवेश करा',
                style: TextStyle(fontSize: 17),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.green),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    SizedBox(
                      width: 35,
                      child: TextField(
                        controller: countrycode,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text('|',
                        style: TextStyle(fontSize: 33, color: Colors.green)),
                    SizedBox(width: 5),
                    Expanded(
                      child: TextField(
                        controller: cnumberController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: ' फोन नंबर',
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.green),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: passwordController,
                      obscureText: _isObscured,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: ' पासवर्ड',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscured
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscured = !_isObscured;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text('पासवर्ड विसरलात?'),
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(CupertinoPageRoute(
                        builder: (context) => const HomePage()));
                  },
                  child: Text(
                    'प्रवेश करा',
                    style: TextStyle(color: const Color.fromARGB(255, 6, 5, 5)),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
              ),
              SizedBox(height: 60),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "खाते नाही ?",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                            CupertinoPageRoute(
                                builder: (context) => const MyRegistration()));
                      },
                      child: Text('नोंदणी करा'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
