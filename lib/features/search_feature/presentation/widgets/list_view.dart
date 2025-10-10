import 'package:flutter/material.dart';

import 'list_tile.dart';

class TabsListView extends StatelessWidget {
  final List<String> items;
  final IconData icon;
  final String query;

  const TabsListView({
    super.key,
    required this.items,
    required this.icon,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    final filtered = items
        .where((item) => item.toLowerCase().contains(query))
        .toList();

    if (filtered.isEmpty) {
      return const Center(
        child: Text(
          "No results found",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        return CustomListTile(
          title: filtered[index],
          subtitle: "Tap to view details",
          leadingIcon: icon,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("You tapped on: ${filtered[index]}")),
            );
          },
        );
      },
    );
  }
}
