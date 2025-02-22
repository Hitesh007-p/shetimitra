// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shetimitra/pages/expence.dart';

class Calculation extends StatefulWidget {
  const Calculation({Key? key}) : super(key: key);

  @override
  State<Calculation> createState() => _CalculationState();
}

class _CalculationState extends State<Calculation>
    with AutomaticKeepAliveClientMixin {
  String? selectedCrop;
  String? selectedSeason;

  final crops = ['गहू', 'हरभरा', 'मक्का', 'टोमॅटो', 'केळी', 'ऊस', 'कापूस'];
  final seasons = ['खरीफ', 'रब्बी'];

  late PageController _pageController;
  int _currentAdIndex = 0;
  Timer? _carouselTimer;

  final List<Map<String, String>> farmingAds = [
    {
      'image': 'assets/images/aadhunik_sheti.jpeg',
      'title': 'आधुनिक शेती पद्धती'
    },
    {'image': 'assets/images/vermicompost.jpeg', 'title': 'सेंद्रिय शेती'},
    {'image': 'assets/images/shetimitra.jpg', 'title': 'पाण्याचे व्यवस्थापन'},
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoCarousel();
    });
  }

  void _startAutoCarousel() {
    _carouselTimer?.cancel();
    _carouselTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted || !_pageController.hasClients) return;

      final nextPage =
          _currentAdIndex < farmingAds.length - 1 ? _currentAdIndex + 1 : 0;

      _pageController
          .animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      )
          .then((_) {
        if (mounted) setState(() => _currentAdIndex = nextPage);
      });
    });
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _pageController.dispose();
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
          // Advertisement Section
          _buildCarouselSlider(),
          // Content Section
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSelectionSection(),
                  const SizedBox(height: 40),
                  _buildSaveButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselSlider() {
    return Visibility(
      visible: farmingAds.isNotEmpty,
      child: SizedBox(
        height: 250,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: farmingAds.length,
              onPageChanged: (page) {
                if (mounted) setState(() => _currentAdIndex = page);
              },
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: AssetImage(farmingAds[index]['image']!),
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
                      farmingAds[index]['title']!,
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
                children: List.generate(farmingAds.length, (index) {
                  return Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentAdIndex == index
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

  Widget _buildSelectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'पीक निवडा:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        DropdownButtonFormField<String>(
          value: selectedCrop,
          items: crops.map((crop) {
            return DropdownMenuItem(
              value: crop,
              child: Text(crop),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedCrop = value;
            });
          },
        ),
        const SizedBox(height: 20),
        const Text(
          'हंगाम निवडा:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        DropdownButtonFormField<String>(
          value: selectedSeason,
          items: seasons.map((season) {
            return DropdownMenuItem(
              value: season,
              child: Text(season),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedSeason = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          if (selectedCrop != null && selectedSeason != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExpenseManagementPage(
                  crops: selectedCrop!,
                  seasons: selectedSeason!,
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: const [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "कृपया पीक आणि सीजन निवडा",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          "पुढे",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
