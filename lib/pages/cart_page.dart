import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:shetimitra/l10n/app_localizations.dart';
import 'package:shetimitra/providers/cart_provider.dart';
import 'package:shetimitra/widgets/cart_item_card.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.t('cart')),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, _) {
          final items = cartProvider.items;

          // Empty state
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    IconlyLight.bag2,
                    size: 64,
                    color:
                        Theme.of(context).colorScheme.outline.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.t('cartEmpty'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.t('addItemsToCart'),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(IconlyLight.arrowLeft2),
                    label: Text(l10n.t('continueShopping')),
                  ),
                ],
              ),
            );
          }

          // Cart with items
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Cart Items List
                ...List.generate(
                  items.length,
                  (index) => CartItemCard(cartItem: items[index]),
                ),
                const SizedBox(height: 20),
                // Order Summary Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      // Items Count
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.t('items'),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            '${items.length}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const Divider(height: 16),
                      // Total Quantity
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.t('quantity'),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            '${cartProvider.totalQuantity}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const Divider(height: 16),
                      // Subtotal
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.t('subtotal'),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            '₹${cartProvider.totalPrice.toStringAsFixed(0)}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Est. Tax (18%)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.t('estimatedTax'),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                          ),
                          Text(
                            '₹${(cartProvider.totalPrice * 0.18).toStringAsFixed(0)}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const Divider(height: 16),
                      // Total
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.t('total'),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            '₹${(cartProvider.totalPrice + (cartProvider.totalPrice * 0.18)).toStringAsFixed(0)}',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Buttons
                Row(
                  children: [
                    // Continue Shopping
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(IconlyLight.arrowLeft2),
                        label: Text(l10n.t('continueShopping')),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Proceed to Checkout
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => _proceedToCheckout(context),
                        icon: const Icon(IconlyBold.arrowRight),
                        label: Text(l10n.t('proceedToCheckout')),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _proceedToCheckout(BuildContext context) {
    // TODO: Navigate to checkout page
    // Navigator.push(
    //   context,
    //   CupertinoPageRoute(builder: (_) => const CheckoutPage()),
    // );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Checkout page coming soon...')),
    );
  }
}
