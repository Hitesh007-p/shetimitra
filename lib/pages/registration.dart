import 'package:shetimitra/pages/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

class MyRegistration extends StatefulWidget {
  const MyRegistration({super.key});

  @override
  State<MyRegistration> createState() => _MyRegistrationState();
}

class _MyRegistrationState extends State<MyRegistration> {
  TextEditingController countrycode = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cnumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  bool _isObscured = true;

  @override
  void initState() {
    countrycode.text = '+91';
    super.initState();
  }

  // Future<void> registerUser() async {
  //   print('object');
  //   String name = nameController.text;
  //   String email = emailController.text;
  //   String cnumber = cnumberController.text;
  //   String password = passwordController.text;
  //   String confirmPassword = confirmPasswordController.text;
  //   String address = addressController.text;

  //   if (password != confirmPassword) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Passwords do not match")),
  //     );
  //     return;
  //   }

  //   var url = Uri.parse('https://vegetable.mrnetwork.in/api/register');
  //   try {
  //     var response = await http.post(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode({
  //         'name': name,
  //         'email': email,
  //         'cnumber': cnumber,
  //         'password': password,
  //         'address': address,
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       var responseData = jsonDecode(response.body);

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //             content:
  //                 Text("Registration successful: ${responseData['message']}")),
  //       );
  //     } else {
  //       var errorData = jsonDecode(response.body);
  //       String errorMessage = errorData['message'] ?? 'Registration failed';
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Error: $errorMessage")),
  //       );
  //     }
  //   } catch (error) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Failed to register: $error")),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/shetimitra.png',
                width: 160,
                height: 160,
              ),
              SizedBox(height: 30),
              Text(
                'नवीन खाते तयार करा',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'तुमचे वापरकर्तानाव आणि पासवर्ड सेट करा. तुम्ही ते नंतर कधीही बदलू शकता',
                style: TextStyle(fontSize: 17),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child:
                    _buildTextField('नाव', nameController, TextInputType.text),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: _buildPhoneField(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: _buildTextField(
                    'तुमचा पत्ता', addressController, TextInputType.text),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: _buildPasswordField('पासवर्ड', passwordController),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: _buildPasswordField(
                    'पासवर्डची पुष्टी करा', confirmPasswordController),
              ),
              SizedBox(height: 15),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(CupertinoPageRoute(
                        builder: (context) => const MyLogin()));
                  },
                  child: Text(
                    'खाते तयार करा',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
              ),
              SizedBox(height: 60),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "आधीच खाते आहे ?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigator.pushNamed(context, 'login');
                    },
                    child: Text('लॉगिन करा'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller,
      TextInputType keyboardType) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.green),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 15),
            hintText: hint,
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Container(
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
                contentPadding: EdgeInsets.symmetric(horizontal: 5),
              ),
            ),
          ),
          SizedBox(width: 10),
          Text('|', style: TextStyle(fontSize: 33, color: Colors.green)),
          SizedBox(width: 5),
          Expanded(
            child: TextField(
              controller: cnumberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 15),
                hintText: 'फोन नंबर',
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPasswordField(String hint, TextEditingController controller) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.green),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          obscureText: _isObscured,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 15),
            hintText: hint,
            suffixIcon: IconButton(
              icon: Icon(
                _isObscured ? Icons.visibility_off : Icons.visibility,
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
    );
  }
}
