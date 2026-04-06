import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:shetimitra/l10n/app_localizations.dart';
import 'package:shetimitra/models/user.dart';
import 'package:shetimitra/services/user_service.dart';
import 'package:shetimitra/pages/orders_page.dart';
import 'package:shetimitra/widgets/language_menu_button.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // ONLY CHANGES APPLIED - UI SAME

  Future<void> _loadUserData() async {
    final user = await UserService.getUser();

    if (!mounted) return; // ✅ FIX: avoid setState after dispose

    setState(() {
      _user = user;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          actions: const [LanguageMenuButton()],
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_user == null) {
      return Scaffold(
        appBar: AppBar(
          actions: const [LanguageMenuButton()],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                IconlyLight.profile,
                size: 80,
                color: Colors.grey,
              ),
              const SizedBox(height: 20),
              Text(
                'No profile data found',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: const [LanguageMenuButton()],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header Section
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.8),
                    Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              padding: const EdgeInsets.only(top: 20, bottom: 30),
              child: Column(
                children: [
                  // Profile Photo
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    backgroundImage: _user!.profilePhotoPath != null
                        ? FileImage(File(_user!.profilePhotoPath!))
                        : null,
                    child: _user!.profilePhotoPath == null
                        ? Icon(
                            IconlyBold.profile,
                            size: 60,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),

            // Farm Information Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Farm Details Card
                  Text(
                    'Farm Details',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                      color: Colors.grey.shade50,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Farmer Name
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                IconlyLight.profile,
                                color: Theme.of(context).colorScheme.primary,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Farmer Name',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _user!.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Crops Cultivated
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                IconlyLight.closeSquare,
                                color: Theme.of(context).colorScheme.primary,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Crops Cultivated',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall,
                                    ),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 6,
                                      runSpacing: 6,
                                      children: _user!.selectedCrops
                                          .map((crop) => Chip(
                                                label: Text(l10n.t(crop)),
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primaryContainer,
                                                labelStyle: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  fontSize: 12,
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Total Crops
                        Row(
                          children: [
                            Icon(
                              IconlyLight.chart,
                              color: Theme.of(context).colorScheme.primary,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Crops',
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${_user!.selectedCrops.length} crops',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Quick Actions Section
                  Text(
                    'Quick Actions',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: [
                      _buildQuickActionCard(
                        context,
                        icon: IconlyLight.bag,
                        title: 'Orders',
                        subtitle: 'View & track',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OrdersPage(),
                            ),
                          );
                        },
                      ),
                      _buildQuickActionCard(
                        context,
                        icon: IconlyLight.edit,
                        title: 'Edit Profile',
                        subtitle: 'Update info',
                        onTap: () {
                          _showEditProfileScreen();
                        },
                      ),
                      _buildQuickActionCard(
                        context,
                        icon: IconlyLight.chat,
                        title: 'Support',
                        subtitle: 'Get help',
                        onTap: () {},
                      ),
                      _buildQuickActionCard(
                        context,
                        icon: IconlyLight.setting,
                        title: 'Settings',
                        subtitle: 'Preferences',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Helpful Resources Section
                  Text(
                    'Helpful Resources',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildResourceTile(
                    context,
                    icon: IconlyLight.infoSquare,
                    title: 'About Us',
                    description: 'Learn about ShhetiMitra',
                    onTap: () {},
                  ),
                  _buildResourceTile(
                    context,
                    icon: IconlyLight.lock,
                    title: 'Privacy & Security',
                    description: 'Your data protection',
                    onTap: () {},
                  ),
                  _buildResourceTile(
                    context,
                    icon: IconlyLight.call,
                    title: 'Contact Us',
                    description: 'Reach out to support',
                    onTap: () {},
                  ),
                  const SizedBox(height: 16),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showLogoutDialog();
                      },
                      icon: const Icon(IconlyBold.logout),
                      label: const Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade500,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.labelSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        subtitle: Text(description),
        trailing: const Icon(IconlyLight.arrowRight),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200),
        ),
      ),
    );
  }

  void _showEditProfileScreen() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => EditProfileSheet(
          user: _user!,
          onSave: () {
            Navigator.pop(context);
            _loadUserData();
          }),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await UserService.clearUser();
              if (mounted) {
                Navigator.pop(context);
                // Navigate to login
              }
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class EditProfileSheet extends StatefulWidget {
  final User user;
  final VoidCallback onSave;

  const EditProfileSheet({
    super.key,
    required this.user,
    required this.onSave,
  });

  @override
  State<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  late TextEditingController nameController;
  late TextEditingController addressController;
  late List<String> selectedCrops;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    addressController = TextEditingController(text: widget.user.address ?? '');
    selectedCrops = [...widget.user.selectedCrops];
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a name')),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    final updatedUser = widget.user.copyWith(
      name: nameController.text,
      address:
          addressController.text.isNotEmpty ? addressController.text : null,
      selectedCrops: selectedCrops,
    );

    await UserService.updateUser(updatedUser);

    if (mounted) {
      setState(() {
        isSaving = false;
      });
      widget.onSave();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.55,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Edit Profile',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name Field
                    Text(
                      'Full Name *',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: 'Enter your full name',
                        prefixIcon: const Icon(IconlyLight.profile),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Address Field
                    Text(
                      'Address',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: addressController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'Enter your address',
                        prefixIcon: const Icon(IconlyLight.location),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Crops Selection (Read-only display)
                    Text(
                      'Crops Cultivated',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: selectedCrops
                          .map((crop) => Chip(
                                label: Text(crop),
                                onDeleted: () {
                                  setState(() {
                                    selectedCrops.remove(crop);
                                  });
                                },
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                labelStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 24),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: isSaving ? null : _saveChanges,
                        icon: isSaving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(IconlyBold.arrowRight),
                        label: Text(
                          isSaving ? 'Saving...' : 'Save Changes',
                          style: const TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Cancel Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
