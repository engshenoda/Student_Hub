import 'package:flutter/material.dart';
import 'package:linkedin/features/home/presentation/widgets/post_card_repost.dart';

class Repost extends StatelessWidget {
  const Repost({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // -------- Header Section --------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.cancel_outlined,size:40,color: Colors.teal),
                      ),
                    ],
                  ),

                  SizedBox(height: 25),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 16,right: 16),
              child: Column(
                children: [
                  Container(
                    child: Row(
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
                                color: Colors.teal[800]
                              ),
                            ),
                            Text(
                              "UI / UX Designer",
                              style: TextStyle( fontSize: 11,color: Colors.teal[800]),
                            ),
                          ],
                        ),
                        SizedBox(width: 210,),
                          ElevatedButton(
                              onPressed: () {
                                
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF004D40), // أخضر داكن جداً
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Post',
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ),
                      ],
                      
                      
                    ),
                  ),
                   SizedBox(height: 20,),
                   Row(
                     children: [
                       Text("Share your thoughts",style: TextStyle(color: Colors.grey,
                                         fontSize: 12,
                       )),
                     ],
                   ),
                   SizedBox(height: 20,),
   PostCardRepost(
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
    );
  }
}
