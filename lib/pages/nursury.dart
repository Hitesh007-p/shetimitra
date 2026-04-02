import 'package:flutter/material.dart';
import 'package:shetimitra/l10n/app_localizations.dart';

class NursaryScreen extends StatelessWidget {
  const NursaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.t('farmingServices')),
      ),
      body: Center(
        child: Text(
          l10n.t('serviceNursery'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
