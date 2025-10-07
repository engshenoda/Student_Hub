import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final String imagePath;

  const ProfileCard({super.key, required this.name, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: AssetImage('assets/profile_image.jpg'),
          ),
          const SizedBox(width: 12),
          Text(
            name,
            style: const TextStyle(
              color: Color(0xFF006E59),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 12, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF006E59),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const SettingsTile({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}

class DarkModeSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const DarkModeSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text("Dark mode"),
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFF006E59),
    );
  }
}

class LogoutTile extends StatelessWidget {
  final VoidCallback? onTap;

  const LogoutTile({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text(
        "Log Out",
        style: TextStyle(color: Color(0xFF006E59), fontWeight: FontWeight.bold),
      ),
      trailing: const Icon(Icons.logout, color: Color(0xFF006E59)),
      onTap: onTap,
    );
  }
}
