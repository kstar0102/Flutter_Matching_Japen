import 'package:flutter/material.dart';
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
// ignore: use_key_in_widget_constructors
class LoginView extends ConsumerStatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  String phone_number = "";
  FirebaseAuth auth = FirebaseAuth.instance;
  var receivedID = '';
  bool otpFieldVisibility = false;
  final otpController = TextEditingController();
  // firebase OTP
  void verifyUserPhoneNumber() {
    auth.verifyPhoneNumber(
        phoneNumber: "+"+phone_number,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential).then(
            (value) => print('Logged In Successfully'),
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verificationId, int? resendToken) {
          receivedID = verificationId;
          otpFieldVisibility = true;
          setState(() {});
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('TimeOut');
        },
    );
  }

  Future<void> verifyOTPCode() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: receivedID,
        smsCode: otpController.text,
    );
    await auth
        .signInWithCredential(credential)
        .then((value) => print('User Login In Successful'));
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

          print('Phone number stored in Firestore with user ID: $fetchedUserId');

          // Navigator.pushNamed(context, "/identity_verify");
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
      Navigator.pushNamed(context, "/check_code");
      
      print('Phone number added to Firestore with document ID: $addedDocumentId');
    }
  } catch (e) {
    print('Error: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Stack(children: [
            Container(
                constraints:
                    BoxConstraints(minHeight: getDeviceHeight(context) - 100),
                child: Column(children: [
                  const HeaderWidget(
                    title1: "電話番号を入力",
                    title2: "入力した電話番号に６桁の認証番号が届きます。",
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(),
                  ),
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
                  ),
                  Expanded(
                    flex: 10,
                    child: Container(),
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
                              text: "つぎへ",
                              goNavigation: (id) {
                                // firebaseChecked();
                                // verifyUserPhoneNumber();
                                 if(otpFieldVisibility){
                                      verifyOTPCode();
                                  } else{
                                      verifyUserPhoneNumber();
                                  }
                                  FocusManager.instance.primaryFocus?.unfocus();
                              },
                              isDisabled: phone_number.length < 11,
                            ),
                          ))),
                          SizedBox(
                            width: 100 * 3.3,
                            child: TextField(
                              // textAlign: TextAlign.center,
                              controller: otpController,
                              keyboardType: TextInputType.name,
                              autocorrect: false,
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                // labelStyle: kLabelStyle,
                                // errorStyle: kErrorStyle,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                hintText: "Enter School Code",
                                hintStyle: TextStyle(
                                  fontSize:
                                      15.0,
                                  color: Colors.grey[500]
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                                disabledBorder: InputBorder.none,
                                // Align the text within the TextField vertically and horizontally
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 20),
                                counterText: '',
                              ),
                            ),
                          ),
                  Expanded(
                    child: Container(),
                  )
                ]))
          ]),
        ));
  }
}
