// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:ui';

import 'package:shetimitra/data/services.dart';
import 'package:flutter/material.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage>
    with AutomaticKeepAliveClientMixin {
  late PageController _adPageController;
  int _currentAdPage = 0;
  Timer? _carouselTimer;
  final List<Map<String, String>> ads = [
    {
      'image': 'assets/images/mordern_farm.jpg',
      'title': 'Modern Farming Techniques'
    },
    {
      'image': 'assets/images/organic_solution.jpg',
      'title': 'Organic Solutions'
    },
    {'image': 'assets/images/crop_managment.jpg', 'title': 'Crop Management'},
  ];

  @override
  void initState() {
    super.initState();
    _adPageController = PageController(viewportFraction: 0.9);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoCarousel();
    });
  }

  void _startAutoCarousel() {
    _carouselTimer?.cancel();
    _carouselTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted || !_adPageController.hasClients) return;

      final nextPage = _currentAdPage < ads.length - 1 ? _currentAdPage + 1 : 0;

      _adPageController
          .animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      )
          .then((_) {
        if (mounted) setState(() => _currentAdPage = nextPage);
      });
    });
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _adPageController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        children: [
          _buildAdCarousel(),
          // Services Grid
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: services.length,
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.95,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => services[index].destination,
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            services[index].image,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.6),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 10,
                            right: 10,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    services[index].name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdCarousel() {
    return Visibility(
      visible: ads.isNotEmpty,
      child: SizedBox(
        height: 250,
        child: Stack(
          children: [
            PageView.builder(
              controller: _adPageController,
              itemCount: ads.length,
              onPageChanged: (page) {
                if (mounted) setState(() => _currentAdPage = page);
              },
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: AssetImage(ads[index]['image']!),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      ads[index]['title']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(ads.length, (index) {
                  return Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentAdPage == index
                          ? Colors.white
                          : Colors.white54,
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
