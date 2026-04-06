// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shetimitra/l10n/app_localizations.dart';
import 'package:shetimitra/pages/aihelthscanner.dart';
import 'package:shetimitra/pages/drone_service_screen.dart';
import 'package:shetimitra/pages/language_settings_page.dart';
import 'package:shetimitra/pages/land_measurement.dart';
import 'package:shetimitra/pages/machinery_service_screen.dart';
import 'package:shetimitra/pages/soil_testing_screen.dart';
import 'package:shetimitra/pages/post_creation_screen.dart';
import 'package:shetimitra/services/market_price_service.dart';
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
  final MarketPriceService _marketPriceService = MarketPriceService();
  final ScrollController _marketTickerController = ScrollController();
  bool _isLoading = true;
  bool _isWeatherExpanded = false;
  bool _isMarketExpanded = false;
  Map<String, dynamic>? weatherInfo;
  bool _isMarketLoading = true;
  String? _marketError;
  List<Map<String, dynamic>> _marketPrices = [];
  String? _marketLocationLabel;
  final TextEditingController _marketCropController = TextEditingController();
  final TextEditingController _marketSearchController = TextEditingController();
  final List<Map<String, dynamic>> _posts = [];

  late final PageController _adPageController;
  Timer? _carouselTimer;
  Timer? _marketTickerTimer;
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
    _fetchMarketPrices();
    _startAdCarousel();
    _startMarketTicker();
  }

  Widget _buildMarketSection(AppLocalizations l10n) {
    return Card(
      color: Colors.blue.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _toggleMarketExpanded,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.t('marketPricesTitle'),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Colors.blue.shade900,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        Icon(
                          _isMarketExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.blue.shade800,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.t('marketPricesSubtitle'),
                      style: TextStyle(
                        color: Colors.blueGrey.shade700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildMarketTicker(l10n),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.touch_app,
                          size: 16,
                          color: Colors.blue.shade700,
                        ),
                        const SizedBox(width: 6),
                        if (!_isMarketLoading && _marketPrices.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              l10n.format(
                                'marketEntriesCount',
                                {'count': _marketPrices.length.toString()},
                              ),
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: _buildMarketExpandedContent(l10n),
              ),
              crossFadeState: _isMarketExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketTicker(AppLocalizations l10n) {
    if (_isMarketLoading) {
      return SizedBox(
        height: 52,
        child: Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              color: Colors.blue.shade700,
            ),
          ),
        ),
      );
    }

    if (_marketError != null || _marketPrices.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          _marketError != null
              ? l10n.t('marketFetchError')
              : l10n.t('marketNoData'),
          style: TextStyle(color: Colors.grey.shade700),
        ),
      );
    }

    final loopingPrices = List<Map<String, dynamic>>.generate(
      _marketPrices.length * 12,
      (index) => _marketPrices[index % _marketPrices.length],
    );

    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SingleChildScrollView(
          controller: _marketTickerController,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: Row(
            children: loopingPrices
                .map((record) => _buildMarketTickerItem(record, l10n))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildMarketTickerItem(
    Map<String, dynamic> record,
    AppLocalizations l10n,
  ) {
    final commodity = _localizedCommodityName(record, l10n);
    final market = record['market']?.toString() ??
        record['market_name']?.toString() ??
        l10n.t('marketMarketFallback');
    final price = record['modal_price'] ??
        record['min_price'] ??
        record['max_price'] ??
        '';

    return InkWell(
      onTap: () => _openMarketFromTicker(record),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          '$commodity - $market - $price',
          style: TextStyle(
            color: Colors.blue.shade900,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildMarketExpandedContent(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_marketLocationLabel != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              l10n.format(
                'marketNearbyLabel',
                {'location': _marketLocationLabel!},
              ),
              style: TextStyle(
                color: Colors.blueGrey.shade700,
                fontSize: 13,
              ),
            ),
          ),
        TextField(
          controller: _marketCropController,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: l10n.t('marketSearchCropHint'),
            prefixIcon: const Icon(Icons.agriculture),
          ),
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _applyMarketFilters(),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _marketSearchController,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: l10n.t('marketSearchMarketHint'),
            prefixIcon: const Icon(Icons.location_on),
          ),
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _applyMarketFilters(),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _applyMarketFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                ),
                child: Text(l10n.t('marketFilter')),
              ),
            ),
            const SizedBox(width: 10),
            OutlinedButton(
              onPressed: _clearMarketFilters,
              child: Text(l10n.t('marketClear')),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_isMarketLoading)
          const Center(child: CircularProgressIndicator())
        else if (_marketError != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.t('marketFetchError'),
                style: TextStyle(color: Colors.red.shade700),
              ),
              const SizedBox(height: 8),
              Text(
                _marketError!,
                style: TextStyle(color: Colors.red.shade900, fontSize: 12),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _fetchMarketPrices,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                ),
                child: Text(l10n.t('marketRetry')),
              ),
            ],
          )
        else if (_marketPrices.isEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.t('marketNoData'),
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.t('marketNoDataHelp'),
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _fetchMarketPrices,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                ),
                child: Text(l10n.t('marketRetry')),
              ),
            ],
          )
        else
          Column(
            children: _marketPrices.take(5).map(_buildMarketPriceRow).toList(),
          ),
      ],
    );
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
          _marketLocationLabel = weatherData['name']?.toString() ?? 'your area';
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

  Future<void> _fetchMarketPrices({
    String? commodity,
    String? market,
  }) async {
    if (mounted) {
      setState(() {
        _isMarketLoading = true;
      });
    }

    try {
      final records = await _marketPriceService.getMarketPrices(
        limit: 8,
        commodity: commodity?.isNotEmpty == true ? commodity : null,
        market: market?.isNotEmpty == true ? market : null,
      );
      if (mounted) {
        setState(() {
          _marketPrices = records;
          _marketError = null;
          _isMarketLoading = false;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_marketTickerController.hasClients) {
            _marketTickerController.jumpTo(0);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _marketPrices = [];
          _marketError = e.toString();
          _isMarketLoading = false;
        });
      }
    }
  }

  void _applyMarketFilters() {
    _fetchMarketPrices(
      commodity: _marketCropController.text.trim(),
      market: _marketSearchController.text.trim(),
    );
  }

  void _clearMarketFilters() {
    _marketCropController.clear();
    _marketSearchController.clear();
    _fetchMarketPrices();
  }

  Widget _buildMarketPriceRow(Map<String, dynamic> record) {
    final l10n = AppLocalizations.of(context);
    final commodity = _localizedCommodityName(record, l10n);
    final market = record['market']?.toString() ??
        record['market_name']?.toString() ??
        l10n.t('marketMarketFallback');
    final price = record['modal_price'] ??
        record['min_price'] ??
        record['max_price'] ??
        '';
    final arrivalDate = record['arrival_date'] ?? record['date'] ?? '';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.75),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.storefront, color: Colors.blue.shade700),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  commodity,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  '${l10n.t('marketMarketLabel')}: $market',
                  style: TextStyle(color: Colors.blueGrey.shade700),
                ),
                const SizedBox(height: 4),
                Text(
                  '${l10n.t('marketPriceLabel')}: $price',
                  style: TextStyle(color: Colors.grey.shade800),
                ),
                if (arrivalDate != null && arrivalDate.toString().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      '${l10n.t('marketDateLabel')}: $arrivalDate',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openMarketFromTicker(Map<String, dynamic> record) {
    setState(() {
      _isMarketExpanded = true;
      _marketCropController.text = record['commodity']?.toString() ??
          record['commodity_name']?.toString() ??
          '';
      _marketSearchController.text = record['market']?.toString() ??
          record['market_name']?.toString() ??
          '';
    });
  }

  void _toggleMarketExpanded() {
    setState(() {
      _isMarketExpanded = !_isMarketExpanded;
    });
  }

  void _startMarketTicker() {
    _marketTickerTimer?.cancel();
    _marketTickerTimer = Timer.periodic(const Duration(milliseconds: 20), (_) {
      if (!mounted ||
          !_marketTickerController.hasClients ||
          _marketPrices.isEmpty) {
        return;
      }

      final position = _marketTickerController.position;
      if (!position.hasContentDimensions || position.maxScrollExtent <= 0) {
        return;
      }

      final nextOffset = _marketTickerController.offset + 1.6;
      if (nextOffset >= position.maxScrollExtent - 1) {
        _marketTickerController.jumpTo(0);
      } else {
        _marketTickerController.jumpTo(nextOffset);
      }
    });
  }

  String _localizedCommodityName(
    Map<String, dynamic> record,
    AppLocalizations l10n,
  ) {
    final rawCommodity = record['commodity']?.toString() ??
        record['commodity_name']?.toString() ??
        '';
    final normalized = rawCommodity.toLowerCase().trim();

    const commodityKeyMap = {
      'wheat': 'cropWheat',
      'chickpea': 'cropChickpea',
      'gram': 'cropChickpea',
      'maize': 'cropMaize',
      'tomato': 'cropTomato',
      'banana': 'cropBanana',
      'sugarcane': 'cropSugarcane',
      'cotton': 'cropCotton',
      'papaya': 'cropPapaya',
      'watermelon': 'cropWatermelon',
      'paddy': 'cropPaddy',
      'rice': 'cropPaddy',
      'soybean': 'cropSoybean',
      'soyabean': 'cropSoybean',
      'chili': 'cropChili',
      'chilli': 'cropChili',
      'green chilli': 'categoryGreenChilli',
      'eggplant': 'cropEggplant',
      'brinjal': 'cropEggplant',
      'onion': 'categoryOnion',
    };

    for (final entry in commodityKeyMap.entries) {
      if (normalized.contains(entry.key)) {
        return l10n.t(entry.value);
      }
    }

    return rawCommodity.isNotEmpty
        ? rawCommodity
        : l10n.t('marketCommodityFallback');
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
    _marketTickerTimer?.cancel();
    _adPageController.dispose();
    _marketTickerController.dispose();
    _marketCropController.dispose();
    _marketSearchController.dispose();
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
          _buildMarketSection(l10n),
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
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final itemWidth = (constraints.maxWidth - 12) / 2;
                      return Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          SizedBox(
                            width: itemWidth,
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
                          SizedBox(
                            width: itemWidth,
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
                          SizedBox(
                            width: itemWidth,
                            child: _buildToolItem(
                              context,
                              image: 'assets/images/droan.jpg',
                              label: l10n.t('droneService'),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const DroneServiceScreen(),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: itemWidth,
                            child: _buildToolItem(
                              context,
                              image: 'assets/tractor.jpg',
                              label: l10n.t('machineryService'),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const MachineryServiceScreen(),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: itemWidth,
                            child: _buildToolItem(
                              context,
                              image: 'assets/services/soil.jpeg',
                              label: l10n.t('soilTesting'),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SoilTestingScreen(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
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
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromARGB(255, 240, 255, 242),
              Colors.green.shade50,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.green.shade200.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    'https://openweathermap.org/img/w/${weatherInfo!['weather'][0]['icon']}.png',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${weatherInfo!['name']}, ${weatherInfo!['sys']['country']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${weatherInfo!['main']['temp'].toStringAsFixed(0)}°C · ${weatherInfo!['weather'][0]['description']}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${weatherInfo!['main']['temp_min'].toStringAsFixed(0)}°C / ${weatherInfo!['main']['temp_max'].toStringAsFixed(0)}°C',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  _isWeatherExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.green.shade800,
                ),
              ],
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  children: [
                    _weatherRow(
                      l10n.t('humidity'),
                      '${weatherInfo!['main']['humidity']}%',
                    ),
                    _weatherRow(
                      l10n.t('wind'),
                      '${weatherInfo!['wind']['speed']} m/s',
                    ),
                    _weatherRow(
                      l10n.t('visibility'),
                      '${(weatherInfo!['visibility'] / 1000).toStringAsFixed(1)} km',
                    ),
                    _weatherRow(
                      l10n.t('pressure'),
                      '${weatherInfo!['main']['pressure']} hPa',
                    ),
                  ],
                ),
              ),
              crossFadeState: _isWeatherExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
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

  Widget _buildLanguageSettingsCard(AppLocalizations l10n) {
    final localeController = AppLocaleScope.of(context);
    final currentLang = localeController.locale?.languageCode ?? 'en';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.language, color: Colors.green[800]),
        title: Text(
          l10n.t('language'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(l10n.languageName(currentLang)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const LanguageSettingsPage(),
            ),
          );
        },
      ),
    );
  }
}
