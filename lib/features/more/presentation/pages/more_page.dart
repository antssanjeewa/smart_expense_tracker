import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/constants.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/settings_provider.dart';
import 'currency_picker_sheet.dart';
import 'privacy_policy_sheet.dart';

class MorePage extends ConsumerWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);

    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(ref),
            const SizedBox(height: AppSpacing.l),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
              child: Column(
                children: [
                  _buildSection("Account", [
                    _SettingsTile(
                      icon: Icons.person_outline,
                      title: "Profile Information",
                      subtitle: "Name, email, phone number",
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.account_balance_wallet_outlined,
                      title: "Linked Accounts",
                      subtitle: "Manage banks and cards",
                      onTap: () {},
                    ),
                  ]),
                  const SizedBox(height: AppSpacing.l),
                  _buildSection("Preferences", [
                    _SettingsTile(
                      icon: Icons.dark_mode_outlined,
                      title: "Dark Mode",
                      subtitle: "Currently active",
                      trailing: Switch(
                        value: settings.isDarkMode,
                        onChanged: (val) => ref
                            .read(appSettingsProvider.notifier)
                            .toggleDarkMode(val),
                      ),
                    ),
                    _SettingsTile(
                      icon: Icons.notifications_none,
                      title: "Notifications",
                      subtitle: "Alerts and reminders",
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.payments_outlined,
                      title: "Currency",
                      subtitle: settings.currency,
                      onTap: () => {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => const CurrencyPickerSheet(),
                        )
                      },
                    ),
                  ]),
                  const SizedBox(height: AppSpacing.l),
                  _buildSection("Security", [
                    _SettingsTile(
                      icon: Icons.fingerprint,
                      title: "Biometric Unlock",
                      subtitle: "Face ID or Touch ID",
                      trailing: Switch(
                        value: settings.isBiometricEnabled,
                        onChanged: (val) => ref
                            .read(appSettingsProvider.notifier)
                            .toggleBiometric(val),
                      ),
                    ),
                    _SettingsTile(
                      icon: Icons.lock_reset,
                      title: "Change Password",
                      subtitle: "Last changed 3 months ago",
                      onTap: () {},
                    ),
                  ]),
                  const SizedBox(height: AppSpacing.l),
                  _buildSection("Support", [
                    _SettingsTile(
                      icon: Icons.help_outline,
                      title: "Help Center",
                      subtitle: "FAQs and contact support",
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.policy_outlined,
                      title: "Privacy Policy",
                      subtitle: "How we manage your data",
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => const FractionallySizedBox(
                            heightFactor: 0.8,
                            child: PrivacyPolicySheet(),
                          ),
                        );
                      },
                    ),
                    _SettingsTile(
                      icon: Icons.logout,
                      title: "Logout",
                      isDestructive: true,
                      onTap: () async {
                        await ref
                            .read(authControllerProvider.notifier)
                            .logout();
                      },
                    ),
                  ]),
                  const SizedBox(height: AppSpacing.xl),
                  const Text(
                    "Smart Expense Tracker v2.4.0",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text("Settings"),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildProfileHeader(WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return authState.maybeWhen(
      data: (user) => Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                  child: const CircleAvatar(
                    radius: 45,
                    backgroundImage: NetworkImage(
                      "https://i.pravatar.cc/150?u=alex",
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.edit, size: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.m),
            Text(
              user ?? "Sameera Sanjeewa",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Text(
              "alex.t@finmail.com",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
      orElse: () => const SizedBox.shrink(),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1e293b).withOpacity(0.5), // slate-card/50
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isDestructive;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDestructive
              ? Colors.red.withOpacity(0.1)
              : AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: isDestructive ? Colors.red : AppColors.primary,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isDestructive ? Colors.red : Colors.white,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            )
          : null,
      trailing: trailing ??
          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
    );
  }
}
