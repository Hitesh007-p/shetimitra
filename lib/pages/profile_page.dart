import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:shetimitra/l10n/app_localizations.dart';
import 'package:shetimitra/pages/orders_page.dart';
import 'package:shetimitra/widgets/language_menu_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        actions: const [LanguageMenuButton()],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 15),
            child: CircleAvatar(
              radius: 62,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const CircleAvatar(
                radius: 60,
                foregroundImage: NetworkImage('https://images.unsplash.com/'),
              ),
            ),
          ),
          Center(
            child: Text(
              l10n.t('profileName'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Center(
            child: Text(
              l10n.t('profileEmail'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 25),
          ListTile(
            title: Text(l10n.t('orderedItems')),
            leading: const Icon(IconlyLight.bag),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrdersPage()),
              );
            },
          ),
          ListTile(
            title: Text(l10n.t('aboutUs')),
            leading: const Icon(IconlyLight.infoSquare),
            onTap: () {},
          ),
          ListTile(
            title: Text(l10n.t('updateProfile')),
            leading: const Icon(IconlyLight.profile),
            onTap: () {},
          ),
          ListTile(
            title: Text(l10n.t('logout')),
            leading: const Icon(IconlyLight.logout),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
