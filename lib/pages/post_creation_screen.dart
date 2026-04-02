import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shetimitra/l10n/app_localizations.dart';

class PostCreationScreen extends StatefulWidget {
  const PostCreationScreen({super.key});

  @override
  State<PostCreationScreen> createState() => _PostCreationScreenState();
}

class _PostCreationScreenState extends State<PostCreationScreen> {
  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  String? _problemDescription;
  int currentBannerIndex = 0;

  final List<Map<String, String>> _bannerData = const [
    {'image': 'assets/bannar.png', 'title': 'cropProtectionTips'},
    {'image': 'assets/bannar.png', 'title': 'weatherAlerts'},
    {'image': 'assets/bannar.png', 'title': 'expertSupport'},
  ];

  Future<void> _pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = image;
    });
  }

  void _submitPost() {
    final l10n = AppLocalizations.of(context);

    if (_selectedImage != null && (_problemDescription?.trim().isNotEmpty ?? false)) {
      Navigator.pop(context, {
        'image': _selectedImage!.path,
        'description': _problemDescription,
        'farmerName': l10n.t('profileName'),
        'location': l10n.t('postLocation'),
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.t('fillPhotoAndProblem'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.t('newPostTitle')),
        backgroundColor: Colors.green.shade800,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 180,
              margin: const EdgeInsets.all(16),
              child: PageView.builder(
                itemCount: _bannerData.length,
                onPageChanged: (index) {
                  setState(() {
                    currentBannerIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          _bannerData[index]['image']!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: const LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.black54, Colors.transparent],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: Text(
                          l10n.t(_bannerData[index]['title']!),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _bannerData.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: currentBannerIndex == index ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentBannerIndex == index ? Colors.green.shade700 : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.t('problemHelpTitle'),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade900,
                        ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: _pickImage,
                    child: _selectedImage == null
                        ? Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green.shade200, width: 2),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt_rounded, size: 50, color: Colors.green.shade600),
                                const SizedBox(height: 10),
                                Text(
                                  l10n.t('uploadPhoto'),
                                  style: TextStyle(color: Colors.green.shade600),
                                ),
                              ],
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(_selectedImage!.path),
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    l10n.t('problemDescription'),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.green.shade800),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: l10n.t('problemHint'),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.green.shade50,
                    ),
                    onChanged: (value) => _problemDescription = value,
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitPost,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        l10n.t('submitPost'),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
