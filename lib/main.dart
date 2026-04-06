import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shetimitra/l10n/app_localizations.dart';
import 'package:shetimitra/pages/onboarding_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final AppLocaleController _localeController = AppLocaleController();

  @override
  void initState() {
    super.initState();
    _localeController.load();
  }

  @override
  Widget build(BuildContext context) {
    return AppLocaleScope(
      controller: _localeController,
      child: AnimatedBuilder(
        animation: _localeController,
        builder: (context, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: _localeController.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: ThemeData(
              useMaterial3: true,
              textTheme: GoogleFonts.muktaTextTheme(),
            ),
            onGenerateTitle: (context) =>
                AppLocalizations.of(context).t('appName'),
            home: const OnboardingPage(),
          );
        },
      ),
    );
  }
}
