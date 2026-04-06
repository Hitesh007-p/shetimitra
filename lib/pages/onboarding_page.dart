import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:shetimitra/l10n/app_localizations.dart';
import 'package:shetimitra/pages/login.dart';
import 'package:shetimitra/widgets/language_menu_button.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  void initState() {
    super.initState();
    // Show language selection dialog if no language is selected
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = AppLocaleScope.of(context);
      if (controller.locale == null) {
        _showLanguageSelectionDialog();
      }
    });
  }

  void _showLanguageSelectionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Your Language'),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Please select your preferred language to continue',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _buildLanguageOption(
                context,
                'English',
                '🇬🇧',
                'en',
              ),
              const SizedBox(height: 12),
              _buildLanguageOption(
                context,
                'हिन्दी',
                '🇮🇳',
                'hi',
              ),
              const SizedBox(height: 12),
              _buildLanguageOption(
                context,
                'मराठी',
                '🇮🇳',
                'mr',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String languageName,
    String flag,
    String languageCode,
  ) {
    return InkWell(
      onTap: () async {
        final controller = AppLocaleScope.of(context);
        await controller.setLocale(Locale(languageCode));
        if (mounted) {
          Navigator.of(context).pop(); // Close dialog
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade50,
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                languageName,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        actions: const [LanguageMenuButton()],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              const Spacer(),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 380),
                child: Image.asset('assets/shetimitra.png'),
              ),
              const Spacer(),
              Text(
                l10n.t('welcomeTitle'),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold, fontSize: 26),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 30),
                child: Text(
                  l10n.t('onboardingDescription'),
                  textAlign: TextAlign.center,
                ),
              ),
              FilledButton.tonalIcon(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    CupertinoPageRoute(builder: (context) => const MyLogin()),
                  );
                },
                icon: const Icon(IconlyLight.login),
                label: Text(l10n.t('startWithLogin')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
