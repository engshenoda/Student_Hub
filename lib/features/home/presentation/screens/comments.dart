import 'package:flutter/material.dart';
import 'package:linkedin/features/home/presentation/widgets/comment_item.dart';
import '../widgets/comment_item.dart';
class Comments extends StatelessWidget {
  const Comments({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        
        child: Column(
          children: [
            CommentItem(
              imageUrl: 'https://www.bing.com/th/id/OIP.EzA6vF2nER9bJEh6o1EHZAHaI7?w=174&h=211&c=8&rs=1&qlt=90&o=6&cb=12&dpr=1.3&pid=3.1&rm=2',
              name: 'Jack sparrow',
              job: 'Front end developer',
              time: '4 days', 
              comment: 'kjhhkjbjbjhlvnm,v,nvjh,',
            ),
            divider(),
            CommentItem(
              imageUrl: 'https://www.bing.com/th/id/OIP.EzA6vF2nER9bJEh6o1EHZAHaI7?w=174&h=211&c=8&rs=1&qlt=90&o=6&cb=12&dpr=1.3&pid=3.1&rm=2',
              name: 'Jack sparrow',
              job: 'Front end developer',
              time: '4 days', 
              comment: 'kjh;kjhkljhjkbjbljb',
            ),
            divider(),
            CommentItem(
              imageUrl: 'https://www.bing.com/th/id/OIP.EzA6vF2nER9bJEh6o1EHZAHaI7?w=174&h=211&c=8&rs=1&qlt=90&o=6&cb=12&dpr=1.3&pid=3.1&rm=2',
              name: 'Mera Mourad',
              job: 'UI / UX Designer',
              time: 'Now',
               comment: 'kjb;kjb;jkbjbj',
            ),
            divider(),
            CommentItem(
              imageUrl: 'https://www.bing.com/th/id/OIP.EzA6vF2nER9bJEh6o1EHZAHaI7?w=174&h=211&c=8&rs=1&qlt=90&o=6&cb=12&dpr=1.3&pid=3.1&rm=2',
              name: 'Jack sparrow',
              job: 'Front end developer',
              time: '4 days',
               comment: 'kjn;kjb;kjbjkbjbjb',
            ),
                divider(),
            CommentItem(
              imageUrl: 'https://www.bing.com/th/id/OIP.EzA6vF2nER9bJEh6o1EHZAHaI7?w=174&h=211&c=8&rs=1&qlt=90&o=6&cb=12&dpr=1.3&pid=3.1&rm=2',
              name: 'Jack sparrow',
              job: 'Front end developer',
              time: '4 days',
               comment: 'kjn;kjb;kjbjkbjbjb',
            ),
                divider(),
            CommentItem(
              imageUrl: 'https://www.bing.com/th/id/OIP.EzA6vF2nER9bJEh6o1EHZAHaI7?w=174&h=211&c=8&rs=1&qlt=90&o=6&cb=12&dpr=1.3&pid=3.1&rm=2',
              name: 'Jack sparrow',
              job: 'Front end developer',
              time: '4 days',
               comment: 'kjn;kjb;kjbjkbjbjb',
            ),
                divider(),
            CommentItem(
              imageUrl: 'https://www.bing.com/th/id/OIP.EzA6vF2nER9bJEh6o1EHZAHaI7?w=174&h=211&c=8&rs=1&qlt=90&o=6&cb=12&dpr=1.3&pid=3.1&rm=2',
              name: 'Jack sparrow',
              job: 'Front end developer',
              time: '4 days',
               comment: 'kjn;kjb;kjbjkbjbjb',
            ),
          ],
        ),
      ),
    );
  }


  Widget divider() => const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Divider(thickness: 1.2, color: Colors.black12),
      );
}