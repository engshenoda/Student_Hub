import 'package:flutter/material.dart';
import 'package:linkedin/features/home/presentation/screens/comments.dart';

class PostCardRepost extends StatefulWidget {
  final String name;
  final String role;
  final String text;
  final String image;

   PostCardRepost({
    super.key,
   required this.name,
    required this.role,
    required this.text,
    required this.image, 
  });

  @override
  State<PostCardRepost> createState() => _PostCardState();
}

class _PostCardState extends State<PostCardRepost> {
  bool isfollowing=true ;

  String  unFollow ="Unfollow" ;

  @override
  Widget build(BuildContext context) {
    
 
    return Container(
      
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?img=12'),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14,color: Colors.teal[800]),
                  ),
                  Text(
                    widget.role,
                    style: TextStyle(fontSize: 10, color: Colors.teal[800],),
                  ),
                ],
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                
                    setState(() {
                        isfollowing=!isfollowing ;
                    });
                   
                    
                 
                  }
                
                ,
                child: Text(isfollowing? "Unfollow":"Follow"
                 ,
                  style: TextStyle(color: Colors.teal[800], fontSize: 13),
                ),
              ),
              Icon(Icons.person_add_alt_1_outlined,
                  size: 18, color: Colors.teal[800]),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            widget.text,
            style: TextStyle(fontSize: 13.5,color: Colors.teal[800]),
          ),

          const SizedBox(height: 6),

          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(widget.image),
          ),

          const SizedBox(height: 6),

          // Bottom icons
        
        ],
      ),
    );
  }
}

      
      
     
