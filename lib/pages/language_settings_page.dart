import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:shetimitra/l10n/app_localizations.dart';

class LanguageSettingsPage extends StatefulWidget {
  const LanguageSettingsPage({super.key});

  @override
  State<LanguageSettingsPage> createState() => _LanguageSettingsPageState();
}

class _LanguageSettingsPageState extends State<LanguageSettingsPage> {
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    final controller = AppLocaleScope.of(context);
    _selectedLanguage = controller.locale?.languageCode ?? 'en';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controller = AppLocaleScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.t('language')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              l10n.t('selectLanguage'),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          _buildLanguageTile(
            context: context,
            languageName: l10n.languageName('en'),
            subtitle: 'English',
            languageCode: 'en',
            controller: controller,
          ),
          _buildLanguageTile(
            context: context,
            languageName: l10n.languageName('hi'),
            subtitle: 'हिन्दी',
            languageCode: 'hi',
            controller: controller,
          ),
          _buildLanguageTile(
            context: context,
            languageName: l10n.languageName('mr'),
            subtitle: 'मराठी',
            languageCode: 'mr',
            controller: controller,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(IconlyLight.infoSquare),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.t('languageChangeNote'),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageTile({
    required BuildContext context,
    required String languageName,
    required String subtitle,
    required String languageCode,
    required AppLocaleController controller,
  }) {
    final isSelected = _selectedLanguage == languageCode;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Material(
        child: InkWell(
          onTap: () async {
            setState(() {
              _selectedLanguage = languageCode;
            });
            await controller.setLocale(Locale(languageCode));
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      languageName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
