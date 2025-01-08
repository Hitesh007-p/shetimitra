// ignore_for_file: dead_code

import 'package:flutter/material.dart';

class PosterCard extends StatelessWidget {
  final String image;
  final bool showAdvice;

  PosterCard({required this.image, this.showAdvice = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: SizedBox(
        height: showAdvice ? 190 : 150, // Adjust height based on content
        child: Card(
          color: const Color.fromARGB(255, 228, 236, 229),
          elevation: 0.1,
          shadowColor: const Color.fromARGB(255, 54, 54, 54),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // Free Advice Section
                if (showAdvice) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0, left: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "मोफत सल्ला",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      color: Colors.green.shade700,
                                    ),
                              ),
                              const Text(
                                  "तुमच्या पीक बद्दल काही अडचणी असेन तर आमच्या कृषी डॉक्टर कडून विनामूल्य सल्ला मिळवा."),
                              FilledButton(
                                onPressed: () {
                                  // Handle the action when "Call Now" is pressed
                                },
                                child: const Text("Call now"),
                              ),
                            ],
                          ),
                        ),
                        Image.asset(
                          'assets/contact_us.png', // Ensure the asset exists in your project
                          width: 140,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
