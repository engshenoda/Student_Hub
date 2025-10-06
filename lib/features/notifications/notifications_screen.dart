import 'package:flutter/material.dart';

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
            onPressed: () {},
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
    return ListView.builder(
      itemCount: 5,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        return Card(
          color: Color(0xFFD9F4EF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFF00B894),
              child: Text("SJ", style: TextStyle(color: Colors.white)),
            ),
            title: const Text("Sarah Johnson sent you a message"),
            subtitle: const Text(
              "Senior Product Manager at TechCrop • 500+ connections",
            ),
            trailing: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF00B894),
              ),
              child: const Text("Connect"),
            ),
          ),
        );
      },
    );
  }
}
