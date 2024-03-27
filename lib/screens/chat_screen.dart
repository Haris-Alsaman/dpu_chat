import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ChatScreen extends StatefulWidget {
  static const String screenRoute = 'chat_screen';

  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  late User signedInUser;
  final gemini = Gemini.instance;
  List<String> messages = [];
  int messageCount = 0;
  String messageText = '';

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedInUser = user;
        print(signedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // folating action button false
  
      appBar: AppBar(
        leading: Container(),
        backgroundColor: Colors.yellow[900],
        title: Row(
          children: [
            Image.asset('images/logo.png', height: 25),
            SizedBox(width: 10),
            Text('DPU Chat', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // show a dialog to confirm sign out
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Sign out'),
                    content: Text('Are you sure you want to sign out?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          _auth.signOut();
                        
                          Navigator.popUntil(context, ModalRoute.withName('/'));
                        },
                        child: Text('Sign out'),
                      ),
                    ],
                  );
                },
              );
              // _auth.signOut();
              // Navigator.pop(context);
            },
            icon: Icon(Icons.close),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Builder(builder: (context) {
              if (messages.isNotEmpty) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: EdgeInsets.all(6),
                          // constraints : BoxConstraints.expand(),
                          decoration: BoxDecoration(
                            color: index % 2 == 0 ? Colors.orange[100] : Colors.blue[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            messages[index],
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return Expanded(
                  child: Center(
                    child: Text(
                      'No messages yet',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                );
              }
            }),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.orange,
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        hintText: 'Write your message here...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (messages.length % 2 == 0) {
                        setState(() {
                          messages.add(messageText);
                          messageCount++;
                        });

                        await gemini.text(messageText).then((value) {
                          setState(() {
                            messages.add(value?.output ?? 'Try again later');
                            messageCount++;
                          });
                          print(value?.output);
                        })

                            /// or value?.content?.parts?.last.text
                            .catchError((e) {
                          setState(() {
                            messages.add('Try again later');
                            messageCount++;
                          });
                          print(e);
                        });
                      } else {
                        // showSnackBar(context, 'You can only send a message after receiving a response');

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'You can only send a message after receiving a response'),
                          ),
                        );
                      }
                    },
                    child: Text(
                      'send',
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
