import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:shetimitra/data/products.dart';
import 'package:shetimitra/l10n/app_localizations.dart';
import 'package:shetimitra/models/product.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  bool showMore = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final description = l10n.productDescription(widget.product.description);
    final shortDescription = description.length > 120
        ? '${description.substring(0, 120)}...'
        : description;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.t('details')),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(IconlyLight.bookmark),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 250,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.product.image),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Text(
            l10n.productName(widget.product.name),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.t('availableInStock'),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(
                      text: l10n.price(widget.product.price),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextSpan(
                      text: '/${l10n.unitName(widget.product.unit)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.star, size: 16, color: Colors.yellow.shade800),
              Text('${widget.product.rating} (192)'),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            l10n.t('description'),
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 5),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: [
                TextSpan(text: showMore ? description : shortDescription),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        showMore = !showMore;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Text(
                        showMore ? l10n.t('readLess') : l10n.t('readMore'),
                        style: TextStyle(color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.t('similarProducts'),
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  height: 90,
                  width: 80,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(products[index].image),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemCount: products.length,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(IconlyLight.bag2),
            label: Text(l10n.t('addToCart')),
          ),
        ],
      ),
    );
  }
}
