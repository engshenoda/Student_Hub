import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin/core/widgets/custom_bottom_navigation.dart';

class Post extends StatelessWidget {
  const Post({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomBottomNavigationBar(
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFB2DFDB), Colors.white],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Row
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              GoRouter.of(context).pop();
                            },
                            icon: Icon(
                              Icons.cancel_outlined,
                              size: 40,
                              color: Colors.teal,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 25),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 22,
                            backgroundImage: NetworkImage(
                              'https://www.bing.com/th/id/OIP.EzA6vF2nER9bJEh6o1EHZAHaI7?w=174&h=211&c=8&rs=1&qlt=90&o=6&cb=12&dpr=1.3&pid=3.1&rm=2',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hi , Mera Mourad",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.teal[800],
                                ),
                              ),
                              Text(
                                "UI / UX Designer",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.teal[800],
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF004D40),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Post',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: const [
                          Text(
                            "Share your thoughts",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          Spacer(),
                          Icon(Icons.add, color: Colors.grey),
                          SizedBox(width: 10),
                          Icon(Icons.image, color: Colors.grey),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
