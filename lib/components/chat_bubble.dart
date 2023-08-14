import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ChatBubble extends StatelessWidget {
  final String message;
  final String s_compare;
  final Timestamp time;
  final String read_val;
  const ChatBubble({super.key, required this.message, required this.s_compare, required this.time, required this.read_val});
  
  @override
  Widget build(BuildContext context) {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time.seconds * 1000);
      String formattedTime =
          '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      String lastMessage;
      Widget TextPanel = s_compare == "true"
      ? Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(formattedTime, style: TextStyle(color: Colors.grey[500]),),
            ),
          ),
          
          SizedBox(width: 3,),
          Container(
            width: (message.length > 30) ? 180 : null,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromARGB(255, 0, 202, 157),
            ),
            child: message.contains('https://firebasestorage.googleapis.com/v0/b/')
            ? Image.network(message)
            : Text(
                message,
                style: const TextStyle(fontSize: 16, color: Colors.white),
                maxLines: 20,
                overflow: TextOverflow.ellipsis,
              ),
          ),
        ],
      )
      : Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: (message.length > 30) ? 180 : null,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:  Colors.grey[300]
              ),
              child: message.contains('https://firebasestorage.googleapis.com/v0/b/')
              ? Image.network(message)
              : Text(
                  message,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  maxLines: 20,
                  overflow: TextOverflow.ellipsis,
                ),
            ),
            SizedBox(width: 3,),
            Align(
              alignment: Alignment.topCenter,
              child: Text(formattedTime, style: TextStyle(color: Colors.grey[500]),),
            ),
          ],
        );
      lastMessage = message;
    return TextPanel;
  }
}