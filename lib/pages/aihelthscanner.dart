import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:developer';
import 'dart:async';

class PlantDiseaseDetector extends StatefulWidget {
  const PlantDiseaseDetector({super.key});

  @override
  PlantDiseaseDetectorState createState() => PlantDiseaseDetectorState();
}

class PlantDiseaseDetectorState extends State<PlantDiseaseDetector> {
  File? _image;
  String _result = "अजून काही निष्कर्ष नाही.";
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();
  final PageController _pageController = PageController();
  Timer? _carouselTimer;
  int _currentPage = 0;
  final List<Map<String, dynamic>> _carouselItems = [
    {
      'image': 'assets/helthscan.jpg',
      'title': 'पीक तपासणी',
      'subtitle': 'प्रतिमा काढून रोग ओळखा',
    },
    {
      'image': 'assets/treatment.png',
      'title': 'उपचार माहिती',
      'subtitle': 'रोगांवरील उपायांची माहिती',
    },
    {
      'image': 'assets/expert.png',
      'title': 'तज्ञ सल्ला',
      'subtitle': 'योग्य मार्गदर्शन मिळवा',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startCarouselTimer();
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startCarouselTimer() {
    _carouselTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < _carouselItems.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _isLoading = true;
        _result = "विश्लेषण चालू आहे...";
      });
      await _uploadImage(_image!);
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    const String apiKey = "WulQdNqzTs8Rv4dQAPCZ64ij9dkNqaySdhT8pUFiuoV3EEBIrC";
    final uri = Uri.parse("https://api.plant.id/v3/health_assessment");

    var request = http.MultipartRequest("POST", uri)
      ..headers["Api-Key"] = apiKey
      ..fields["health"] = "all"
      ..fields["symptoms"] = "true"
      ..files.add(await http.MultipartFile.fromPath("images", imageFile.path));

    try {
      var response = await request.send();
      log('API Response Status: ${response.statusCode}');

      if (response.statusCode == 201) {
        final responseData = await response.stream.bytesToString();
        final decodedData = json.decode(responseData);
        log('API Response Body: ${jsonEncode(decodedData)}');

        // Extracting Data
        bool isHealthy =
            decodedData["result"]?["is_healthy"]?["binary"] ?? false;
        double healthProbability =
            (decodedData["result"]?["is_healthy"]?["probability"] ?? 0.0) * 100;

        List<dynamic> diseaseList =
            decodedData["result"]?["disease"]?["suggestions"] ?? [];
        List<dynamic> symptomsList =
            decodedData["result"]?["symptom"]?["suggestions"] ?? [];

        // Processing Disease Information
        String diseaseInfo = diseaseList.isNotEmpty
            ? diseaseList.map((disease) {
                String name = disease["name"] ?? "अज्ञात";
                String probability =
                    ((disease["probability"] ?? 0.0) * 100).toStringAsFixed(2);

                // Get control information from local database
                var controlInfo = DiseaseControlHelper.getControlInfo(name);

                return """
🌿 **आजार:** $name
🔹 **संभाव्यता:** $probability%
🛡️ **नियंत्रण पद्धती:** ${controlInfo['control_methods'] ?? 'माहिती उपलब्ध नाही'}
🌾 **उपयुक्त कीटकनाशके:** ${controlInfo['pesticides'] ?? 'माहिती उपलब्ध नाही'}
""";
              }).join("\n\n")
            : "✅ वनस्पती निरोगी आहे.";

        // Processing Symptoms
        String symptomsInfo = symptomsList.isNotEmpty
            ? symptomsList.map((symptom) {
                String name = symptom["name"] ?? "अज्ञात";
                String probability =
                    ((symptom["probability"] ?? 0.0) * 100).toStringAsFixed(2);
                return "⚠️ **लक्षण:** $name ($probability%)";
              }).join("\n\n")
            : "कोणतीही लक्षणे सापडली नाहीत.";

        setState(() {
          _isLoading = false;
          _result = """
🌱 **वनस्पती आरोग्य:** ${isHealthy ? "निरोगी ✅" : "आजारी ❌"}  
💯 **आरोग्य संभावना:** ${healthProbability.toStringAsFixed(2)}%

$diseaseInfo

$symptomsInfo
""";
        });
      } else {
        log('API Error Response: ${await response.stream.bytesToString()}');
        setState(() {
          _isLoading = false;
          _result = "त्रुटी: प्रतिमा विश्लेषण अयशस्वी. पुन्हा प्रयत्न करा.";
        });
      }
    } catch (e) {
      log('API Request Error: $e');
      setState(() {
        _isLoading = false;
        _result = "त्रुटी: $e";
      });
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("प्रतिमा निवडा"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("कॅमेरा"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text("गॅलरी"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "वनस्पती आजार शोधक",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green.shade700,
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Carousel
            Container(
              height: 180,
              margin: const EdgeInsets.symmetric(vertical: 16),
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: _carouselItems.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.shade100,
                              Colors.green.shade50,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                index == 0
                                    ? Icons.camera_alt
                                    : index == 1
                                        ? Icons.healing
                                        : Icons.psychology,
                                size: 35,
                                color: Colors.green.shade700,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _carouselItems[index]['title'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _carouselItems[index]['subtitle'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  // Carousel Indicators
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _carouselItems.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 16 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: _currentPage == index
                                ? Colors.green.shade600
                                : Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Main Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Image Upload Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _image != null
                            ? Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.file(
                                      _image!,
                                      height: 250,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _image = null;
                                          _result = "अजून काही निष्कर्ष नाही.";
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                        child:
                                            const Icon(Icons.close, size: 20),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                    width: 2,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: 50,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      "पीक प्रतिमा निवडा",
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _showImageSourceDialog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade500,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.camera_alt),
                          label: const Text(
                            "प्रतिमा निवडा",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Results Section
                  if (_isLoading)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.green.shade500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "विश्लेषण चालू आहे...",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (_result != "अजून काही निष्कर्ष नाही.")
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: SelectableText(
                        _result,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class DiseaseControlHelper {
  static Map<String, Map<String, String>> diseaseDatabase = {
    "Fungi": {
      "control_methods":
          "• संक्रमित भाग काढून टाका\n• चांगली हवा येण्याजागा ठेवा\n• नियमित फंगिसायड स्प्रे करा",
      "pesticides": "बोर्डो मिश्रण, नीम तेल, कॉपर ऑक्सिक्लोराइड"
    },
    "rust": {
      "control_methods":
          "• संक्रमित पाने काढून टाका\n• ओलावा कमी ठेवा\n• गंधकयुक्त स्प्रे वापरा",
      "pesticides": "मॅन्कोझेब, प्रोपिकोनाझोल, टेबुकोनाझोल"
    },
    "nutrient deficiency": {
      "control_methods":
          "• मातीची चाचणी करा\n• संतुलित खत वापरा\n• जैविक खत वाढवा",
      "pesticides": "NPK खते, मायकोरायझा, समुद्रशेव खत"
    },
    "Bacteria": {
      "control_methods":
          "• संक्रमित झाडे काढून टाका\n• स्टरलाइज्ड साधने वापरा\n• तांब्यायुक्त कीटकनाशके वापरा",
      "pesticides": "कॉपर हायड्रॉक्साइड, बॅक्टीरिसायड, स्ट्रेप्टोमायसिन"
    }
  };

  static Map<String, String> getControlInfo(String diseaseName) {
    return diseaseDatabase[diseaseName] ?? {};
  }
}
