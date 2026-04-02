import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:intl/intl.dart';
import 'package:shetimitra/l10n/app_localizations.dart';
import 'package:shetimitra/models/order.dart';
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
    const activeStep = 2;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.t('orderDetails')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
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
          const SizedBox(height: 20),
          Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            elevation: 0.1,
            child: Padding(
              padding: const EdgeInsets.all(10),
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
                        avatar: const Icon(Icons.fire_truck),
                        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        label: Text(orderTimelines[activeStep]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.t('deliveryEstimate')),
                      Text(
                        DateFormat.yMMMd(Localizations.localeOf(context).languageCode)
                            .format(order.date),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    l10n.t('profileName'),
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(IconlyLight.home, size: 15),
                      const SizedBox(width: 5),
                      Expanded(child: Text(l10n.t('postLocation'))),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(IconlyLight.call, size: 15),
                      const SizedBox(width: 5),
                      const Expanded(child: Text('233 5447 51048')),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.t('paymentMethod')),
                      const Text(
                        'Credit Card **1234',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          OrderItem(order: order, visibleProducts: 1),
        ],
      ),
    );
  }
}
