import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ChatUser currentUser = ChatUser(id: '0', firstName: 'User');
  ChatUser geminiUser = ChatUser(
    id: '1',
    firstName: 'Syntrix Ai',
    profileImage:
        'https://imgs.search.brave.com/Cj9QNSCWOrOujg9k7qiHHyfKP_lMGfmhCTNVHhbrroo/rs:fit:500:0:0:0/g:ce/aHR0cHM6Ly9pbWcu/ZnJlZXBpay5jb20v/cHJlbWl1bS1waG90/by9yb2JvdC1yZXBy/ZXNlbnRhdGlvbi1m/dXR1cmlzdGljLXRl/Y2hub2xvZ3lfNTM4/NzYtODkxMTExLmpw/Zz9zZW10PWFpc19o/eWJyaWQmdz03NDA',
  );
  List<ChatMessage> messages = [];

  final Gemini gemini = Gemini.instance;
  final _chatController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF9C27B0),  // Deep purple
                Color(0xFF673AB7),  // Purple
                Color.fromARGB(255, 78, 101, 227),  // Indigo
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        title: const Text('Syntrix Ai', style: TextStyle(color: Colors.white)),
      ),
      backgroundColor: Colors.white,
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return DashChat(
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
      messageOptions: MessageOptions(
        currentUserContainerColor: Colors.deepPurpleAccent,
        // containerColor: Color(0xFF673AB7).withOpacity(0.7),
      ),
      // inputOptions: InputOptions(
      //   inputDecoration: InputDecoration(
      //     hintText: 'Type a message...',
      //     border: OutlineInputBorder(
      //       borderRadius: BorderRadius.circular(25),
      //       borderSide: BorderSide(color: Color(0xFF9C27B0)),
      //     ),
      //     enabledBorder: OutlineInputBorder(
      //       borderRadius: BorderRadius.circular(25),
      //       borderSide: BorderSide(color: Color(0xFF9C27B0)),
      //     ),
      //     focusedBorder: OutlineInputBorder(
      //       borderRadius: BorderRadius.circular(25),
      //       borderSide: BorderSide(color: Color(0xFF3F51B5), width: 2),
      //     ),
      //   ),
      // ),
    );
  }

  Future<void> _sendMessage(ChatMessage chatMessage) async {
    setState(() {
      messages = [chatMessage, ...messages];
    });
    try {
      String question = chatMessage.text;
      StringBuffer buffer = StringBuffer();
      // Only handle text for now
      gemini
          .promptStream(parts: [TextPart(question)])
          .listen(
            (event) {
              for (var part in event?.content?.parts ?? []) {
                if (part is TextPart) buffer.write(part.text);
              }
            },
            onDone: () {
              String response = buffer.toString();
              ChatMessage message = ChatMessage(
                user: geminiUser,
                createdAt: DateTime.now(),
                text: response,
              );
              setState(() {
                messages = [message, ...messages];
              });
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_chatController.hasClients) {
                  _chatController.jumpTo(
                    _chatController.position.maxScrollExtent,
                  );
                }
              });
            },
          );
    } catch (e) {
      print(e);
    }
  }
}
