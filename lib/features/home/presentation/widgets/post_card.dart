import 'package:flutter/material.dart';
import 'package:linkedin/features/home/presentation/screens/comments.dart';
import 'package:linkedin/features/home/presentation/screens/repost.dart';

class PostCard extends StatefulWidget {
  final String name;
  final String role;
  final String text;
  final String image;

   PostCard({
    super.key,
   required this.name,
    required this.role,
    required this.text,
    required this.image, 
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isfollowing=true ;

  String  unFollow ="Unfollow" ;

  @override
  Widget build(BuildContext context) {
    
 
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                    style: TextStyle(fontSize: 11, color: Colors.teal[800]),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
               IconButton(onPressed: (){}, icon:Icon(Icons.thumb_up_alt_outlined),color: Colors.teal[800]),
              IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Comments()));
              }, icon:Icon(Icons.comment_outlined),color: Colors.teal[800]),
              IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Repost()));
              }, icon:Icon(Icons.swap_horiz_outlined),color: Colors.teal[800]),
              IconButton(onPressed: (){}, icon:Icon(Icons.send_outlined),color: Colors.teal[800]),
            ],
          ),
        ],
      ),
    );
  }
}

      
      
     
