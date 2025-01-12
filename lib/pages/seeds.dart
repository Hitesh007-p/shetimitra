import 'package:flutter/material.dart';

class SeedsScreen extends StatefulWidget {
  @override
  _SeedsScreenState createState() => _SeedsScreenState();
}

class _SeedsScreenState extends State<SeedsScreen> {
  final List<Map<String, String>> categories = [
    {"name": "डेमसे", "image": "assets/tomato.jpg"},
    {"name": "हरभरा", "image": "assets/tomato.jpg"},
    {"name": "कांदा", "image": "assets/tomato.jpg"},
    {"name": "गहू", "image": "assets/tomato.jpg"},
    {"name": "मका", "image": "assets/tomato.jpg"},
    {"name": "तिखट मिरची", "image": "assets/tomato.jpg"},
    {"name": "डेमसे", "image": "assets/tomato.jpg"},
    {"name": "हरभरा", "image": "assets/tomato.jpg"},
    {"name": "कांदा", "image": "assets/tomato.jpg"},
    {"name": "गहू", "image": "assets/tomato.jpg"},
    {"name": "मका", "image": "assets/tomato.jpg"},
    {"name": "तिखट मिरची", "image": "assets/tomato.jpg"},
    {"name": "डेमसे", "image": "assets/tomato.jpg"},
    {"name": "हरभरा", "image": "assets/tomato.jpg"},
    {"name": "कांदा", "image": "assets/tomato.jpg"},
    {"name": "गहू", "image": "assets/tomato.jpg"},
    {"name": "मका", "image": "assets/tomato.jpg"},
    {"name": "तिखट मिरची", "image": "assets/tomato.jpg"},
    {"name": "डेमसे", "image": "assets/tomato.jpg"},
    {"name": "हरभरा", "image": "assets/tomato.jpg"},
    {"name": "कांदा", "image": "assets/tomato.jpg"},
    {"name": "गहू", "image": "assets/tomato.jpg"},
    {"name": "मका", "image": "assets/tomato.jpg"},
    {"name": "तिखट मिरची", "image": "assets/tomato.jpg"},
  ];

  final List<Map<String, dynamic>> products = [
    {
      "name": "एमएमसी-युपीएल जीएस-10 बियाणे (1 किलो)",
      "price": "₹315",
      "mrp": "₹520",
      "discount": "39% सूट",
      "rating": "4.3",
      "image": "assets/tomato.jpg",
    },
    {
      "name": "अॅग्रोस्टार बोनस खरबूज (50 ग्रॅम)",
      "price": "₹900",
      "mrp": "₹1,750",
      "discount": "49% सूट",
      "rating": "4.6",
      "image": "assets/tomato.jpg",
    },
    {
      "name": "एमएमसी-युपीएल जीएस-10 बियाणे (1 किलो)",
      "price": "₹315",
      "mrp": "₹520",
      "discount": "39% सूट",
      "rating": "4.3",
      "image": "assets/tomato.jpg",
    },
    {
      "name": "अॅग्रोस्टार बोनस खरबूज (50 ग्रॅम)",
      "price": "₹900",
      "mrp": "₹1,750",
      "discount": "49% सूट",
      "rating": "4.6",
      "image": "assets/tomato.jpg",
    },
    {
      "name": "एमएमसी-युपीएल जीएस-10 बियाणे (1 किलो)",
      "price": "₹315",
      "mrp": "₹520",
      "discount": "39% सूट",
      "rating": "4.3",
      "image": "assets/tomato.jpg",
    },
    {
      "name": "अॅग्रोस्टार बोनस खरबूज (50 ग्रॅम)",
      "price": "₹900",
      "mrp": "₹1,750",
      "discount": "49% सूट",
      "rating": "4.6",
      "image": "assets/tomato.jpg",
    },
  ];
  int currentPageIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton.filledTonal(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(Icons.menu),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "नमस्कार हितेश 👋🏾",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text("आमच्या सेवांचा आनंद घ्या",
                style: Theme.of(context).textTheme.bodySmall)
          ],
        ),
      ),
      drawer: const Drawer(),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "आपल्या लागवडी साठी आजच खरेदी करा.. ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _buildCategoryList(),
                const SizedBox(height: 20),
                const Text(
                  "सर्व उत्पादने",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _buildProductGrid(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(category["image"]!),
                ),
                const SizedBox(height: 5),
                Text(category["name"]!, style: const TextStyle(fontSize: 12)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProductGrid() {
    return Expanded(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.75,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return _buildProductCard(product);
        },
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
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
              product["image"],
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRatingWidget(product["rating"]),
                const SizedBox(height: 5),
                Text(
                  product["name"],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      "${product["price"]}",
                      style: const TextStyle(fontSize: 14),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "${product["mrp"]}",
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough),
                    ),
                  ],
                ),
                Text(
                  product["discount"],
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 10),
                _buildAddToCartButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingWidget(String rating) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            rating,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 5),
        const Text("★"),
      ],
    );
  }

  Widget _buildAddToCartButton() {
    return ElevatedButton(
      onPressed: () {
        // Add product to cart logic
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
      ),
      child: const Text(
        "खरेदी करा",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
