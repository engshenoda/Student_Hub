import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/list_view.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFAAE7DB), Color(0xFFFBF9FC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              GoRouter.of(context).pop();
            },
          ),
          title: const Text("Notification"),
          centerTitle: true,
          actions: [IconButton(icon: const Icon(Icons.done), onPressed: () {})],
          bottom: const TabBar(
            tabs: [
              Tab(text: "All"),
              Tab(text: "Unread"),
              Tab(text: "Mentions"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildNotificationList(),
            _buildNotificationList(),
            _buildNotificationList(),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList() {
    return ListView2();
  }
}
