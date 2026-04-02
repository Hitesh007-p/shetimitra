import 'package:flutter/material.dart';
import 'package:shetimitra/data/orders.dart';
import 'package:shetimitra/l10n/app_localizations.dart';
import 'package:shetimitra/widgets/order_item.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tabs = [
      l10n.t('processing'),
      l10n.t('picking'),
      l10n.t('shipping'),
      l10n.t('delivered'),
    ];

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.t('myOrders')),
          bottom: TabBar(
            physics: const BouncingScrollPhysics(),
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: List.generate(tabs.length, (index) {
              return Tab(text: '${tabs[index]} ${orders.length}');
            }),
          ),
        ),
        body: TabBarView(
          children: List.generate(
            tabs.length,
            (index) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: List.generate(
                  orders.length,
                  (itemIndex) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: OrderItem(order: orders[itemIndex]),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
