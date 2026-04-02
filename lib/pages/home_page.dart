import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:shetimitra/l10n/app_localizations.dart';
import 'package:shetimitra/pages/calculation.dart';
import 'package:shetimitra/pages/cart_page.dart';
import 'package:shetimitra/pages/explore_page.dart';
import 'package:shetimitra/pages/profile_page.dart';
import 'package:shetimitra/pages/services_page.dart';
import 'package:shetimitra/widgets/language_menu_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _pages = [
    const ExplorePage(),
    const ServicesPage(),
    const Calculation(),
    const ProfilePage(),
  ];

  int currentPageIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: const Drawer(),
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton.filledTonal(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(Icons.menu),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.t('greeting'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              l10n.t('servicesSubtitle'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          const LanguageMenuButton(),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton.filledTonal(
              onPressed: () {},
              icon: badges.Badge(
                badgeContent: const Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                position: badges.BadgePosition.topEnd(top: -15, end: -12),
                badgeStyle: const badges.BadgeStyle(
                  badgeColor: Colors.green,
                ),
                child: const Icon(IconlyBroken.notification),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton.filledTonal(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CartPage(),
                  ),
                );
              },
              icon: badges.Badge(
                badgeContent: const Text(
                  '5',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                position: badges.BadgePosition.topEnd(top: -15, end: -12),
                badgeStyle: const badges.BadgeStyle(
                  badgeColor: Colors.green,
                ),
                child: const Icon(Icons.shopping_cart),
              ),
            ),
          ),
        ],
      ),
      body: _pages[currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentPageIndex,
        onTap: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(IconlyLight.home),
            label: l10n.t('tabExplore'),
            activeIcon: const Icon(IconlyBold.home),
          ),
          BottomNavigationBarItem(
            icon: const Icon(IconlyLight.call),
            label: l10n.t('tabServices'),
            activeIcon: const Icon(IconlyBold.call),
          ),
          BottomNavigationBarItem(
            icon: const Icon(IconlyLight.calendar),
            label: l10n.t('tabPlanning'),
            activeIcon: const Icon(IconlyBold.chat),
          ),
          BottomNavigationBarItem(
            icon: const Icon(IconlyLight.profile),
            label: l10n.t('tabProfile'),
            activeIcon: const Icon(IconlyBold.profile),
          ),
        ],
      ),
    );
  }
}
