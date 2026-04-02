import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shetimitra/l10n/app_localizations.dart';
import 'package:shetimitra/pages/expence.dart';

class Calculation extends StatefulWidget {
  const Calculation({super.key});

  @override
  State<Calculation> createState() => _CalculationState();
}

class _CalculationState extends State<Calculation>
    with AutomaticKeepAliveClientMixin {
  String? selectedCrop;
  String? selectedSeason;

  final crops = [
    'cropWheat',
    'cropChickpea',
    'cropMaize',
    'cropTomato',
    'cropBanana',
    'cropSugarcane',
    'cropCotton',
  ];

  final seasons = ['kharif', 'rabi'];

  late PageController _pageController;
  int _currentAdIndex = 0;
  Timer? _carouselTimer;

  final List<Map<String, String>> farmingAds = [
    {'image': 'assets/images/aadhunik_sheti.jpeg', 'title': 'modernFarmingTechniques'},
    {'image': 'assets/images/vermicompost.jpeg', 'title': 'organicSolutions'},
    {'image': 'assets/images/shetimitra.jpg', 'title': 'cropManagement'},
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

      final nextPage = _currentAdIndex < farmingAds.length - 1 ? _currentAdIndex + 1 : 0;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentAdIndex = nextPage;
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
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 250,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: farmingAds.length,
                  onPageChanged: (page) {
                    setState(() {
                      _currentAdIndex = page;
                    });
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
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withAlpha((0.7 * 255).round()),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        alignment: Alignment.bottomLeft,
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          l10n.t(farmingAds[index]['title']!),
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
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.t('chooseCrop'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  DropdownButtonFormField<String>(
                    initialValue: selectedCrop,
                    items: crops.map((crop) {
                      return DropdownMenuItem(
                        value: crop,
                        child: Text(l10n.cropName(crop)),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => selectedCrop = value),
                  ),
                  const SizedBox(height: 20),
                  Text(l10n.t('chooseSeason'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  DropdownButtonFormField<String>(
                    initialValue: selectedSeason,
                    items: seasons.map((season) {
                      return DropdownMenuItem(
                        value: season,
                        child: Text(l10n.t(season)),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => selectedSeason = value),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
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
                          SnackBar(content: Text(l10n.t('pleaseSelectCropAndSeason'))),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(double.infinity, 52),
                    ),
                    child: Text(
                      l10n.t('next'),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
