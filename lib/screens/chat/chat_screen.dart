import 'package:flutter/material.dart';
import 'package:myapp/widgets/chat/her_message_bubble.dart';
import 'package:myapp/widgets/chat/my_message_bubble.dart';
import 'package:myapp/widgets/shared/message_field_box.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              'https://i.iheart.com/v3/catalog/artist/36640?ops=fit(480%2C480)%2Crun(%22circle%22)',
            ),
          ),
        ),
        title: Text('Shakira'),
        centerTitle: false,
      ),
      body: _ChatView(),
    );
  }
}

class _ChatView extends StatelessWidget {
  const _ChatView({Key? key}) : super(key: key);

  @override
  // Suggested code may be subject to a license. Learn more: ~LicenseLog:1806029919.
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return HerMessageBubble();
                },
              ),
            ),
            MessageFieldBox(),
          ],
        ),
      ),
    );
  }
}
