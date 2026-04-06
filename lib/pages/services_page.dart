import 'package:flutter/material.dart';

class ShetidukanStorePage extends StatelessWidget {
  const ShetidukanStorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF9F5FF),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWeatherCard(),
            const SizedBox(height: 16),
            _buildWelcomeBanner(),
            const SizedBox(height: 20),
            _buildCategoryGrid(context),
            const SizedBox(height: 24),
            _buildPesticideAdvisor(),
            const SizedBox(height: 24),
            _buildRecommendedProducts(),
          ],
        ),
      ),
    );
  }

  // --- 2. Weather Card ---
  Widget _buildWeatherCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.cloud_queue, color: Colors.orange, size: 30),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Kanija Bhavan, IN",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text("32°C · few clouds",
                  style: TextStyle(color: Colors.black54)),
            ],
          ),
          const Spacer(),
          const Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }

  // --- 3. Welcome Banner with Search ---
  Widget _buildWelcomeBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF134C35), Color(0xFF1B3022)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("शेतदुकानमध्ये स्वागत आहे",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "बियाणे, कीटकनाशके शोधा...",
                prefixIcon: const Icon(Icons.search, color: Colors.black54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 4. Category Grid (Seeds, Nursery, etc.) ---
  Widget _buildCategoryGrid(BuildContext context) {
    final List<Map<String, dynamic>> cats = [
      {'title': 'बियाणे', 'icon': Icons.spa_rounded},
      {'title': 'नर्सरी', 'icon': Icons.grass_rounded},
      {'title': 'खते', 'icon': Icons.inventory_2_rounded},
      {'title': 'कीटकनाशके', 'icon': Icons.bug_report_rounded},
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: cats
          .map(
            (cat) => Container(
              width: (MediaQuery.of(context).size.width - 72) / 4,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4),
                ],
              ),
              child: Column(
                children: [
                  Icon(cat['icon'], color: Colors.green, size: 30),
                  const SizedBox(height: 8),
                  Text(cat['title'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.black),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  // --- 5. Pesticide Advisor Card ---
  Widget _buildPesticideAdvisor() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("रोगावर आधारित कीटकनाशक सल्ला",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildDropdown("पीक", ["कापूस", "सोयाबीन"])),
              const SizedBox(width: 10),
              Expanded(child: _buildDropdown("रोग", ["पांढरी माशी", "अळी"])),
            ],
          ),
          const SizedBox(height: 16),
          _buildPesticideProductCard(),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) {},
        ),
      ],
    );
  }

  // --- 6. Inner Detailed Product Card ---
  Widget _buildPesticideProductCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.agriculture,
                    size: 32, color: Colors.green),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("प्रतिशोध कीटकनाशक",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 4),
                  Text("₹450 (500ml)", style: TextStyle(color: Colors.black)),
                ],
              ),
              const Spacer(),
              _buildSimpleOutlineButton("माहिती आणि डोस"),
            ],
          ),
          const SizedBox(height: 12),
          _infoText("कसा वापरावा?",
              "समराम कीटकनाशक माहिती आमचाना, रिसत कीटकनाशक कम करते."),
          _infoText("किती वापरावा?", "कापूस - 500ml होमाद: 120 सद"),
          _infoText("कधी वापरावा?", "कधी वापरावा? बातेरांग माहिती गह हे."),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                    "गाडीत जोडा", Colors.green.shade100, Colors.green),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildActionButton(
                    "आता खरेदी करा", Colors.green, Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }

  // --- Utility Widgets ---
  Widget _infoText(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 4),
          Text(desc,
              style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, Color bg, Color text) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () {},
      child: Text(label,
          style: TextStyle(color: text, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildSimpleOutlineButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(8),
      ),
      child:
          Text(text, style: const TextStyle(color: Colors.green, fontSize: 12)),
    );
  }

  Widget _buildRecommendedProducts() {
    return const Text("शिफारस केलेले उत्पादने",
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green));
  }
}

class ServicesPage extends ShetidukanStorePage {
  const ServicesPage({super.key});
}
