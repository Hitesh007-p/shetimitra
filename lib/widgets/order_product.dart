import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shetimitra/l10n/app_localizations.dart';
import 'package:shetimitra/models/order.dart';
import 'package:shetimitra/models/product.dart';
import 'package:shetimitra/pages/order_details_page.dart';

class OrderProduct extends StatelessWidget {
  const OrderProduct({
    super.key,
    required this.order,
    required this.product,
  });

  final Order order;
  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final qty = Random().nextInt(4) + 1;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => OrderDetailsPage(order: order)),
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 90,
            width: 90,
            margin: const EdgeInsets.only(right: 10, bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(product.image),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.productName(product.name),
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  l10n.productDescription(product.description),
                  style: Theme.of(context).textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.price(product.price),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(l10n.format('quantity', {'count': '$qty'})),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
