// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shetimitra/l10n/app_localizations.dart';
import 'package:shetimitra/pages/aihelthscanner.dart';
import 'package:shetimitra/pages/land_measurement.dart';
import 'package:shetimitra/pages/post_creation_screen.dart';
import 'package:shetimitra/services/weather_service.dart';
import 'package:shetimitra/services/webview.dart';
import 'package:shetimitra/widgets/insuranceoption.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with AutomaticKeepAliveClientMixin {
  final WeatherService _weatherService = WeatherService();
  bool _isLoading = true;
  bool _isWeatherExpanded = false;
  Map<String, dynamic>? weatherInfo;
  final List<Map<String, dynamic>> _posts = [];

  String? _selectedCrop;
  final List<String> _crops = const [
    'cropWheat',
    'cropChickpea',
    'cropMaize',
    'cropTomato',
    'cropBanana',
    'cropSugarcane',
    'cropCotton',
    'cropPapaya',
    'cropWatermelon',
    'cropPaddy',
    'cropSoybean',
    'cropChili',
    'cropEggplant',
  ];

  final Map<String, String> _cropImages = const {
    'cropWheat': 'assets/crops/wheat.png',
    'cropChickpea': 'assets/crops/kabuli.png',
    'cropMaize': 'assets/crops/makka.png',
    'cropTomato': 'assets/tomato.jpg',
    'cropBanana': 'assets/crops/banana.png',
    'cropSugarcane': 'assets/crops/shugarcane.png',
    'cropCotton': 'assets/crops/Cotton.jpg',
    'cropPapaya': 'assets/crops/papaya.jpg',
    'cropWatermelon': 'assets/crops/whatermelon.png',
    'cropPaddy': 'assets/crops/whatermelon.png',
    'cropSoybean': 'assets/crops/soyabean.png',
    'cropChili': 'assets/crops/green_chilly.png',
    'cropEggplant': 'assets/crops/vange.png',
  };

  late final PageController _adPageController;
  Timer? _carouselTimer;
  int _currentAdPage = 0;

  final List<Map<String, String>> _ads = const [
    {
      'image': 'assets/images/fertilizer.jpg',
      'title': 'bestFertilizers',
      'subtitle': 'bestFertilizersSubtitle',
    },
    {
      'image': 'assets/images/droan.jpg',
      'title': 'droneRental',
      'subtitle': 'droneRentalSubtitle',
    },
    {
      'image': 'assets/images/irrigation_ad.jpg',
      'title': 'irrigationSystems',
      'subtitle': 'irrigationSystemsSubtitle',
    },
  ];

  @override
  void initState() {
    super.initState();
    _adPageController = PageController();
    _fetchWeather();
    _startAdCarousel();
  }

  Future<void> _fetchWeather() async {
    try {
      final position = await _getCurrentLocation();
      final weatherData = await _weatherService.getWeather(
        position.latitude,
        position.longitude,
      );
      if (mounted) {
        setState(() {
          weatherInfo = weatherData;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<Position> _getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return Geolocator.getCurrentPosition();
  }

  void _startAdCarousel() {
    _carouselTimer?.cancel();
    _carouselTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted || !_adPageController.hasClients) return;
      final newPage = _currentAdPage < _ads.length - 1 ? _currentAdPage + 1 : 0;
      _adPageController.animateToPage(
        newPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentAdPage = newPage;
      });
    });
  }

  void _launchWebView(BuildContext context, String url, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewScreen(url: url, title: title),
      ),
    );
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
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PostCreationScreen()),
          ).then((newPost) {
            if (newPost != null) {
              setState(() {
                _posts.add(newPost);
              });
            }
          });
        },
        backgroundColor: Colors.green.shade600,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (weatherInfo != null)
            _buildWeatherWidget(l10n)
          else
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(l10n.t('weatherUnavailable')),
              ),
            ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.t('chooseCrop'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedCrop,
                    items: _crops
                        .map(
                          (crop) => DropdownMenuItem(
                            value: crop,
                            child: Text(l10n.cropName(crop)),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCrop = value;
                      });
                    },
                  ),
                  if (_selectedCrop != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      l10n.t('selectedCropLabel'),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: Text(l10n.cropName(_selectedCrop!))),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            _cropImages[_selectedCrop!]!,
                            height: 72,
                            width: 72,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.agriculture, color: Colors.green[800]),
                      const SizedBox(width: 8),
                      Text(
                        l10n.t('farmerTools'),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.green[900],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildToolItem(
                          context,
                          image: 'assets/shovel.jpg',
                          label: l10n.t('landMeasurementTool'),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LandMeasurementPage(),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: _buildToolItem(
                          context,
                          image: 'assets/helthscan.jpg',
                          label: l10n.t('aiHealthTool'),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PlantDiseaseDetector(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _adPageController,
                  itemCount: _ads.length,
                  onPageChanged: (page) {
                    setState(() {
                      _currentAdPage = page;
                    });
                  },
                  itemBuilder: (context, index) {
                    final ad = _ads[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: AssetImage(ad['image']!),
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
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.t(ad['title']!),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              l10n.t(ad['subtitle']!),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: Colors.orange.shade50,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.t('farmingServices'),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () => _launchWebView(
                          context,
                          'https://pmfby.gov.in/',
                          l10n.t('cropInsurance'),
                        ),
                        child: InsuranceOption(
                          icon: Icons.grass,
                          title: l10n.t('cropInsurance'),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _launchWebView(
                          context,
                          'https://mahadbt.maharashtra.gov.in/Login/Login',
                          l10n.t('mahaDbt'),
                        ),
                        child: InsuranceOption(
                          icon: Icons.edit_document,
                          title: l10n.t('mahaDbt'),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _launchWebView(
                          context,
                          'https://digitalsatbara.mahabhumi.gov.in/dslr',
                          l10n.t('download712'),
                        ),
                        child: InsuranceOption(
                          icon: Icons.description,
                          title: l10n.t('download712'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (_posts.isNotEmpty)
            Text(
              l10n.t('communityPosts'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ..._posts.map((post) => _buildPostCard(context, post, l10n)),
        ],
      ),
    );
  }

  Widget _buildWeatherWidget(AppLocalizations l10n) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isWeatherExpanded = !_isWeatherExpanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: _isWeatherExpanded ? 320 : 180,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromARGB(255, 238, 255, 238),
              Colors.green.shade50,
            ],
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.green.shade200.withAlpha((0.5 * 255).round()),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: _isWeatherExpanded
            ? ListView(
                children: [
                  Text(
                    '${weatherInfo!['name']}, ${weatherInfo!['sys']['country']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _weatherRow(l10n.t('weather'),
                      '${weatherInfo!['weather'][0]['description']}'),
                  _weatherRow(l10n.t('temperature'),
                      '${weatherInfo!['main']['temp']}�C'),
                  _weatherRow(l10n.t('feelsLike'),
                      '${weatherInfo!['main']['feels_like']}�C'),
                  _weatherRow(l10n.t('humidity'),
                      '${weatherInfo!['main']['humidity']}%'),
                  _weatherRow(
                      l10n.t('wind'), '${weatherInfo!['wind']['speed']} m/s'),
                  _weatherRow(l10n.t('visibility'),
                      '${weatherInfo!['visibility'] / 1000} km'),
                  _weatherRow(l10n.t('pressure'),
                      '${weatherInfo!['main']['pressure']} hPa'),
                ],
              )
            : Row(
                children: [
                  Image.network(
                    'https://openweathermap.org/img/w/${weatherInfo!['weather'][0]['icon']}.png',
                    width: 80,
                    height: 80,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${weatherInfo!['name']}, ${weatherInfo!['sys']['country']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                            '${weatherInfo!['main']['temp_min']}�C - ${weatherInfo!['main']['temp_max']}�C'),
                        Text(
                            '${l10n.t('weather')}: ${weatherInfo!['weather'][0]['description']}'),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _weatherRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildToolItem(
    BuildContext context, {
    required String image,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                image,
                width: 120,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.green[900],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostCard(
    BuildContext context,
    Map<String, dynamic> post,
    AppLocalizations l10n,
  ) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.green.shade200,
                  child: Text(
                    post['farmerName'][0],
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post['farmerName'],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      post['location'],
                      style:
                          TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                File(post['image']),
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 15),
            Text(post['description']),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.thumb_up_alt_outlined),
                    ),
                    Text(l10n.t('like')),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.comment_outlined),
                    ),
                    Text(l10n.t('comment')),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
