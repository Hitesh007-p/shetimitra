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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "तुम्हाला काही समस्या असतिल तर तुमच्या पिकाचा फोटो ईथे टाका.",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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
                        color: Colors.grey.shade200,
                        border:
                            Border.all(color: Colors.grey.shade400, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                          SizedBox(height: 5),
                          Text(
                            "फोटो टाका",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(_selectedImage!.path),
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'तुमची समस्या लिहा',
                  labelStyle: TextStyle(color: Colors.grey.shade700),
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green.shade600),
                  ),
                ),
                onChanged: (value) {
                  _problemDescription = value;
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submitPost,
                icon: const Icon(Icons.send),
                label: const Text('पोस्ट करा'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.green.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
