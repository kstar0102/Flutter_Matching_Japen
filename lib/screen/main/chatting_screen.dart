
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matching_app/components/chat_bubble.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/screen/main/layouts/pined_chatting_header.dart';
import 'package:matching_app/screen/main/pay_screen.dart';
import 'package:matching_app/screen/main/profile_screen.dart';
import 'package:matching_app/utile/index.dart';
import 'package:matching_app/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matching_app/controller/auth_controllers.dart';
import 'package:intl/intl.dart';
import 'package:matching_app/screen/verify_screen/identity_verify.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:shared_preferences/shared_preferences.dart';
// ignore: use_key_in_widget_constructors
class ChattingScreen extends ConsumerStatefulWidget {
  final String receiverUserPhone;
  final String receiverUserToken;
  final String receiverUserId;
  final String receiverUserAvatar;
  final String receiverUserName;
  final String receiverUserBadgeName;
  final String receiverUserBadgeColor;
  final String senderUserId;
  final String tab_val;
  final String send_identy;
  final String address;
  final String age;
  final String payUser;
  const ChattingScreen({super.key, required this.receiverUserPhone, required this.receiverUserToken, required this.receiverUserId, required this.receiverUserAvatar, required this.receiverUserName, required this.receiverUserBadgeName, required this.receiverUserBadgeColor, required this.senderUserId, required this.tab_val, required this.send_identy, required this.address, required this.age,required this.payUser});
  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends ConsumerState<ChattingScreen>
    with WidgetsBindingObserver {

  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  ScrollController _scrollController = ScrollController();
  ScrollController _scrollController1 = ScrollController();
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;
  String? _uploadedImageUrl;
  bool isRead = false;
  String otherMessage = "";
  double screenHeight = 0;
  double keyboardHeight = 0;
  bool _isKeyboardVisible = false;
  bool dialogShown = false;
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_) {
      final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      if (this.mounted) {
        setState(() {
          this.keyboardHeight = keyboardHeight;
        });
      }
    });
    WidgetsBinding.instance.addObserver(this);
    _focusNode.addListener(_onFocusChange);
    //  _focusNode.addListener(() {
    //   setState(() {
    //     isRead = false;
    //     _onFocusChange;
    //   });
    // });
  }
  void sendMessage() async {
    print(widget.send_identy);

    // only send message if there is something to send
    if (widget.send_identy != "承認") {
        final AlertDialog dialog = AlertDialog(
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          actionsPadding: EdgeInsets.zero,
          actions: [
            Container(
                padding: const EdgeInsets.only(top: 10, left: 50, right: 50),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      disabledForegroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      textStyle: const TextStyle(fontSize: 15),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 13),
                      backgroundColor: BUTTON_MAIN),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => IdentityVerify()),
                    );
                  },
                  child: const Text('本人確認する'),
                )),
            Container(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 20, left: 50, right: 50),
                width: double.infinity,
                child: TextButton(
                  style: ElevatedButton.styleFrom(
                      disabledForegroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      textStyle: const TextStyle(fontSize: 15),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 13),
                      backgroundColor: Colors.transparent),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                  },
                  child: const Text('まだしない',
                      style: TextStyle(color: BUTTON_MAIN)),
                ))
          ],
          shape: roundedRectangleBorder,
          content: Container(
              padding: const EdgeInsets.only(
                  top: 20),
              height: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    "安心安全のため\n本人確認をしてください",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: PRIMARY_FONT_COLOR,
                        fontSize: 18,
                        letterSpacing: -2),
                  ),
                  Image(
                      width: vww(context, 40),
                      image: const AssetImage(
                          "assets/images/main/unidentified.png"))
                ],
        )));
      Future.delayed(const Duration(milliseconds: 1000), () {
        showDialog(context: context, builder: (context) => dialog, barrierDismissible: false,);
      });
       dialogShown = true;
       return;
    }
    if (!dialogShown && widget.payUser != "1") {
        final AlertDialog dialog = AlertDialog(
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          actionsPadding: EdgeInsets.zero,
          actions: [
            Container(
                padding: const EdgeInsets.only(top: 10, left: 50, right: 50),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      disabledForegroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      textStyle: const TextStyle(fontSize: 15),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 13),
                      backgroundColor: BUTTON_MAIN),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PayScreen()),
                    );
                  },
                  child: const Text('有料会員に登録する'),
                )),
            Container(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 20, left: 50, right: 50),
                width: double.infinity,
                child: TextButton(
                  style: ElevatedButton.styleFrom(
                      disabledForegroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      textStyle: const TextStyle(fontSize: 15),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 13),
                      backgroundColor: Colors.transparent),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                  },
                  child: const Text('まだしない',
                      style: TextStyle(color: BUTTON_MAIN)),
                ))
          ],
          shape: roundedRectangleBorder,
          content: Container(
              padding: const EdgeInsets.only(
                  top: 20),
              height: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    "ボード機能は\n有料会員登録が必要です。",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: PRIMARY_FONT_COLOR,
                        fontSize: 18,
                        letterSpacing: -2),
                  ),
                  Image(
                      width: vww(context, 100),
                      image: const AssetImage(
                          "assets/images/pay.png"))
                ],
        )));
      Future.delayed(const Duration(milliseconds: 1000), () {
        showDialog(context: context, builder: (context) => dialog, barrierDismissible: false,);
      });
       dialogShown = true;
       return;
    }
    else{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String myPhoneToken = await prefs.getString("Phone_token").toString();
    
      String msg = _messageController.text;
      _messageController.clear();
      if(msg.isNotEmpty) {
        String imageUrl = '';
        if (_uploadedImageUrl != null) {
          imageUrl = await _storeImageToFirebaseStorage(_uploadedImageUrl!);
        }
        print(widget.receiverUserToken+widget.senderUserId);
        final result = await _chatService.sendMessage(   
          widget.receiverUserToken, msg, myPhoneToken);
          // clear the text controller after sending the message
        setState(() {
          _uploadedImageUrl = null;
        });
      }
      DateTime currentTime = DateTime.now();
      String formattedTime = DateFormat('hh:mm').format(currentTime);
      final controller = ref.read(AuthProvider.notifier);
      controller.doChatting(widget.receiverUserId, widget.receiverUserToken, msg, formattedTime).then(
        (value) {
        },
      );
    }
  }

  Future<String?> _chooseImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
        String imageUrl = '';
        if (_uploadedImageUrl != null) {
          imageUrl = await _storeImageToFirebaseStorage(_uploadedImageUrl!);
        final result = await _chatService.sendMessage(   
          widget.receiverUserToken, imageUrl, widget.senderUserId);
          // clear the text controller after sending the message
        setState(() {
          _uploadedImageUrl = null;
        });
      }
      DateTime currentTime = DateTime.now();
      String formattedTime = DateFormat('hh:mm').format(currentTime);
      final controller = ref.read(AuthProvider.notifier);
      controller.doChatting(widget.receiverUserId, widget.receiverUserToken, imageUrl, formattedTime).then(
        (value) {
        },
      );
      return pickedFile.path;
    }
    return null;
  }

  Future<String> _storeImageToFirebaseStorage(String imagePath) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = _storage.ref().child('images/$fileName');
    final uploadTask = ref.putFile(File(imagePath));
    final snapshot = await uploadTask.whenComplete(() {});
    return await snapshot.ref.getDownloadURL();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {

      // Keyboard is displayed, so hide it
      // FocusScope.of(context).unfocus();
      isRead = true;
      final controller = ref.read(AuthProvider.notifier);
      controller.doMessage(widget.receiverUserId, widget.receiverUserToken).then(
        (value) {
        },
      );
    }
  }

  Future<bool> _onWillPop() async {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    String badge_name = widget.receiverUserBadgeName;
    List<String> numberArray = badge_name.split(",");
    List<String> badgeArray = widget.receiverUserBadgeColor.split(",");
    List<BadgeItemObject> badgeList = [];
    for (var i = 0; i < numberArray.length; i++) {
      badgeList.add(BadgeItemObject(i, numberArray[i], false, badgeArray[i]));
    }
    if (_isKeyboardVisible == true) {
      
    } else {
      screenHeight = MediaQuery.of(context).size.height;
      // keyboardHeight = 0;
    }
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: AppBar(
                elevation: 0,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                flexibleSpace:
                    FlexibleSpaceBar(background: PinedChattingHeader(
                        avatar: widget.receiverUserAvatar,
                        user_name: widget.receiverUserName,
                        user_id: widget.receiverUserId,
                        tab_v: widget.tab_val,
                        receiver_id: widget.receiverUserToken,
                        address: widget.address,
                        age: widget.age
                    )))),
        
        body: Stack(
          children: <Widget>[
          
          Container(
              padding: EdgeInsets.symmetric(horizontal: vww(context, 5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 330,
                    child: IntrinsicWidth(
                      child: Wrap(
                        spacing: 4,
                        runSpacing: 2,
                        direction: Axis.horizontal, // Set the wrapDirection to horizontal
                        children: badgeList.map((BadgeItemObject e) {
                          String textColor = e.color;
                          String textName = e.title;
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(width: 1, color: Color(int.parse(textColor.replaceAll('#', '0xFF'))),),
                              color: Color(int.parse(textColor.replaceAll('#', '0xFF'))).withOpacity(0.2)
                            ),
                            child: Text(
                              "${textName}",
                              style: TextStyle(fontSize: 12, color: Color(int.parse(textColor.replaceAll('#', '0xFF')))),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          // maxHeight: isKeyboardDisplayed? screenHeight - keyboardHeight:screenHeight - keyboardHeight - 250,
                          maxHeight: screenHeight - keyboardHeight,
                          minHeight: screenHeight - keyboardHeight - 250
                        ),
                        child: ListView(
                          controller: _scrollController1,
                          padding: EdgeInsets.all(16),
                          children: [
                            _buildMessageList(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: SingleChildScrollView(
                  //     controller: _scrollController,
                  //     child: ConstrainedBox(
                  //       constraints: BoxConstraints(
                  //         maxHeight: screenHeight - keyboardHeight,
                  //       ),
                  //       child:_buildMessageList(),
                  //     )
                  //   ),
                  // ),

                  const SizedBox(height: 25,)
                ],
              )),
            Divider(),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                decoration: const BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            color: Color.fromARGB(255, 193, 192, 201),
                            width: 0.5)),
                    color: Color.fromARGB(255, 230, 231, 234)),
                padding: const EdgeInsets.only(bottom: 5, top: 5),
                constraints: BoxConstraints(
                  minHeight: 30,
                  maxHeight: vhh(context, 20),
                ),
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt_rounded),
                              onPressed: () async {
                                final imagePath = await _chooseImage();
                                if (imagePath != null) {
                                  setState(() {
                                    _uploadedImageUrl = imagePath;
                                  });
                                }
                              },
                              color: const Color.fromARGB(255, 193, 192, 201),
                            )),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                        child:TextFormField(
                        maxLines: null,
                        controller: _messageController,
                        keyboardType: TextInputType.multiline,
                        focusNode: _focusNode,
                        textInputAction: TextInputAction.newline,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "メッセージを入力",
                          hintStyle: TextStyle(
                              color: Color.fromARGB(255, 193, 192, 201)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 193, 192, 201))),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 193, 192, 201)),
                          ),
                          contentPadding: EdgeInsets.all(10),
                        ),
                        onTap: () {
                          setState(() {
                            isRead = true;
                          });
                        },
                      ),
                    )),
                    Material(
                      color: Colors.transparent,
                      child: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () { sendMessage(); },
                        color: BUTTON_MAIN,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // build message list
  Widget _buildMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _chatService.getMessages(
        widget.receiverUserToken, widget.senderUserId),
      builder: (BuildContext  context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.hasError) {
          return Center(
            child: Text('Error${snapshot.error}'),
          );
        }

        if(snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

       if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
          final messages = snapshot.data!.docs;
          messages.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));
          
          // Reversing the list to get the messages in ascending order        
          return Container(
            alignment: Alignment.topCenter,
            child: const Text("ボード機能でマッチングしました",
                textAlign: TextAlign.center,
                style: TextStyle(color: BUTTON_MAIN)),
          );
        }

        WidgetsBinding.instance?.addPostFrameCallback((_) {
          // Scroll to the last position after the snapshot updates
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
            );
          }
        });

        WidgetsBinding.instance?.addPostFrameCallback((_) {
          // Scroll to the last position after the snapshot updates
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            _scrollController1.animateTo(
              _scrollController1.position.maxScrollExtent,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
            );
          }
        });

        return Container(
            child: Column(
            children: snapshot.data!.docs.map<Widget>((document) => _buildMessageItem(document)).toList(),
          )  
        );
      }
    );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    
    // align the messages to the right if the sender is the current user, otherwise to the left
    var alignment = (data['senderId'] == widget.senderUserId) 
      ? Alignment.centerRight: Alignment.centerLeft;

    var sendType = (data['senderId'] == widget.senderUserId) 
      ? true : false;
    otherMessage = data['message'];
    return Container(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.only(left: 1, right: 1),
          child: Column(
            crossAxisAlignment: (data['senderId'] == widget.senderUserId)? CrossAxisAlignment.end : CrossAxisAlignment.start,
            mainAxisAlignment: (data['senderId'] == widget.senderUserId)? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              const SizedBox(height: 15,),
              ChatBubble(message: data['message'], s_compare: sendType.toString(), time: data['timestamp'], read_val: isRead.toString(), iden: widget.send_identy),
            ],
          ),
        ),
    );
    
  }
}
