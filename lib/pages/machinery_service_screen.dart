import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shetimitra/l10n/app_localizations.dart';

class MachineryServiceScreen extends StatefulWidget {
  const MachineryServiceScreen({super.key});

  @override
  State<MachineryServiceScreen> createState() => _MachineryServiceScreenState();
}

class _MachineryServiceScreenState extends State<MachineryServiceScreen> {
  late PageController _adPageController;
  int _currentAdPage = 0;
  Timer? _carouselTimer;

  final List<Map<String, String>> ads = [
    {'image': 'assets/images/fertilizer.jpg', 'title': 'bestFertilizers'},
    {'image': 'assets/images/droan.jpg', 'title': 'machineryServices'},
    {'image': 'assets/images/irrigation_ad.jpg', 'title': 'irrigationSystems'},
  ];

  // Form fields
  String? selectedServiceKey;
  final TextEditingController areaController = TextEditingController();
  String? selectedCropKey;
  final TextEditingController locationController = TextEditingController();
  DateTime? selectedDate;
  String? selectedTimeSlotKey;
  String? selectedPaymentMethodKey;
  String? selectedPostPaymentOptionKey;

  final List<String> serviceKeys = [
    'serviceTractorRental',
    'serviceHarvester',
    'serviceSeeder',
    'servicePlow',
  ];
  final List<String> cropKeys = [
    'cropCotton',
    'cropWheat',
    'cropPaddy',
    'cropMaize',
    'cropSugarcane',
  ];
  final List<String> timeSlotKeys = [
    'timeSlotEarlyMorning',
    'timeSlotEvening',
  ];
  final List<String> paymentMethodKeys = [
    'advancePayment',
    'payAfterService',
  ];
  final List<String> postPaymentOptions = [
    'cashOnDelivery',
    'digitalAfterWork',
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

      _adPageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );

      setState(() {
        _currentAdPage = nextPage;
      });
    });
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _adPageController.dispose();
    areaController.dispose();
    locationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      // For simplicity, just set a placeholder. In real app, reverse geocode to get village name.
      setState(() {
        locationController.text =
            'Lat: ${position.latitude}, Lng: ${position.longitude}';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get location: $e')),
      );
    }
  }

  void _confirmBooking() {
    if (selectedServiceKey == null ||
        areaController.text.isEmpty ||
        selectedCropKey == null ||
        locationController.text.isEmpty ||
        selectedDate == null ||
        selectedTimeSlotKey == null ||
        selectedPaymentMethodKey == null ||
        (selectedPaymentMethodKey == 'payAfterService' &&
            selectedPostPaymentOptionKey == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(AppLocalizations.of(context).t('pleaseFillAllFields'))),
      );
      return;
    }

    final l10n = AppLocalizations.of(context);
    final serviceLabel = l10n.t(selectedServiceKey!);
    final cropLabel = l10n.cropName(selectedCropKey!);
    final dateLabel = selectedDate!.toLocal().toString().split(' ')[0];
    final timeLabel = l10n.t(selectedTimeSlotKey!);
    final paymentLabel = l10n.t(selectedPaymentMethodKey!);
    final postPaymentLabel = selectedPostPaymentOptionKey != null
        ? l10n.t(selectedPostPaymentOptionKey!)
        : '';

    String summary = '''
${l10n.t('serviceChoice')}: $serviceLabel
${l10n.t('areaAcres')}: ${areaController.text}
${l10n.t('cropType')}: $cropLabel
${l10n.t('locationVillage')}: ${locationController.text}
${l10n.t('selectDate')}: $dateLabel
${l10n.t('timeSlot')}: $timeLabel
${l10n.t('paymentMethod')}: $paymentLabel
${selectedPaymentMethodKey == 'payAfterService' ? '${l10n.t('postPaymentOption')}: $postPaymentLabel' : ''}
''';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.t('bookingConfirmation')),
        content: Text(summary),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.t('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.t('bookingConfirmed'))),
              );
              // Here you can add logic to save the booking or navigate back
            },
            child: Text(l10n.t('confirmBooking')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.t('machineryServiceBooking')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Ad Carousel
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _adPageController,
                  itemCount: ads.length,
                  onPageChanged: (page) {
                    if (mounted) {
                      setState(() => _currentAdPage = page);
                    }
                  },
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: AssetImage(ads[index]['image']!),
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
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        alignment: Alignment.bottomLeft,
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          l10n.t(ads[index]['title']!),
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
          const SizedBox(height: 20),
          // Service Choice
          Text(
            l10n.t('step1ServiceChoice'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          DropdownButtonFormField<String>(
            value: selectedServiceKey,
            decoration: InputDecoration(labelText: l10n.t('typeOfMachinery')),
            items: serviceKeys.map((serviceKey) {
              return DropdownMenuItem(
                value: serviceKey,
                child: Text(l10n.t(serviceKey)),
              );
            }).toList(),
            onChanged: (value) => setState(() => selectedServiceKey = value),
          ),
          const SizedBox(height: 20),
          // Farm Details
          Text(
            l10n.t('step2FarmDetails'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextFormField(
            controller: areaController,
            decoration: InputDecoration(labelText: l10n.t('areaAcres')),
            keyboardType: TextInputType.number,
          ),
          DropdownButtonFormField<String>(
            value: selectedCropKey,
            decoration: InputDecoration(labelText: l10n.t('cropType')),
            items: cropKeys.map((cropKey) {
              return DropdownMenuItem(
                value: cropKey,
                child: Text(l10n.cropName(cropKey)),
              );
            }).toList(),
            onChanged: (value) => setState(() => selectedCropKey = value),
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: locationController,
                  decoration:
                      InputDecoration(labelText: l10n.t('locationVillage')),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.location_on),
                onPressed: _getCurrentLocation,
                tooltip: l10n.t('getCurrentLocation'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Scheduling
          Text(
            l10n.t('step3Scheduling'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ListTile(
            title: Text(selectedDate == null
                ? l10n.t('selectDate')
                : '${l10n.t('selectDate')}: ${selectedDate!.toLocal().toString().split(' ')[0]}'),
            trailing: const Icon(Icons.calendar_today),
            onTap: () => _selectDate(context),
          ),
          Column(
            children: timeSlotKeys.map((slotKey) {
              return RadioListTile<String>(
                title: Text(l10n.t(slotKey)),
                value: slotKey,
                groupValue: selectedTimeSlotKey,
                onChanged: (value) =>
                    setState(() => selectedTimeSlotKey = value),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          // Payment Method
          Text(
            l10n.t('step4PaymentMethod'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Column(
            children: paymentMethodKeys.map((methodKey) {
              return RadioListTile<String>(
                title: Text(l10n.t(methodKey)),
                value: methodKey,
                groupValue: selectedPaymentMethodKey,
                onChanged: (value) => setState(() {
                  selectedPaymentMethodKey = value;
                  if (value != 'payAfterService') {
                    selectedPostPaymentOptionKey = null;
                  }
                }),
              );
            }).toList(),
          ),
          if (selectedPaymentMethodKey == 'payAfterService')
            Column(
              children: postPaymentOptions.map((optionKey) {
                return RadioListTile<String>(
                  title: Text(l10n.t(optionKey)),
                  value: optionKey,
                  groupValue: selectedPostPaymentOptionKey,
                  onChanged: (value) =>
                      setState(() => selectedPostPaymentOptionKey = value),
                );
              }).toList(),
            ),
          const SizedBox(height: 20),
          // Confirm Button
          ElevatedButton(
            onPressed: _confirmBooking,
            child: Text(l10n.t('confirmBooking')),
          ),
        ],
      ),
    );
  }
}
