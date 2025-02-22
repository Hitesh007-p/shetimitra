import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PostCreationScreen extends StatefulWidget {
  const PostCreationScreen({super.key});

  @override
  _PostCreationScreenState createState() => _PostCreationScreenState();
}

class _PostCreationScreenState extends State<PostCreationScreen> {
  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  String? _problemDescription;
  int currentBannerIndex = 0;

  final List<Map<String, dynamic>> _bannerData = [
    {
      'image': 'assets/bannar.png',
      'title': 'पिक संरक्षण टिप्स',
      'subtitle': 'सुरक्षित पिकासाठी उपयुक्त सल्ले'
    },
    {
      'image': 'assets/bannar.png',
      'title': 'हवामान अलर्ट',
      'subtitle': 'ताज्या हवामान अंदाजानुसार शेतीचे नियोजन करा'
    },
    {
      'image': 'assets/bannar.png',
      'title': 'तज्ञ सल्ला',
      'subtitle': '24x7 तज्ञ सल्ल्यासाठी संपर्क करा'
    },
  ];

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = image;
    });
  }

  void _submitPost() {
    if (_selectedImage != null && _problemDescription != null) {
      Navigator.pop(context, {
        'image': _selectedImage!.path,
        'description': _problemDescription,
        'farmerName': 'हितेश पाटील',
        'location': 'दोंडाईचा महाराष्ट्र'
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('कृपया फोटो आणि समस्या भरा!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('नवीन पोस्ट तयार करा'),
        backgroundColor: Colors.green.shade800,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner Section
            Container(
              height: 180,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(158, 158, 158, 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
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
                          _bannerData[index]['image'],
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Color.fromRGBO(0, 0, 0, 0.5),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _bannerData[index]['title'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _bannerData[index]['subtitle'],
                              style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 0.8),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            // Banner Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _bannerData.length,
                (index) => _buildBannerIndicator(index),
              ),
            ),
            const SizedBox(height: 20),
            // Post Creation Form
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "तुमच्या पिकाची समस्या सोडवण्यासाठी",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 18,
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
                              border: Border.all(
                                color: Colors.green.shade200,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt_rounded,
                                  size: 50,
                                  color: Colors.green.shade600,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "फोटो अपलोड करा",
                                  style: TextStyle(
                                    color: Colors.green.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
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
                    "समस्या वर्णन",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(189, 189, 189, 0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'तुमची समस्या तपशीलवार लिहा...',
                        hintStyle: TextStyle(
                          color: Color.fromRGBO(158, 158, 158, 0.5),
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.green.shade50,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      style: TextStyle(
                        color: Color.fromRGBO(158, 158, 158, 0.5),
                        fontSize: 14,
                      ),
                      onChanged: (value) => _problemDescription = value,
                    ),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitPost,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      child: const Text(
                        'पोस्ट सबमिट करा',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerIndicator(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: currentBannerIndex == index ? 20 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: currentBannerIndex == index
            ? Colors.green.shade700
            : Color.fromRGBO(158, 158, 158, 0.5),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
