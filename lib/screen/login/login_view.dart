import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:matching_app/common.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matching_app/components/radius_button.dart';
import 'package:matching_app/screen/login/layouts/header.dart';
import 'package:matching_app/utile/index.dart';
import 'package:matching_app/bloc/cubit.dart';
import 'package:matching_app/controller/auth_controllers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: use_key_in_widget_constructors
class LoginView extends ConsumerStatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  String phone_number = "";
  
  String digits = "";
  FirebaseAuth auth = FirebaseAuth.instance;

  String verificationIDReceived = "";
  final verify_code = TextEditingController();
  bool otpCodeVisible = false;
  bool isLoading = false;
  bool isShow = true;
  //send sms code in use firebase otp

  Future<void> verifyUserPhoneNumber () async
  {
    isShow = true;
    if(isLoading != true){
      Timer(Duration(seconds: 60), () {
        setState(() {
          isLoading = false;
          isShow = false;
        });
      });
    }
    
    setState(() {
      isLoading = true; // Start the loading indicator
    });
    await auth.verifyPhoneNumber(
      phoneNumber: "+"+phone_number,
      verificationCompleted: (PhoneAuthCredential credential) async{
        await auth.signInWithCredential(credential).then((value){
          print("You are logged in successfully");
        });
      }, 
      verificationFailed: (FirebaseAuthException exception){
        print(exception.message);
      }, 
      codeSent: (String verificationID, int? resendToken) async{
        print("OkOk!");
        verificationIDReceived = verificationID;
        otpCodeVisible = true;
        isShow =true;
        setState(() {
          isLoading = false; // Stop the loading indicator
        });
      }, 
      codeAutoRetrievalTimeout: (String verificationId) {
        
      });
  }

  void verifyCode() async {
    digits = verify_code.text;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationIDReceived,
        smsCode: digits);

    try {
      final authResult = await auth.signInWithCredential(credential);
        // Success: User signed in with the provided SMS code
        Fluttertoast.showToast(
          msg: "Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
        );
        firebaseChecked();
    } catch (error) {
      print("Error: Invalid SMS code");
      // Error: An error occurred during verificationz
      Fluttertoast.showToast(
        msg: "Verification failed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  //save phone number in fireabse data 
  void firebaseChecked() async {
    AppCubit appCubit = AppCubit.get(context);

    try {
      // Get the current user from FirebaseAuth
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String userId = user.uid;

        // Check if the phone number is already registered
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('phone', isEqualTo: phone_number)
            .limit(1)
            .get();
        bool phoneNumberExists = querySnapshot.docs.isNotEmpty;

        if (phoneNumberExists) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Warning'),
                content: Text('Phone number already registered.'),
                actions: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          // Store the phone number in Firestore under the user's document
          await FirebaseFirestore.instance.collection('users').doc(userId).set({'phone': phone_number});

          // Retrieve the user ID
          DocumentSnapshot snapshot =
              await FirebaseFirestore.instance.collection('users').doc(userId).get();
          String? fetchedUserId = snapshot.id;

          // Add phone directly to the database and retrieve the ID
          DocumentReference docRef = await FirebaseFirestore.instance.collection('users').add({'phone': phone_number});
          String addedDocumentId = docRef.id;
          
          appCubit.phoneToken(phone_number, addedDocumentId);
          
          print('Phone number stored in Firestore with user ID: $fetchedUserId');

          Navigator.pushNamed(context, "/terms_agree");
        }
      } else {
        // Check if the phone number is already registered
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('phone', isEqualTo: phone_number)
            .limit(1)
            .get();
        bool phoneNumberExists = querySnapshot.docs.isNotEmpty;

        if (phoneNumberExists) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('警告'),
                content: Text('電話番号はすでに登録されています。'),
                actions: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
          return;
        }
        // Add phone directly to the database and retrieve the ID
        DocumentReference docRef = await FirebaseFirestore.instance.collection('users').add({'phone': phone_number});
        String addedDocumentId = docRef.id;
        
        appCubit.phoneToken(phone_number, addedDocumentId);
        
        print('Phone number added to Firestore with document ID: $addedDocumentId');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget phone_show = otpCodeVisible?
      Padding(
        padding:
            EdgeInsets.only(bottom: 0, left: 20),
        child: Row(
          children: [
            SvgPicture.asset("assets/images/svg/dot.svg",
                semanticsLabel: "dot", width: 15, height: 15),
            Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                    style: TextStyle(
                        fontSize: 17, color: PRIMARY_FONT_COLOR),
                    "${phone_number}"))
          ],
        )):Container();
   
    Widget phone_input = otpCodeVisible == false ? 
     Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20),
        child: TextField(
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 27),
          // , letterSpacing: 5
          maxLength: 11,
          buildCounter: null,
          onChanged: (value) {
            setState(() {
              phone_number = value;
            });
          },
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: PRIMARY_GREY,
            contentPadding:
                const EdgeInsets.only(top: 15, bottom: 15),
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ):
      Padding(
        padding: EdgeInsets.only(
            left: getDeviceWidth(context) / 47 * 3,
            right: getDeviceWidth(context) / 47 * 3),
        child: TextField(
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 27),
            maxLength: 6,
            controller: verify_code,
            keyboardType: TextInputType.name,
            //validator: (pwd) => passwordErrorText(pwd ?? ''),
            autocorrect: false,
            textInputAction:
                TextInputAction.done,
            cursorColor: Colors.grey,
              decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: PRIMARY_GREY,
              contentPadding:
                  const EdgeInsets.only(top: 15, bottom: 15),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        // TextField(
        //   textAlign: TextAlign.center,
        //   style: const TextStyle(fontSize: 27),
        //   maxLength: 6,
        //   buildCounter: null,
        //   onChanged: (value2) {
        //     setState(() {
        //       digits = value2.isNotEmpty ? value2 : "";
        //     });
        //   },
        //   decoration: InputDecoration(
        //     counterText: '',
        //     filled: true,
        //     fillColor: PRIMARY_GREY,
        //     contentPadding:
        //         const EdgeInsets.only(top: 15, bottom: 15),
        //     border: OutlineInputBorder(
        //         borderSide: BorderSide.none,
        //         borderRadius: BorderRadius.circular(10)),
        //   ),
        // ),
      );
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Stack(children: [
          Container(
              constraints:
                  BoxConstraints(minHeight: getDeviceHeight(context) - 100),
              child: Column(children: [
                HeaderWidget(
                  title1: otpCodeVisible == false?"電話番号を入力":"届いた認証番号を入力",
                  title2: otpCodeVisible == false?"入力した電話番号に６桁の認証番号が届きます。":"下記電話番号宛に届いた認証コードを入力してください。",
                ),
                Expanded(
                  flex: 2,
                  child: Container(),
                ),
                phone_show,
                Expanded(
                  flex: 3,
                  child: Container(),
                ),
                phone_input,
                Expanded(
                  flex: 10,
                  child: Container(),
                ),
                Visibility(
                  visible: isLoading,
                  child: Column(children: [
                    CircularProgressIndicator(),Text("waiting...")
                  ],)
                ),
                Visibility(
                  visible: !isShow,
                  child: Column(
                    children: [
                      Text("Please try again."),
                      // Add your remaining content here after removing loading indicator
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: RadiusButton(
                            id: 0,
                            color: BUTTON_MAIN,
                            text: otpCodeVisible ?"つぎへ": "つぎへ",
                            goNavigation: (id) {
                              if(otpCodeVisible)
                              {
                                verifyCode();
                              }
                              else{
                                verifyUserPhoneNumber();
                              }
                            },
                            isDisabled: phone_number.length < 11 && !isLoading,
                          ),
                        ))),
                        
                Expanded(
                  child: Container(),
                )
              ]))
            
          ]),
        ));
  }
  
 
}
