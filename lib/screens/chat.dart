import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swipebuttonflutter/swipebuttonflutter.dart';

class Chat extends StatefulWidget {
  String kImage;
  String kName;

  Chat({this.kImage, this.kName});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();

  AnimationController _animationController;
  Animation _animation;
  String _forwardText = '> > > >';

  // final ChatUser otherUser = ChatUser(
  //   name: "Fayeed",
  //   uid: "123456789",
  //   avatar: "https://www.wrappixel.com/ampleadmin/assets/images/users/4.jpg",
  // );
  //
  // final ChatUser user = ChatUser(
  //   name: "Mrfatty",
  //   uid: "25649654",
  // );

  List<ChatMessage> messages = List<ChatMessage>();
  var m = List<ChatMessage>();

  var i = 0;
  bool isActiveUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isActiveUser = true;
    _animationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    _animation = IntTween(begin: 100, end: 0).animate(_animationController);
    _animation.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  void systemMessage() {
    Timer(Duration(milliseconds: 300), () {
      if (i < 6) {
        setState(() {
          messages = [...messages, m[i]];
        });
        i++;
      }
      Timer(Duration(milliseconds: 300), () {
        _chatViewKey.currentState.scrollController
          ..animateTo(
            _chatViewKey.currentState.scrollController.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
      });
    });
  }

  void onSend(ChatMessage message) async {
    print(message.toJson());
    var documentReference = Firestore.instance
        .collection('messages')
        .document(DateTime.now().millisecondsSinceEpoch.toString());

    await Firestore.instance.runTransaction((transaction) async {
      await transaction.set(
        documentReference,
        message.toJson(),
      );
    });
     setState(() {
      messages = [...messages, message];
      print(messages.length);
    });

    /*if (i == 0) {
      systemMessage();
      Timer(Duration(milliseconds: 600), () {
        systemMessage();
      });
    } else {
      systemMessage();
    }*/
  }

  @override
  Widget build(BuildContext context) {
    final ChatUser user = ChatUser(
      name: widget.kName,
      firstName: widget.kName,
      lastName: widget.kName,
      uid: "12345678",
      avatar: widget.kImage,
    );

    final ChatUser otherUser = ChatUser(
      name: widget.kName,
      uid: "25649654",
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFF568FE7),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
        title: Text(
          widget.kName,
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              widget.kImage,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: AppBar().preferredSize.height,
              decoration: BoxDecoration(
                color: Color(0xFF568FE7),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(
                    20,
                  ),
                  topLeft: Radius.circular(
                    20,
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20,top:8,bottom: 8,),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Icon(
                                Icons.account_circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: messages.length==0?false:true,
                        child: Visibility(
                          visible: isActiveUser?true:false,
                          child: Positioned(
                            top:6,
                            left: 15,
                            child: Container(
                              width:15,
                              height:15,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade300,
                              ),
                              child: Center(child: Text(messages.length.toString(),style: TextStyle(color: Color(0xFF568FE7),fontSize: 10,fontWeight: FontWeight.w500,),)),
                              // child: CircleAvatar(
                              //   backgroundColor: Colors.white,
                              //   child: Center(
                              //     child: Text(
                              //       messages.length.toString(),
                              //     ),
                              //   ),
                              // ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    flex: 100,
                    child: OutlineButton(
                      disabledBorderColor: Color(0xFF568FE7),
                      child: GestureDetector(
                        onTap: () {
                          if (_animationController.value == 0.0) {
                            setState(() {
                              isActiveUser = !isActiveUser;
                              _forwardText = '< < < < ';
                            });
                            _animationController.forward();
                          } else {
                            isActiveUser = !isActiveUser;
                            _animationController.reverse();
                            _forwardText = '> > > > ';
                          }
                        },
                        child: Text(
                          _forwardText,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 40.0),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: _animation.value,
                    // Uses to hide widget when flex is going to 0
                    child: SizedBox(
                      width: 0.0,
                      child: OutlineButton(
                        disabledBorderColor: Color(0xFF568FE7),
                        borderSide: BorderSide(color: Color(0xFF568FE7)),
                        child: FittedBox(
                          //Add this
                          child: Text(
                            'hi',
                            style: TextStyle(color: Color(0xFF568FE7)),
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right:15,top:8,bottom: 8,),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Icon(
                                Icons.account_circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: messages.length==0?false:true,
                        child: Visibility(
                          visible: isActiveUser?false:true,
                          child: Positioned(
                            top:6,
                            right: 10,
                            child: Container(
                              width:15,
                              height:15,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade300,
                              ),
                              child: Center(child: Text(messages.length.toString(),style: TextStyle(color: Color(0xFF568FE7),fontSize: 10,fontWeight: FontWeight.w500,),)),
                              // child: CircleAvatar(
                              //   backgroundColor: Colors.white,
                              //   child: Center(
                              //     child: Text(
                              //       messages.length.toString(),
                              //     ),
                              //   ),
                              // ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              bottom: 50,
            ),
            child: StreamBuilder(
                stream: Firestore.instance.collection('messages').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    );
                  } else {
                    List<DocumentSnapshot> items = snapshot.data.documents;
                    var messages =
                        items.map((i) => ChatMessage.fromJson(i.data)).toList();
                    return Theme(
                      data: ThemeData(
                          accentColor: Color(0XFF5C95E0),
                          iconTheme: IconThemeData(
                            color: Colors.white,
                          )),
                      child: DashChat(
                        key: _chatViewKey,
                        inverted: false,
                        onSend: onSend,
                        sendOnEnter: true,
                        textInputAction: TextInputAction.send,
                        user: isActiveUser ? user : otherUser,
                        inputDecoration:
                            /*InputDecoration(
                          hintText: 'Type a message',
                          hintStyle: TextStyle(color: Colors.white)
                          // border: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(10,)
                          // )

                        ),*/
                            InputDecoration.collapsed(
                                hintText: "Type a message",
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                )),
                        dateFormat: DateFormat('yyyy-MMM-dd'),
                        timeFormat: DateFormat('HH:mm'),
                        messages: messages,
                        showUserAvatar: false,
                        showAvatarForEveryMessage: false,
                        scrollToBottom: false,
                        onPressAvatar: (ChatUser user) {
                          print("OnPressAvatar: ${user.name}");
                        },
                        onLongPressAvatar: (ChatUser user) {
                          print("OnLongPressAvatar: ${user.name}");
                        },
                        inputMaxLines: 5,
                        messageContainerPadding:
                            EdgeInsets.only(left: 5.0, right: 5.0),
                        alwaysShowSend: true,
                        inputCursorColor: Colors.white,
                        inputTextStyle:
                            TextStyle(fontSize: 16.0, color: Colors.white),
                        inputToolbarMargin: EdgeInsets.all(10.0),
                        inputContainerStyle: BoxDecoration(
                          border:
                              Border.all(width: 0.0, color: Color(0XFF5C95E0)),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          color: Color(0XFF5C95E0),
                        ),
                        onQuickReply: (Reply reply) {
                          setState(() {
                            messages.add(ChatMessage(
                              text: reply.value,
                              createdAt: DateTime.now(),
                              user: user,
                            ));

                            messages = [...messages];
                          });

                          Timer(Duration(milliseconds: 300), () {
                            _chatViewKey.currentState.scrollController
                              ..animateTo(
                                _chatViewKey.currentState.scrollController
                                    .position.maxScrollExtent,
                                curve: Curves.easeOut,
                                duration: const Duration(milliseconds: 300),
                              );

                            if (i == 0) {
                              systemMessage();
                              Timer(Duration(milliseconds: 600), () {
                                systemMessage();
                              });
                            } else {
                              systemMessage();
                            }
                          });
                        },
                        onLoadEarlier: () {
                          print("laoding...");
                        },
                        shouldShowLoadEarlier: false,
                        showTraillingBeforeSend: true,
                        trailing: <Widget>[
                          // IconButton(
                          //   icon: Icon(Icons.photo),
                          //   onPressed: () async {
                          //     File result = await ImagePicker.pickImage(
                          //       source: ImageSource.gallery,
                          //       imageQuality: 80,
                          //       maxHeight: 400,
                          //       maxWidth: 400,
                          //     );
                          //
                          //     if (result != null) {
                          //       final StorageReference storageRef =
                          //           FirebaseStorage.instance.ref().child("chat_images");
                          //
                          //       StorageUploadTask uploadTask = storageRef.putFile(
                          //         result,
                          //         StorageMetadata(
                          //           contentType: 'image/jpg',
                          //         ),
                          //       );
                          //       StorageTaskSnapshot download =
                          //           await uploadTask.onComplete;
                          //
                          //       String url = await download.ref.getDownloadURL();
                          //
                          //       ChatMessage message =
                          //           ChatMessage(text: "", user: user, image: url);
                          //
                          //       var documentReference = Firestore.instance
                          //           .collection('messages')
                          //           .document(DateTime.now()
                          //               .millisecondsSinceEpoch
                          //               .toString());
                          //
                          //       Firestore.instance.runTransaction((transaction) async {
                          //         await transaction.set(
                          //           documentReference,
                          //           message.toJson(),
                          //         );
                          //       });
                          //     }
                          //   },
                          // )
                        ],
                      ),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}
