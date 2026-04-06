import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shetimitra/data/orders.dart';
import 'package:shetimitra/l10n/app_localizations.dart';
import 'package:shetimitra/models/order.dart';
import 'package:shetimitra/models/order_response.dart';
import 'package:shetimitra/pages/order_details_page.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    // Map order statuses for filtering

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.t('myOrders')),
          bottom: TabBar(
            physics: const BouncingScrollPhysics(),
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(text: '${l10n.t('processing')} ${orders.length}'),
              Tab(text: '${l10n.t('picking')} ${orders.length}'),
              Tab(text: '${l10n.t('shipping')} ${orders.length}'),
              Tab(text: '${l10n.t('delivered')} ${orders.length}'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOrdersList(context, theme, l10n, orders),
            _buildOrdersList(context, theme, l10n, orders),
            _buildOrdersList(context, theme, l10n, orders),
            _buildOrdersList(context, theme, l10n, orders),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
    List<Order> ordersList,
  ) {
    return ordersList.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 64,
                  color: theme.colorScheme.outline.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.t('cartEmpty'),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: ordersList.length,
            itemBuilder: (context, index) {
              final order = ordersList[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildOrderCard(context, theme, l10n, order),
              );
            },
          );
  }

  Widget _buildOrderCard(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
    Order order,
  ) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OrderDetailsPage(order: order),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order ID and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.format('orderPrefix', {'id': order.id}),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildStatusBadge(
                  context,
                  theme,
                  order.status.label,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Order Date and Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat.yMMMd(
                    Localizations.localeOf(context).languageCode,
                  ).format(order.date),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
                Text(
                  '₹${order.total.toStringAsFixed(0)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Items Count
            Text(
              l10n.format('itemsCount', {'count': '${order.products.length}'}),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 8),

            // Payment Status
            if (order.paymentId != null)
              Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    l10n.t('paymentSuccessful'),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(
    BuildContext context,
    ThemeData theme,
    String status,
  ) {
    final statusColor = _getStatusColor(theme, status);
    final statusBackgroundColor = statusColor.withOpacity(0.1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: theme.textTheme.labelSmall?.copyWith(
          color: statusColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getStatusColor(ThemeData theme, String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return theme.colorScheme.outline;
    }
  }
}
