import 'package:flutter/material.dart';
import 'package:shetimitra/l10n/app_localizations.dart';

class LanguageMenuButton extends StatelessWidget {
  const LanguageMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controller = AppLocaleScope.of(context);

    return PopupMenuButton<Locale>(
      tooltip: l10n.t('language'),
      icon: const Icon(Icons.language),
      onSelected: controller.setLocale,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: const Locale('en'),
          child: Text(l10n.languageName('en')),
        ),
        PopupMenuItem(
          value: const Locale('hi'),
          child: Text(l10n.languageName('hi')),
        ),
        PopupMenuItem(
          value: const Locale('mr'),
          child: Text(l10n.languageName('mr')),
        ),
      ],
    );
  }
}
