import 'package:shetimitra/pages/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              const Spacer(),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 380),
                child: Image.asset('assets/shetimitra.png'),
              ),
              const Spacer(),
              Text(
                'शेतीमित्रा मध्ये आपले स्वागत आहे',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold, fontSize: 26),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 30, bottom: 30),
                child: Text(
                  "तुमची कृषी उत्पादने किंवा सेवा तुमच्या घरच्या आरामात मिळवा. तुम्ही तुमच्या आवडत्या उत्पादनांपासून किंवा सेवांपासून फक्त काही क्लिक दूर आहात.",
                  textAlign: TextAlign.center,
                ),
              ),
              FilledButton.tonalIcon(
                onPressed: () {
                  Navigator.of(context).pushReplacement(CupertinoPageRoute(
                      builder: (context) => const MyLogin()));
                },
                icon: const Icon(IconlyLight.login),
                label: const Text("लॉगिन सह सुरू ठेवा"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
