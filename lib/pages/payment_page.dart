import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shetimitra/config/razorpay_config.dart';
import 'package:shetimitra/l10n/app_localizations.dart';
import 'package:shetimitra/models/order_response.dart';
import 'package:shetimitra/pages/order_success_page.dart';
import 'package:shetimitra/providers/cart_provider.dart';
import 'package:shetimitra/services/order_service.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({
    required this.order,
    super.key,
  });

  final OrderResponse order;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late Razorpay _razorpay;
  late OrderService _orderService;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    _orderService = OrderService();
    _initializeRazorpay();
  }

  void _initializeRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final l10n = AppLocalizations.of(context);

    setState(() {
      isProcessing = true;
    });

    try {
      // Verify payment on backend
      final isVerified = await _orderService.verifyPayment(
        paymentId: response.paymentId ?? '',
        signature: response.signature ?? '',
        orderId: widget.order.id,
      );

      if (isVerified && mounted) {
        // Clear cart on successful payment
        if (mounted) {
          context.read<CartProvider>().clearCart();
        }

        // Navigate to success page
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => OrderSuccessPage(order: widget.order),
            ),
            (route) => route.isFirst,
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.t('paymentVerificationFailed')),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
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
          isProcessing = false;
        });
      }
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    final l10n = AppLocalizations.of(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${l10n.t('paymentFailed')}: ${response.message}',
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    final l10n = AppLocalizations.of(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${l10n.t('externalWallet')}: ${response.walletName}',
        ),
      ),
    );
  }

  void _openRazorpayPayment() {
    final l10n = AppLocalizations.of(context);

    final options = {
      'key': RazorpayConfig.keyId,
      'amount': (widget.order.total * 100).toInt(), // Amount in paise
      'name': l10n.t('appName'),
      'description': 'Order #${widget.order.id}',
      'order_id': widget.order.id, // Razorpay order ID
      'prefill': {
        'contact': '+919876543210', // TODO: Get from user profile
        'email': 'user@example.com', // TODO: Get from user profile
      },
      'theme': {
        'color': '#2E7D32', // Green color
      },
      'backdrop': true,
      'method': {
        'upi': true,
        'card': true,
        'wallet': true,
        'netbanking': true,
      },
      // Image URL for checkout page (optional)
      // 'image': 'https://your-cdn.example.com/logo.png',
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.t('error')}: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return WillPopScope(
      onWillPop: () async {
        // Prevent going back during payment
        if (isProcessing) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.t('paymentProcessing'))),
          );
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.t('payment')),
          automaticallyImplyLeading: !isProcessing,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Details Section
              _buildOrderDetailsCard(context, l10n),
              const SizedBox(height: 20),

              // Payment Methods Info
              _buildPaymentMethodsInfo(context, l10n),
              const SizedBox(height: 20),

              // Security Info
              _buildSecurityInfo(context, l10n),
              const SizedBox(height: 30),

              // Pay Button
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: isProcessing ? null : _openRazorpayPayment,
                  icon: isProcessing
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
                      : const Icon(Icons.lock),
                  label: Text(
                    isProcessing
                        ? l10n.t('processingPayment')
                        : l10n.format('payAmount', {
                            'amount':
                                '₹${widget.order.total.toStringAsFixed(0)}'
                          }),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Cancel Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: isProcessing ? null : () => Navigator.pop(context),
                  child: Text(l10n.t('cancelPayment')),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderDetailsCard(BuildContext context, AppLocalizations l10n) {
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
            l10n.t('orderDetails'),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          // Order ID
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.t('orderId'),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                widget.order.id,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.t('items'),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                '${widget.order.items.length}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Delivery Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.t('delivery'),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                _formatDate(widget.order.deliveryDate),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          // Subtotal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.t('subtotal'),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                '₹${widget.order.subtotal.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          if (widget.order.discount != null && widget.order.discount! > 0)
            Column(
              children: [
                const SizedBox(height: 8),
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
                      '-₹${widget.order.discount!.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          const SizedBox(height: 8),
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
                '₹${widget.order.tax.toStringAsFixed(0)}',
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
                l10n.t('totalAmount'),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                '₹${widget.order.total.toStringAsFixed(0)}',
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

  Widget _buildPaymentMethodsInfo(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.t('acceptedPaymentMethods'),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildPaymentMethodChip(
              context,
              l10n.t('upi'),
              Icons.phone_android,
            ),
            _buildPaymentMethodChip(
              context,
              l10n.t('debitCard'),
              Icons.credit_card,
            ),
            _buildPaymentMethodChip(
              context,
              l10n.t('creditCard'),
              Icons.credit_card,
            ),
            _buildPaymentMethodChip(
              context,
              l10n.t('wallet'),
              Icons.account_balance_wallet,
            ),
            _buildPaymentMethodChip(
              context,
              l10n.t('netBanking'),
              Icons.comment_bank_sharp,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentMethodChip(
    BuildContext context,
    String label,
    IconData icon,
  ) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      side: BorderSide(
        color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
      ),
    );
  }

  Widget _buildSecurityInfo(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.security,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.t('securePayment'),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
        ],
      ),
    );
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
}
