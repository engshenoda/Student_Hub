import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? titleColor;
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.trailing,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Icon(icon, color: Colors.black54),
      title: Text(
        title,
        style: TextStyle(color: titleColor ?? Colors.black87, fontSize: 16),
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
