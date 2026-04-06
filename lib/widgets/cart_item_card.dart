import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:shetimitra/l10n/app_localizations.dart';
import 'package:shetimitra/models/cart_item.dart';
import 'package:shetimitra/providers/cart_provider.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({required this.cartItem, super.key});

  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cartProvider = context.read<CartProvider>();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage(cartItem.product.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                Text(
                  cartItem.product.name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Price per unit
                Text(
                  '₹${cartItem.product.price.toStringAsFixed(0)}/${cartItem.product.unit}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 8),
                // Quantity Controls & Total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Quantity Stepper
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          // Decrease
                          SizedBox(
                            width: 32,
                            height: 32,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: cartItem.quantity > 1
                                  ? () {
                                      cartProvider.updateQuantity(
                                        cartItem.product,
                                        cartItem.quantity - 1,
                                      );
                                    }
                                  : null,
                              icon: const Icon(Icons.remove),
                              iconSize: 16,
                            ),
                          ),
                          // Quantity Display
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              '${cartItem.quantity}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          // Increase
                          SizedBox(
                            width: 32,
                            height: 32,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: cartItem.quantity < 100
                                  ? () {
                                      cartProvider.updateQuantity(
                                        cartItem.product,
                                        cartItem.quantity + 1,
                                      );
                                    }
                                  : null,
                              icon: const Icon(Icons.add),
                              iconSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Total Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          l10n.t('total'),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                        Text(
                          '₹${cartItem.totalPrice.toStringAsFixed(0)}',
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
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Delete Button
          SizedBox(
            width: 40,
            child: IconButton(
              onPressed: () =>
                  _showDeleteConfirmation(context, cartProvider, l10n),
              icon: const Icon(IconlyLight.delete),
              color: Theme.of(context).colorScheme.error,
              iconSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    CartProvider cartProvider,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.t('removeFromCart')),
        content: Text(
          l10n.format('removeItem', {'item': cartItem.product.name}),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.t('keep')),
          ),
          TextButton(
            onPressed: () {
              cartProvider.removeFromCart(cartItem.product);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.t('itemRemoved')),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Text(
              l10n.t('remove'),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
