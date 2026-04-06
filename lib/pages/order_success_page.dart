import 'package:flutter/material.dart';
import 'package:shetimitra/l10n/app_localizations.dart';
import 'package:shetimitra/models/order_response.dart';
import 'package:shetimitra/pages/home_page.dart';
import 'package:shetimitra/pages/orders_page.dart';

class OrderSuccessPage extends StatefulWidget {
  const OrderSuccessPage({
    required this.order,
    super.key,
  });

  final OrderResponse order;

  @override
  State<OrderSuccessPage> createState() => _OrderSuccessPageState();
}

class _OrderSuccessPageState extends State<OrderSuccessPage>
    with TickerProviderStateMixin {
  late AnimationController _checkmarkController;
  late Animation<double> _checkmarkAnimation;

  @override
  void initState() {
    super.initState();
    _checkmarkController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _checkmarkAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _checkmarkController, curve: Curves.elasticOut),
    );

    _checkmarkController.forward();
  }

  @override
  void dispose() {
    _checkmarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return WillPopScope(
      onWillPop: () async => false, // Prevent back navigation
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(l10n.t('orderConfirmed')),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 30),

              // Success Checkmark Animation
              ScaleTransition(
                scale: _checkmarkAnimation,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: Icon(
                    Icons.check,
                    size: 60,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Success Message
              Text(
                l10n.t('paymentSuccessful'),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              Text(
                l10n.t('orderConfirmationSent'),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // Order Details Card
              _buildOrderDetailsCard(context, l10n),
              const SizedBox(height: 24),

              // What's Next Section
              _buildWhatsNextSection(context, l10n),
              const SizedBox(height: 30),

              // Action Buttons
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    // Navigate to Orders List Page
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const OrdersPage(),
                      ),
                      (route) => route.isFirst,
                    );
                  },
                  child: Text(l10n.t('viewOrder')),
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // Navigate to Home/Products Page
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                      (route) => route.isFirst,
                    );
                  },
                  child: Text(l10n.t('continueShopping')),
                ),
              ),
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
              Text(l10n.t('orderId')),
              Text(
                widget.order.id,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Order Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.t('orderDate')),
              Text(
                _formatDate(widget.order.createdAt),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Expected Delivery
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.t('expectedDelivery')),
              Text(
                _formatDate(widget.order.deliveryDate),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Number of Items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.t('items')),
              Text(
                '${widget.order.items.length}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // Order Amount
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

  Widget _buildWhatsNextSection(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.t('whatsNext'),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        _buildNextStepItem(
          context,
          l10n,
          1,
          l10n.t('orderConfirmation'),
          l10n.t('confirmationEmailSent'),
          Icons.mail,
        ),
        const SizedBox(height: 12),
        _buildNextStepItem(
          context,
          l10n,
          2,
          l10n.t('orderPacking'),
          l10n.t('packingInProgress'),
          Icons.local_shipping,
        ),
        const SizedBox(height: 12),
        _buildNextStepItem(
          context,
          l10n,
          3,
          l10n.t('orderDelivery'),
          l10n.format('deliveryBy', {
            'date': _formatDate(widget.order.deliveryDate),
          }),
          Icons.done_all,
        ),
      ],
    );
  }

  Widget _buildNextStepItem(
    BuildContext context,
    AppLocalizations l10n,
    int stepNumber,
    String title,
    String description,
    IconData icon,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Step number badge
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          child: Center(
            child: Text(
              '$stepNumber',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Step content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
            ],
          ),
        ),
      ],
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
