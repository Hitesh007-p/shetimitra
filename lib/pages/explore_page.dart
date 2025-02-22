// ignore_for_file: unused_import, unused_field, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shetimitra/pages/post_creation_screen.dart';
import 'package:shetimitra/pages/postercard.dart';
import 'dart:io';
import 'package:shetimitra/services/weather_service.dart';
import 'package:shetimitra/services/webview.dart';
import 'package:shetimitra/widgets/insuranceoption.dart';

import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with AutomaticKeepAliveClientMixin {
  late Future<Map<String, dynamic>> _weatherData;
  final WeatherService _weatherService = WeatherService();
  bool _isLoading = true;
  Map<String, dynamic>? weatherInfo;
  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  String? _problemDescription;
  List<Map<String, dynamic>> _posts = [];
  bool _isWeatherExpanded = false;

  String? _selectedCrop;
  final List<String> _crops = [
    'गहू',
    'हरभरा',
    'मक्का',
    'टोमॅटो',
    'केळी',
    'ऊस',
    'कापूस',
    'पपई',
    'टरबूज',
    'डांगर',
    'सोयाबीन',
    'मिरची',
    'वांगे',
  ];

  final Map<String, String> _cropImages = {
    'गहू': 'assets/crops/wheat.png',
    'हरभरा': 'assets/crops/kabuli.png',
    'मक्का': 'assets/crops/makka.png',
    'टोमॅटो': 'assets/tomato.jpg',
    'केळी': 'assets/crops/banana.png',
    'ऊस': 'assets/crops/shugarcane.png',
    'कापूस': 'assets/crops/Cotton.jpg',
    'पपई': 'assets/crops/papaya.jpg',
    'टरबूज': 'assets/crops/whatermelon.png',
    'डांगर': 'assets/crops/whatermelon.png',
    'सोयाबीन': 'assets/crops/soyabean.png',
    'मिरची': 'assets/crops/green_chilly.png',
    'वांगे': 'assets/crops/vange.png',
  };

  late PageController _adPageController;
  int _currentAdPage = 0;
  Timer? _carouselTimer;
  final List<Map<String, String>> _ads = [
    {
      'image': 'assets/images/fertilizer.jpg',
      'title': 'सर्वोत्तम खते',
      'subtitle': 'सवलतीच्या किमतीत!'
    },
    {
      'image': 'assets/images/droan.jpg',
      'title': 'द्रोण भाडे',
      'subtitle': 'प्रती एकर ६०० रुपये'
    },
    {
      'image': 'assets/images/irrigation_ad.jpg',
      'title': 'सिंचन प्रणाली',
      'subtitle': '३०% सूटसह'
    },
  ];

  bool _isWeatherLoaded = false;

  @override
  void initState() {
    super.initState();
    _adPageController = PageController();
    if (!_isWeatherLoaded) {
      _fetchWeather();
    }
    _startAdCarousel();
  }

  void _fetchWeather() async {
    try {
      Position position = await _getCurrentLocation();
      var weatherData = await _weatherService.getWeather(
          position.latitude, position.longitude);
      if (mounted) {
        setState(() {
          weatherInfo = weatherData;
          _isLoading = false;
          _isWeatherLoaded = true;
        });
      }
    } catch (e) {
      print('Error fetching weather: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _launchWebView(BuildContext context, String url, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewScreen(
          url: url,
          title: title,
        ),
      ),
    );
  }

  void _startAdCarousel() {
    _carouselTimer?.cancel();
    _carouselTimer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (!mounted) return;

      final newPage = _currentAdPage < _ads.length - 1 ? _currentAdPage + 1 : 0;

      if (_adPageController.hasClients) {
        _adPageController
            .animateToPage(
          newPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        )
            .then((_) {
          if (mounted) setState(() => _currentAdPage = newPage);
        });
      }
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
        padding: const EdgeInsets.all(16.0),
        children: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (weatherInfo != null)
            _buildWeatherWidget(),
          const SizedBox(height: 10),
          Card(
            elevation: 5,
            color: const Color.fromARGB(255, 252, 252, 252),
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DropdownButton<String>(
                    value: _selectedCrop,
                    hint: Text(
                      'तुमचे पिक निवडा',
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color.fromARGB(255, 81, 170, 86),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.green[800],
                    ),
                    dropdownColor: const Color.fromARGB(255, 254, 254, 254),
                    style: TextStyle(
                      color: Colors.brown[800],
                      fontSize: 14,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCrop = newValue;
                      });
                    },
                    items: _crops.map<DropdownMenuItem<String>>((String crop) {
                      return DropdownMenuItem<String>(
                        value: crop,
                        child: Text(crop),
                      );
                    }).toList(),
                  ),
                  if (_selectedCrop != null) ...[
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'निवडलेले पीक :',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.green[800],
                            ),
                          ),
                          SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _selectedCrop!,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          _cropImages[_selectedCrop!]!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildAdCarousel(),
          const SizedBox(height: 20),
          Card(
            color: Colors.orange.shade50,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "शेती सुविधा",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
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
                          "https://pmfby.gov.in/",
                          "पीक विमा",
                        ),
                        child: const InsuranceOption(
                          icon: Icons.grass,
                          title: "पीक विमा",
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _launchWebView(
                          context,
                          "https://mahadbt.maharashtra.gov.in/Login/Login",
                          "महाDBT",
                        ),
                        child: const InsuranceOption(
                          icon: Icons.edit_document,
                          title: "महाDBT",
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _launchWebView(
                          context,
                          "https://digitalsatbara.mahabhumi.gov.in/dslr",
                          "७/१२ डाउनलोड करा",
                        ),
                        child: const InsuranceOption(
                          icon: Icons.description,
                          title: "७/१२ डाउनलोड करा",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              ..._posts.map((post) => _buildPostCard(post)).toList(),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildAdCarousel() {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PageView.builder(
            controller: _adPageController,
            itemCount: _ads.length,
            onPageChanged: (int page) {
              setState(() {
                _currentAdPage = page;
              });
            },
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        _ads[index]['image']!,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _ads[index]['title']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _ads[index]['subtitle']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_ads.length, (index) {
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        _currentAdPage == index ? Colors.white : Colors.white54,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherWidget() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isWeatherExpanded = !_isWeatherExpanded;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: _isWeatherExpanded ? 400 : 200,
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
              color: Colors.green.shade200.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: _isWeatherExpanded
            ? _buildExpandedWeatherView()
            : _buildCollapsedWeatherView(),
      ),
    );
  }

  Widget _buildCollapsedWeatherView() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                'https://openweathermap.org/img/w/${weatherInfo!['weather'][0]['icon']}.png',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 8),
              Text(
                "${weatherInfo!['main']['temp_min']}°C - ${weatherInfo!['main']['temp_max']}°C",
                style: TextStyle(
                  color: Colors.green.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.green.shade700,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "${weatherInfo!['name']}, ${weatherInfo!['sys']['country']}",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.green.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildWeatherDetailRow(
                icon: Icons.cloud,
                label: 'हवामान',
                value: weatherInfo!['weather'][0]['description'],
                color: Colors.blue.shade700,
              ),
              _buildWeatherDetailRow(
                icon: Icons.thermostat,
                label: 'तापमान',
                value: "${weatherInfo!['main']['temp']}°C",
                color: Colors.orange.shade700,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExpandedWeatherView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${weatherInfo!['name']}, ${weatherInfo!['sys']['country']}",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.green.shade900,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _isWeatherExpanded = false;
                });
              },
            ),
          ],
        ),
        Expanded(
          child: ListView(
            children: [
              _buildWeatherDetailRow(
                icon: Icons.cloud,
                label: 'हवामान',
                value: weatherInfo!['weather'][0]['description'],
                color: Colors.blue.shade700,
              ),
              _buildWeatherDetailRow(
                icon: Icons.thermostat,
                label: 'तापमान',
                value: "${weatherInfo!['main']['temp']}°C",
                color: Colors.orange.shade700,
              ),
              _buildWeatherDetailRow(
                icon: Icons.ac_unit,
                label: 'सारखे वाटते',
                value: "${weatherInfo!['main']['feels_like']}°C",
                color: Colors.teal.shade700,
              ),
              _buildWeatherDetailRow(
                icon: Icons.water_drop,
                label: 'आर्द्रता',
                value: "${weatherInfo!['main']['humidity']}%",
                color: Colors.indigo.shade700,
              ),
              _buildWeatherDetailRow(
                icon: Icons.air,
                label: 'वारा',
                value: "${weatherInfo!['wind']['speed']} m/s",
                color: Colors.grey.shade700,
              ),
              _buildWeatherDetailRow(
                icon: Icons.visibility,
                label: 'दृश्यमानता',
                value: "${weatherInfo!['visibility'] / 1000} km",
                color: Colors.purple.shade700,
              ),
              _buildWeatherDetailRow(
                icon: Icons.compress,
                label: 'दाब',
                value: "${weatherInfo!['main']['pressure']} hPa",
                color: Colors.brown.shade700,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold)),
              Text(value, style: TextStyle(color: color)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      post['location'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
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
                height: 350,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              post['description'],
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.thumb_up_alt_outlined),
                      color: Colors.green.shade600,
                    ),
                    Text(
                      'Like',
                      style: TextStyle(color: Colors.green.shade600),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.comment_outlined),
                      color: Colors.blue.shade600,
                    ),
                    Text(
                      'Comment',
                      style: TextStyle(color: Colors.blue.shade600),
                    ),
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
