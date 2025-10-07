import 'package:flutter/material.dart';

const Color kLightGreen = Color(0xFFE0F7FA);
const Color kDarkTeal = Color(0xFF00897B);
const Color kTealAccent = Color(0xFF4DB6AC);

class Message {
  final String text;
  final bool isMe;
  final String time;

  Message({required this.text, required this.isMe, required this.time});
}

final List<Message> dummyMessages = [
  Message(
    text: "Hi, I'm looking for a soft, long-lasting perfume. Something feminine but not too strong.",
    isMe: true,
    time: "6:30 PM",
  ),
  Message(
    text: "Hi How Are You ?",
    isMe: false,
    time: "6:30 PM",
  ),
  Message(
    text: "Mostly floral and fruity. Something light for daytime wear.",
    isMe: true,
    time: "6:30 PM",
  ),
  Message(
    text: "Great choice! Here are 3 perfumes that match your style. Would you like to see pictures?",
    isMe: false,
    time: "6:30 PM",
  ),
];

class ChatScreen extends StatelessWidget {
  final ChatModel chatModel;

  const ChatScreen({super.key, required this.chatModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
     
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [kLightGreen, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 1.0],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
       
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kDarkTeal),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(chatModel.avatarUrl),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chatModel.name,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kDarkTeal),
                ),
                Text(
                  chatModel.subtitle,
                  style: TextStyle(fontSize: 12, color: kDarkTeal.withOpacity(0.8)),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: kDarkTeal),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
              reverse: true,
              itemCount: dummyMessages.length,
              itemBuilder: (context, index) {
                final message = dummyMessages[dummyMessages.length - 1 - index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          
          _buildMessageInput(),
        ],
      ),
    );
  }


  Widget _buildMessageBubble(Message message) {
    final bool isMe = message.isMe;

    final Gradient? gradient = isMe
        ? const LinearGradient(
            colors: [kTealAccent, kDarkTeal],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : null;

    final Color bubbleColor = isMe ? kDarkTeal : kLightGreen.withOpacity(0.7);
    final Color textColor = isMe ? Colors.white : Colors.black87;

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
                    gradient: gradient,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(15.0),
                      topRight: const Radius.circular(15.0),
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
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              message.time,
              style: TextStyle(color: Colors.grey[500], fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

 
  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1.0)),
      ),
      child: Row(
        children: [
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Message',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: kDarkTeal),
            onPressed: () {
            
            },
          ),
        ],
      ),
    );
  }
}








void main() {
  runApp(const ChatAppClone());
}

class ChatAppClone extends StatelessWidget {
  const ChatAppClone({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat ',
      theme: ThemeData(
        primaryColor: kDarkTeal,
        colorScheme: ColorScheme.fromSeed(seedColor: kDarkTeal),
        useMaterial3: true,
      ),
      home: const ChatsListScreen(),
    );
  }
}


class ChatModel {
  final String avatarUrl;
  final String name;
  final String subtitle;
  final String date;

  ChatModel({
    required this.avatarUrl,
    required this.name,
    required this.subtitle,
    required this.date,
  });
}


final List<ChatModel> dummyChats = [
 

  ChatModel(
    avatarUrl: 'https://placehold.co/100x100/43a047/ffffff/png?text=KF', 
    name: 'Khaled Farouk', 
    subtitle: 'Sales Representative',
    date: '10 May 2025',
  ),
  ChatModel(
    avatarUrl: 'https://placehold.co/100x100/ffb300/ffffff/png?text=SJ', 
    name: 'Sarah Jones', 
    subtitle: 'Freelance Writer', 
    date: '09 May 2025',
  ),
  ChatModel(
    avatarUrl: 'https://placehold.co/100x100/f4511e/ffffff/png?text=MR',   
    name: 'Michael Rivas', 
    subtitle: 'Project Manager',   
    date: '08 May 2025',
  ),
  ChatModel(
    avatarUrl: 'https://placehold.co/100x100/7cb342/ffffff/png?text=HA',   
    name: 'Huda Alali', 
    subtitle: 'Teacher',  
    date: '07 May 2025',
  ),
  ChatModel(
    avatarUrl: 'https://placehold.co/100x100/5e35b1/ffffff/png?text=DL',   
    name: 'David Lee', 
    subtitle: 'Data Analyst',    
    date: '06 May 2025',
  ),
  ChatModel(
    avatarUrl: 'https://placehold.co/100x100/039be5/ffffff/png?text=ZE',    
    name: 'Zainab Emad', 
    subtitle: 'UX Designer',     
    date: '05 May 2025',
  ),
  ChatModel(
    avatarUrl: 'https://placehold.co/100x100/c0ca33/ffffff/png?text=AS',   
    name: 'Adam Smith', 
    subtitle: 'Student',  
    date: '04 May 2025',
  ),
];

class ChatsListScreen extends StatelessWidget {
  const ChatsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(130.0), 
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [kLightGreen, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 1.0],
              ),
            ),
            padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Chats',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: kDarkTeal,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: kDarkTeal),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 10),
               
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: dummyChats.length,
        itemBuilder: (context, index) {
          final chat = dummyChats[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(chat.avatarUrl),
            ),
            title: Text(
              chat.name,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            subtitle: Text(
              chat.subtitle,
              style: TextStyle(color: Colors.grey[600]),
            ),
            trailing: Text(
              chat.date,
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
            onTap: () {
              
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(chatModel: chat),
                ),
              );
            },
          );
        },
      ),
    );
  }
}