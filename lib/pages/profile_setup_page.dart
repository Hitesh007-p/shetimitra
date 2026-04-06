import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shetimitra/l10n/app_localizations.dart';
import 'package:shetimitra/models/user.dart';
import 'package:shetimitra/services/user_service.dart';
import 'package:shetimitra/pages/home_page.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  File? _profileImage;
  final List<String> _crops = [
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
  final List<String> _selectedCrops = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final requestedPermission = await Geolocator.requestPermission();
        if (requestedPermission == LocationPermission.denied ||
            requestedPermission == LocationPermission.deniedForever) {
          return;
        }
      } else if (permission == LocationPermission.deniedForever) {
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final resolvedAddress = await _fetchAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );

      setState(() {
        addressController.text =
            resolvedAddress ?? '${position.latitude}, ${position.longitude}';
      });
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  Future<String?> _fetchAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=$latitude&lon=$longitude',
      );

      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'ShetiMitra/1.0',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body);
      if (data is! Map<String, dynamic>) return null;

      final displayName = data['display_name'];
      if (displayName is String && displayName.trim().isNotEmpty) {
        return displayName;
      }

      final address = data['address'];
      if (address is Map) {
        final addressParts = [
          address['road']?.toString(),
          address['suburb']?.toString(),
          address['village']?.toString(),
          address['town']?.toString(),
          address['city']?.toString(),
          address['state']?.toString(),
          address['postcode']?.toString(),
          address['country']?.toString(),
        ].where((part) => part != null && part.trim().isNotEmpty).toList();

        if (addressParts.isNotEmpty) {
          return addressParts.join(', ');
        }
      }
    } catch (e) {
      debugPrint('Error resolving address: $e');
    }

    return null;
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  Future<void> _takePhoto() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
        });
      }
    } catch (e) {
      debugPrint('Error taking photo: $e');
    }
  }

  Future<void> _saveProfile() async {
    final l10n = AppLocalizations.of(context);

    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.t('fullNameHint'))),
      );
      return;
    }

    if (_selectedCrops.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.t('selectAtLeastOneCrop'))),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Save profile data to local storage
    final user = User(
      name: nameController.text,
      address:
          addressController.text.isNotEmpty ? addressController.text : null,
      profilePhotoPath: _profileImage?.path,
      selectedCrops: _selectedCrops,
      createdAt: DateTime.now(),
    );

    await UserService.saveUser(user);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      Navigator.of(context).pushReplacement(
        CupertinoPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.t('profileSetupTitle')),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Photo Section
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(IconlyLight.camera),
                                  title: Text(l10n.t('takePhoto')),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _takePhoto();
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(IconlyLight.image),
                                  title: Text(l10n.t('pickFromGallery')),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _pickImage();
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : null,
                        child: _profileImage == null
                            ? Icon(
                                IconlyBold.camera,
                                size: 40,
                                color: Theme.of(context).colorScheme.primary,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.t('addProfilePhoto'),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '(${l10n.t('photoOptional')})',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Name Field (Required)
              Text(
                '${l10n.t('fullName')} *',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: l10n.t('fullNameHint'),
                  prefixIcon: const Icon(IconlyLight.profile),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 20),

              // Address Field (Optional)
              Text(
                l10n.t('address'),
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: addressController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: l10n.t('addressHint'),
                  helperText: l10n.t('addressHelper'),
                  prefixIcon: const Icon(IconlyLight.location),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 20),

              // Crops Selection
              Text(
                '${l10n.t('selectCropsTitle')} *',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.t('selectCropsSubtitle'),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade50,
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _crops.map((crop) {
                    final isSelected = _selectedCrops.contains(crop);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        value: isSelected,
                        onChanged: (value) {
                          setState(() {
                            if (value ?? false) {
                              _selectedCrops.add(crop);
                            } else {
                              _selectedCrops.remove(crop);
                            }
                          });
                        },
                        title: Text(l10n.t(crop)),
                        activeColor: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
              if (_selectedCrops.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selectedCrops.map((crop) {
                    return Chip(
                      label: Text(l10n.t(crop)),
                      onDeleted: () {
                        setState(() {
                          _selectedCrops.remove(crop);
                        });
                      },
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 30),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _saveProfile,
                  icon: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(IconlyBold.arrowRight),
                  label: Text(
                    _isLoading
                        ? l10n.t('settingUp')
                        : l10n.t('completeProfile'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
