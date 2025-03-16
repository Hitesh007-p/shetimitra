import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shetimitra/pages/home_page.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController otpController = TextEditingController();

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
                'कृपया आपल्या फोन नंबरवर पाठवलेला OTP प्रविष्ट करा',
                style: TextStyle(fontSize: 17),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              _buildOTPField(),
              SizedBox(height: 20),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(CupertinoPageRoute(
                        builder: (context) => const HomePage()));
                  },
                  child: Text(
                    'OTP सत्यापित करा',
                    style: TextStyle(
                        color: const Color.fromARGB(255, 6, 5, 5),
                        fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // OTP पुनर्प्राप्त करा क्रिया
                },
                child: Text(
                  'OTP पुनर्प्राप्त करा',
                  style: TextStyle(color: Colors.green, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOTPField() {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.green),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: TextField(
          controller: otpController,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 6,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 15),
            hintText: 'OTP प्रविष्ट करा',
            counterText: "",
          ),
        ),
      ),
    );
  }

//   void _verifyOTP() {
//     String otp = otpController.text;
//     if (otp.length == 6) {
//       // OTP पडताळणी लॉजिक
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("OTP यशस्वीरित्या पडताळला")),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("कृपया वैध 6-अंकी OTP प्रविष्ट करा")),
//       );
//     }
//   }
}
