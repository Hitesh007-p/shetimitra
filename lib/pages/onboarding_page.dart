import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:shetimitra/l10n/app_localizations.dart';
import 'package:shetimitra/pages/login.dart';
import 'package:shetimitra/widgets/language_menu_button.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

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
