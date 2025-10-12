

import 'package:flutter/material.dart';

import 'package:linkedin/core/constants/constants.dart';
import 'package:linkedin/features/chat/data/models.dart';
import 'package:linkedin/features/chat/Presentation/widget/chat_screen.dart';



class MessageBubble extends StatelessWidget {
  final Message message;
  final ChatModel chatModel;

  const MessageBubble({
    super.key,
    required this.message,
    required this.chatModel,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMe = message.isMe;

   
    final Color bubbleColor = isMe ? kDarkTeal : kLightGreen.withOpacity(0.7);
    final Color textColor = isMe ? Colors.white : Colors.black87;
    
  
    final Gradient? gradient = isMe
        ? const LinearGradient(
            colors: [kTealAccent, kDarkTeal],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
          
              if (!isMe)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, bottom: 10.0),
                  child: CircleAvatar(
                    radius: 15,
                    backgroundImage: NetworkImage(chatModel.avatarUrl),
                  ),
                ),
              
           
              Flexible(
                child: Container(
                  margin: EdgeInsets.only(
                    top: 6.0,
                    bottom: 6.0,
                    left: isMe ? 50.0 : 0,
                    right: isMe ? 0 : 50.0,
                  ),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: gradient == null ? bubbleColor : null,
                    gradient: gradient, // Apply gradient for 'isMe' messages
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(15.0),
                      topRight: const Radius.circular(15.0),
                      // Conditional radius for the 'tail' effect
                      bottomLeft: isMe
                          ? const Radius.circular(15.0)
                          : const Radius.circular(5.0),
                      bottomRight: isMe
                          ? const Radius.circular(5.0)
                          : const Radius.circular(15.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16.0,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              
              
              if (isMe)
                const Padding(
                  padding: EdgeInsets.only(left: 8.0, bottom: 10.0),
                  child: CircleAvatar(
                    radius: 15,
                  ),
                ),
            ],
          ),
          
   
          Padding(
            padding: EdgeInsets.only(
              left: isMe ? 0 : 45.0, 
              right: isMe ? 10.0 : 0,
            ),
            child: Text(
              message.time,
              style: TextStyle(color: Colors.grey[500], fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}