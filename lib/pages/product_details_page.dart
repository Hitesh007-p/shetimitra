import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:shetimitra/data/products.dart';
import 'package:shetimitra/l10n/app_localizations.dart';
import 'package:shetimitra/models/product.dart';
import 'package:shetimitra/providers/cart_provider.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  bool showMore = false;
  int quantity = 1;

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
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outline),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.t('quantityLabel'),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: quantity > 1
                          ? () {
                              setState(() => quantity--);
                            }
                          : null,
                      icon: const Icon(IconlyLight.arrowLeft2),
                      iconSize: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '$quantity',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    IconButton(
                      onPressed: quantity < 100
                          ? () {
                              setState(() => quantity++);
                            }
                          : null,
                      icon: const Icon(IconlyLight.arrowRight2),
                      iconSize: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => _addToCart(context, l10n),
              icon: const Icon(IconlyLight.bag2),
              label: Text(l10n.t('addToCart')),
            ),
          ),
        ],
      ),
    );
  }

  void _addToCart(BuildContext context, AppLocalizations l10n) {
    try {
      context.read<CartProvider>().addToCart(widget.product, quantity);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.t('addedToCart')),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: l10n.t('view'),
            textColor: Theme.of(context).colorScheme.primary,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      );

      setState(() => quantity = 1);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.t('error')}: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}
