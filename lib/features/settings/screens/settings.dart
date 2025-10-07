import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin/core/routes/route.dart';
import 'package:linkedin/core/theme/app_colors.dart';
import '../widgets/settings_card.dart';
import '../widgets/settings_tile.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            const SettingsCard(),
            const SizedBox(height: 20),

            _Section(
              title: 'Account Settings',
              children: [
                SettingsTile(
                  icon: Icons.person,
                  title: 'Edit profile',
                  onTap: () {
                    // navigate to edit profile
                  },
                ),
                SettingsTile(
                  icon: Icons.lock,
                  title: 'Change password',
                  onTap: () {},
                ),
                SettingsTile(
                  icon: Icons.dark_mode,
                  title: 'Dark mode',
                  trailing: _DarkModeSwitch(),
                ),
              ],
            ),

            const SizedBox(height: 18),
            _Section(
              title: 'More',
              children: [
                SettingsTile(
                  icon: Icons.info,
                  title: 'About us',
                  onTap: () {
                    GoRouter.of(context).push(Routes.aboutUs);
                  },
                ),
                SettingsTile(
                  icon: Icons.description,
                  title: 'Terms and conditions',
                  onTap: () {
                    GoRouter.of(context).push(Routes.termsandconditions);
                  },
                ),
                SettingsTile(
                  icon: Icons.mail,
                  title: 'Contact Us',
                  onTap: () {},
                ),
                SettingsTile(
                  icon: Icons.logout,
                  title: 'Log Out',
                  titleColor: AppColors.danger,
                  trailing: const Icon(
                    Icons.exit_to_app,
                    color: AppColors.primary,
                  ),
                  onTap: () {
                    GoRouter.of(context).push(Routes.createAccaount);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section({required this.title, required this.children, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const Divider(),
            ...children,
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}

class _DarkModeSwitch extends StatefulWidget {
  const _DarkModeSwitch({super.key});
  @override
  State<_DarkModeSwitch> createState() => _DarkModeSwitchState();
}

class _DarkModeSwitchState extends State<_DarkModeSwitch> {
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      activeColor: AppColors.primary,
      onChanged: (v) => setState(() => value = v),
    );
  }
}
