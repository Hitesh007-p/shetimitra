import 'package:flutter/material.dart';

class Service {
  final String name;
  final String image;
  final Widget destination;

  const Service({
    required this.name,
    required this.image,
    required this.destination,
  });
}






       // Padding(
          //   padding: const EdgeInsets.only(top: 25, bottom: 10, left: 20),
          //   child: Text(
          //     "शेती सौरक्षण",
          //     style: Theme.of(context).textTheme.titleLarge,
          //   ),
          // ),
          // GridView.builder(
          //   shrinkWrap: true,
          //   physics: const NeverScrollableScrollPhysics(),
          //   itemCount: services.length,
          //   padding: const EdgeInsets.all(16),
          //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 2,
          //     childAspectRatio: 0.95,
          //     crossAxisSpacing: 14,
          //     mainAxisSpacing: 14,
          //   ),
          //   itemBuilder: (context, index) {
          //     return GestureDetector(
          //       onTap: () {
          //         // Navigate to the corresponding screen based on the service index
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) => services[index].destination,
          //           ),
          //         );
          //       },
          //       child: Container(
          //         alignment: Alignment.bottomCenter,
          //         padding: const EdgeInsets.all(8),
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(8),
          //           image: DecorationImage(
          //             image: AssetImage(services[index].image),
          //             fit: BoxFit.cover,
          //           ),
          //         ),
          //         child: ClipRRect(
          //           borderRadius: BorderRadius.circular(5),
          //           child: BackdropFilter(
          //             filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          //             child: Container(
          //               padding: const EdgeInsets.symmetric(
          //                   vertical: 5, horizontal: 10),
          //               decoration: BoxDecoration(
          //                 color: Colors.white.withOpacity(0.2),
          //                 borderRadius:
          //                     const BorderRadius.all(Radius.circular(5)),
          //               ),
          //               child: Text(
          //                 services[index].name,
          //                 style: const TextStyle(
          //                   color: Colors.white,
          //                   fontSize: 20,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     );
          //   },
          // ),