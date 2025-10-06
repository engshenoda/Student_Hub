import 'package:flutter/material.dart';

class CommentItem extends StatelessWidget {
final String imageUrl ;
  final String name;
  final String job;
  final String time;
   final String comment;

  const CommentItem({super.key, required this.imageUrl, required this.name, required this.job, required this.time, required this.comment});


  @override
  Widget build(BuildContext context) {
    
 {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 22,
          backgroundImage: NetworkImage(imageUrl),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style:  TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.teal[800],
                        ),
                      ),
                      Text(
                        job,
                        style:  TextStyle(
                          fontSize: 10,
                          color: Colors.teal[800],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    time,
                    style:  TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
               SizedBox(height: 6),
              Text(
                '$comment',
                style:  TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
               SizedBox(height: 6),
              Row(
                children:  [
                  Icon(Icons.thumb_up_alt_outlined, size: 18,color: Colors.teal[800],),
                  SizedBox(width: 4),
                  Text('Like', style: TextStyle(fontSize: 13)),
                  SizedBox(width: 20),
                  Icon(Icons.chat_bubble_outline, size: 18,color: Colors.teal[800],),
                  SizedBox(width: 4),
                  Text('Respond', style: TextStyle(fontSize: 13)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  };
  }
}