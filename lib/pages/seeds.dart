import 'package:flutter/material.dart';
import 'package:shetimitra/l10n/app_localizations.dart';

class SeedsScreen extends StatefulWidget {
  const SeedsScreen({super.key});

  @override
  State<SeedsScreen> createState() => _SeedsScreenState();
}

class _SeedsScreenState extends State<SeedsScreen> {
  final List<Map<String, String>> categories = [
    {'name': 'cropTomato', 'image': 'assets/tomato.jpg'},
    {'name': 'cropChickpea', 'image': 'assets/tomato.jpg'},
    {'name': 'categoryOnion', 'image': 'assets/tomato.jpg'},
    {'name': 'cropWheat', 'image': 'assets/tomato.jpg'},
    {'name': 'cropMaize', 'image': 'assets/tomato.jpg'},
    {'name': 'categoryGreenChilli', 'image': 'assets/tomato.jpg'},
  ];

  final List<Map<String, String>> products = [
    {
      'name': 'seedProductOne',
      'price': '?315',
      'mrp': '?520',
      'discount': '39%',
      'rating': '4.3',
      'image': 'assets/tomato.jpg',
    },
    {
      'name': 'seedProductTwo',
      'price': '?900',
      'mrp': '?1,750',
      'discount': '49%',
      'rating': '4.6',
      'image': 'assets/tomato.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.serviceName('serviceSeeds')),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              l10n.t('shopForFarmTitle'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(category['image']!),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        l10n.t(category['name']!),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              l10n.t('allProducts'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.70,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                        child: Image.asset(
                          product['image']!,
                          height: 130,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    product['rating']!,
                                    style: const TextStyle(fontSize: 12, color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                const Text('?'),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              l10n.t(product['name']!),
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Text(product['price']!),
                                const SizedBox(width: 10),
                                Text(
                                  product['mrp']!,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${product['discount']} ${l10n.t('discountSuffix')}',
                              style: const TextStyle(fontSize: 12, color: Colors.red),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              child: Text(
                                l10n.t('buyNow'),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
