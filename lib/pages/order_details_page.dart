import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:intl/intl.dart';
import 'package:shetimitra/l10n/app_localizations.dart';
import 'package:shetimitra/models/order.dart';
import 'package:shetimitra/models/order_response.dart';
import 'package:shetimitra/widgets/order_item.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final orderTimelines = [
      l10n.t('processing'),
      l10n.t('picking'),
      l10n.t('shipping'),
      l10n.t('delivered'),
    ];

    // Determine active step based on order status
    final activeStep = _getActiveStep(order.status);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.t('orderDetails')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Order Timeline
          EasyStepper(
            activeStep: activeStep,
            lineLength: 70,
            lineSpace: 0,
            defaultLineColor: Colors.grey.shade300,
            finishedLineColor: theme.colorScheme.primary,
            activeStepTextColor: Colors.black87,
            finishedStepTextColor: Colors.black87,
            internalPadding: 0,
            showLoadingAnimation: true,
            stepRadius: 8,
            lineThickness: 1.5,
            steps: List.generate(orderTimelines.length, (index) {
              return EasyStep(
                customStep: CircleAvatar(
                  radius: 8,
                  backgroundColor: activeStep > index
                      ? theme.colorScheme.primary.withAlpha((0.5 * 255).round())
                      : Colors.grey.shade400,
                  child: CircleAvatar(
                    radius: 2.5,
                    backgroundColor: activeStep > index
                        ? theme.colorScheme.primary
                        : Colors.grey.shade200,
                  ),
                ),
                title: orderTimelines[index],
                topTitle: true,
              );
            }),
            onStepReached: (index) {},
          ),
          const SizedBox(height: 24),

          // Payment Status Card
          if (order.paymentId != null)
            _buildPaymentStatusCard(context, theme, l10n),

          const SizedBox(height: 16),

          // Order Details Card
          Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            elevation: 0.1,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.format('orderPrefix', {'id': order.id}),
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Chip(
                        shape: const StadiumBorder(),
                        side: BorderSide.none,
                        backgroundColor: theme.colorScheme.primaryContainer
                            .withAlpha((0.4 * 255).round()),
                        labelPadding: EdgeInsets.zero,
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 10),
                        label: Text(order.status.label),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),

                  // Order Date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.t('orderDate'),
                        style: theme.textTheme.bodyMedium,
                      ),
                      Text(
                        DateFormat.yMMMd(
                          Localizations.localeOf(context).languageCode,
                        ).format(order.date),
                        style: theme.textTheme.bodyMedium?.copyWith(
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
                        l10n.t('expectedDelivery'),
                        style: theme.textTheme.bodyMedium,
                      ),
                      Text(
                        DateFormat.yMMMd(
                          Localizations.localeOf(context).languageCode,
                        ).format(order.deliveryDate),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),

                  // Shipping Address
                  Text(
                    l10n.t('shippingAddress'),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        IconlyLight.home,
                        size: 18,
                        color: theme.colorScheme.outline,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          order.shippingAddress,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),

                  // Payment Method Section
                  Text(
                    l10n.t('paymentMethod'),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.credit_card,
                        size: 18,
                        color: theme.colorScheme.outline,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          order.paymentId ?? l10n.t('paymentPending'),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Order Summary
          _buildOrderSummary(context, theme, l10n),
          const SizedBox(height: 16),

          // Items Section
          OrderItem(order: order, visibleProducts: 3),
        ],
      ),
    );
  }

  Widget _buildPaymentStatusCard(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.3),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: theme.colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.t('paymentSuccessful'),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.t('paymentVerificationConfirmed'),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    final tax = order.subtotal * 0.18;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.t('orderSummary'),
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.t('subtotal')),
              Text('₹${order.subtotal.toStringAsFixed(0)}'),
            ],
          ),
          const SizedBox(height: 8),
          if (order.discount != null && order.discount! > 0)
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.t('discount'),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Text(
                      '-₹${order.discount!.toStringAsFixed(0)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.t('estimatedTax')),
              Text('₹${tax.toStringAsFixed(0)}'),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: theme.colorScheme.outline.withOpacity(0.2)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.t('totalAmount'),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '₹${order.total.toStringAsFixed(0)}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _getActiveStep(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 0;
      case OrderStatus.confirmed:
        return 1;
      case OrderStatus.shipped:
        return 2;
      case OrderStatus.delivered:
        return 3;
      case OrderStatus.cancelled:
        return 0; // or handle cancelled state differently
    }
  }
}
