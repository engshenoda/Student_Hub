import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin/core/routes/route.dart';
import '../widgets/post_card.dart';
import '../widgets/bottom_navigation.dart';
import 'package:linkedin/core/widgets/custom_bottom_navigation.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                // -------- Header Section --------
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
                                  color: Colors.teal[800],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              GoRouter.of(context).push(Routes.search);
                            },
                            icon:const Icon(Icons.search,color: Colors.teal,),
                          ),
                          IconButton(
                            onPressed: () {
                              GoRouter.of(context).go(Routes.notifcation);
                            },
                            icon: const Icon(
                              Icons.notifications_none_rounded,
                              color: Colors.teal,
                              size: 26,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      // Search bar
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // -------- Posts Section --------
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      PostCard(
                        name: "Jack sparrow",
                        role: "Front end developer",
                        text: "this is php code",
                        image:
                            "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg",
                      ),
                      const SizedBox(height: 8),
                      PostCard(
                        name: "Jack sparrow",
                        role: "Front end developer",
                        text: "this is php code",
                        image:
                            "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg",
                      ),
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
