import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:shetimitra/l10n/app_localizations.dart';
import 'package:shetimitra/pages/payment_page.dart';
import 'package:shetimitra/providers/cart_provider.dart';
import 'package:shetimitra/services/order_service.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  // Form controllers
  late TextEditingController addressController;
  late TextEditingController couponController;

  // Form state
  DateTime? selectedDeliveryDate;
  bool isCouponValidated = false;
  Map<String, dynamic> appliedCoupon = {};
  bool isValidatingCoupon = false;
  bool isPlacingOrder = false;
  String couponError = '';

  // Order service
  late OrderService orderService;

  @override
  void initState() {
    super.initState();
    addressController = TextEditingController();
    couponController = TextEditingController();
    orderService = OrderService();

    // Load saved address from user service (or use default)
    _initializeAddress();
  }

  @override
  void dispose() {
    addressController.dispose();
    couponController.dispose();
    super.dispose();
  }

  void _initializeAddress() {
    // TODO: Load from UserService when available
    addressController.text = '123 Farm Lane, Nashik, Maharashtra 422001';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.t('checkout')),
        elevation: 0,
      ),
      body: cartProvider.items.isEmpty
          ? _buildEmptyCart(context, l10n)
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Shipping Address Section
                  _buildAddressSection(context, l10n),
                  const SizedBox(height: 20),

                  // 2. Delivery Date Section
                  _buildDeliveryDateSection(context, l10n),
                  const SizedBox(height: 20),

                  // 3. Coupon Section
                  _buildCouponSection(context, l10n),
                  const SizedBox(height: 20),

                  // 4. Order Summary Section
                  _buildOrderSummary(context, l10n, cartProvider),
                  const SizedBox(height: 20),

                  // 5. Place Order Button
                  _buildPlaceOrderButton(context, l10n, cartProvider),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildEmptyCart(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            IconlyLight.bag2,
            size: 64,
            color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.t('cartEmpty'),
            style: Theme.of(context).textTheme.titleMedium,
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

  Widget _buildAddressSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.t('shippingAddress'),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: addressController,
          minLines: 3,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: l10n.t('enterAddress'),
            prefixIcon: const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Icon(IconlyLight.location),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryDateSection(
      BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.t('deliveryDate'),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => _selectDeliveryDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.t('estimatedDelivery'),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      selectedDeliveryDate != null
                          ? _formatDate(selectedDeliveryDate!)
                          : l10n.t('selectDate'),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                Icon(
                  IconlyLight.calendar,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
        if (selectedDeliveryDate != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              l10n.t('deliveryIn') +
                  ' ${_daysUntilDelivery(selectedDeliveryDate!)} ' +
                  l10n.t('days'),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
      ],
    );
  }

  Widget _buildCouponSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.t('haveCoupon'),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: couponController,
                enabled: !isCouponValidated,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  hintText: l10n.t('couponCode'),
                  filled: isCouponValidated,
                  fillColor: isCouponValidated
                      ? Theme.of(context).colorScheme.primaryContainer
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 56,
              child: FilledButton(
                onPressed: isCouponValidated
                    ? () => _clearCoupon()
                    : () => _validateCoupon(context, l10n),
                child: isValidatingCoupon
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(
                            Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      )
                    : Text(
                        isCouponValidated ? l10n.t('remove') : l10n.t('apply'),
                      ),
              ),
            ),
          ],
        ),
        if (isCouponValidated && appliedCoupon.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '${appliedCoupon['discountPercent']}% ${l10n.t('discount')} ${l10n.t('applied')}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
          ),
        if (couponError.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              couponError,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ),
      ],
    );
  }

  Widget _buildOrderSummary(
    BuildContext context,
    AppLocalizations l10n,
    CartProvider cartProvider,
  ) {
    final subtotal = cartProvider.totalPrice;
    final discount = isCouponValidated && appliedCoupon.isNotEmpty
        ? (subtotal * (appliedCoupon['discountPercent'] as num) / 100)
            .clamp(0.0, (appliedCoupon['maxDiscount'] as num).toDouble())
        : 0.0;
    final taxableAmount = subtotal - discount;
    final tax = taxableAmount * 0.18;
    final total = taxableAmount + tax;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.t('orderSummary'),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          // Items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.format(
                    'itemsCount', {'count': '${cartProvider.items.length}'}),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                '₹${subtotal.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Discount (if applied)
          if (discount > 0)
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.t('discount'),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    Text(
                      '-₹${discount.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          // Tax
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.t('estimatedTax'),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
              Text(
                '₹${tax.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.t('total'),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                '₹${total.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceOrderButton(
    BuildContext context,
    AppLocalizations l10n,
    CartProvider cartProvider,
  ) {
    final isFormValid =
        addressController.text.isNotEmpty && selectedDeliveryDate != null;

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: isFormValid && !isPlacingOrder
            ? () => _placeOrder(context, l10n, cartProvider)
            : null,
        icon: isPlacingOrder
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(
                    Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              )
            : const Icon(IconlyBold.arrowRight),
        label: Text(
          isPlacingOrder ? l10n.t('placingOrder') : l10n.t('placeOrder'),
        ),
      ),
    );
  }

  // ============= HELPER METHODS =============

  Future<void> _selectDeliveryDate(BuildContext context) async {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: tomorrow,
      firstDate: tomorrow,
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (selectedDate != null) {
      setState(() {
        selectedDeliveryDate = selectedDate;
      });
    }
  }

  Future<void> _validateCoupon(
      BuildContext context, AppLocalizations l10n) async {
    if (couponController.text.isEmpty) {
      setState(() {
        couponError = l10n.t('enterCouponCode');
      });
      return;
    }

    setState(() {
      isValidatingCoupon = true;
      couponError = '';
    });

    try {
      final result = await orderService.validateCoupon(couponController.text);

      setState(() {
        if (result['valid']) {
          isCouponValidated = true;
          appliedCoupon = result;
          couponError = '';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? l10n.t('couponApplied')),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
          );
        } else {
          couponError = result['message'] ?? l10n.t('invalidCoupon');
        }
      });
    } catch (e) {
      setState(() {
        couponError = l10n.t('errorValidatingCoupon');
      });
    } finally {
      setState(() {
        isValidatingCoupon = false;
      });
    }
  }

  void _clearCoupon() {
    setState(() {
      couponController.clear();
      isCouponValidated = false;
      appliedCoupon = {};
      couponError = '';
    });
  }

  Future<void> _placeOrder(
    BuildContext context,
    AppLocalizations l10n,
    CartProvider cartProvider,
  ) async {
    setState(() {
      isPlacingOrder = true;
    });

    try {
      // Create the order
      final createdOrder = await orderService.createOrder(
        items: cartProvider.items,
        shippingAddress: addressController.text,
        deliveryDate: selectedDeliveryDate!,
        couponCode: isCouponValidated ? couponController.text : null,
      );

      if (mounted) {
        // Navigate to payment page with created order
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => PaymentPage(order: createdOrder),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.t('error')}: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isPlacingOrder = false;
        });
      }
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  int _daysUntilDelivery(DateTime date) {
    return date.difference(DateTime.now()).inDays;
  }
}
