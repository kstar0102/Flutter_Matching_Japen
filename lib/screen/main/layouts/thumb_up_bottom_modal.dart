import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/components/thumb_up_card.dart';
import 'package:matching_app/screen/main/layouts/coin_check_modal.dart';
import 'package:matching_app/utile/index.dart';
import 'package:matching_app/bloc/cubit.dart';
import 'package:pay/pay.dart';

import '../../../components/radius_button.dart';

class ThumbUpBottomModal extends StatefulWidget {
  const ThumbUpBottomModal({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ThumbUpBottomModalState createState() => _ThumbUpBottomModalState();
}

class _ThumbUpBottomModalState extends State<ThumbUpBottomModal> {

  void initState() {
    super.initState();
    BlocProvider.of<AppCubit>(context).fetchProfileInfo();
  }

  @override
  Widget build(BuildContext context) {

    AppCubit appCubit = AppCubit.get(context);

    const _paymentItems = [
      PaymentItem(
        label: 'Total',
        amount: '99.99',
        status: PaymentItemStatus.final_price,
      )
    ];
    
    return Container(
        padding: EdgeInsets.only(
            left: vww(context, 6), right: vww(context, 6), top: 50),
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('いいね交換', style: TextStyle(fontSize: 17)),
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: const Color.fromARGB(255, 229, 250, 245),
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25),
                              ),
                            ),
                            builder: (context) {
                              return SingleChildScrollView(
                                padding: EdgeInsets.only(
                                    left: 50,
                                    right: 50,
                                    top: 30,
                                    bottom: MediaQuery.of(context).viewInsets.bottom),
                                child: SizedBox(
                                    height: vhh(context, 20),
                                    child: Column(
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Center(
                                              child: Container(
                                              width: vw(context, 35),
                                              height: 5,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(50.0),
                                                  color: PRIMARY_FONT_COLOR),
                                            )),
                                          ],
                                        ),
                                        
                                        ApplePayButton(
                                          paymentConfigurationAsset: 'applepay.json',
                                          paymentItems: _paymentItems,
                                          style: ApplePayButtonStyle.black,
                                          type: ApplePayButtonType.buy,
                                          width: 200,
                                          height: 50,
                                          margin: const EdgeInsets.only(top: 15.0),
                                          onPaymentResult: (value) {
                                            print(value);
                                          },
                                          onError: (error) {
                                            print(error);
                                          },
                                          loadingIndicator: const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),

                                        GooglePayButton(
                                          paymentConfigurationAsset: 'gpay.json',
                                          paymentItems: _paymentItems,
                                          type: GooglePayButtonType.pay,
                                          margin: const EdgeInsets.only(top: 15.0),
                                          onPaymentResult: (result) {
                                            print(result.toString());
                                          },
                                          loadingIndicator: const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
                                      ],
                                    )),
                              );
                            },
                          );
                        },
                        child: Row(children: [
                          Container(
                            margin: const EdgeInsets.only(right: 20),
                            width: 20,
                            height: 20,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: BUTTON_MAIN,
                            ),
                            child: const Text(
                              "C",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17),
                            ),
                          ),
                          Text(
                            appCubit.user.coin.toString()??"0",
                            style: TextStyle(fontSize: 17, color: BUTTON_MAIN),
                          )
                        ],),
                      ),
                    ],
                  ))
            ]),
            const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "コイン1枚といいねを2つ交換できます\n多くのいいねを送ることでチャンスが増えます",
                  style: TextStyle(fontSize: 12),
                )),
            Container(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        style: ButtonStyle(
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  EdgeInsets.zero),
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) =>
                                  const CoinCheckModal(isFull: false, price:10));
                        },
                        child: const ThumbUpCard(text: 10)),
                    TextButton(
                        style: ButtonStyle(
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  EdgeInsets.zero),
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) =>
                                  const CoinCheckModal(isFull: true, price:30));
                        },
                        child: const ThumbUpCard(text: 30)),
                    TextButton(
                        style: ButtonStyle(
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  EdgeInsets.zero),
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) =>
                                  const CoinCheckModal(isFull: false, price:50));
                        },
                        child: const ThumbUpCard(text: 50)),
                  ],
                ))
          ],
        ));
  }
}
