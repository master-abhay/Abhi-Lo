import 'dart:convert';

import 'package:abhi_lo/Widgets/custom_button.dart';
import 'package:abhi_lo/models/user_profile.dart';
import 'package:abhi_lo/services/database_services.dart';
import 'package:abhi_lo/services/navigation_services.dart';
import 'package:abhi_lo/services/shared_prefrences.dart';
import 'package:abhi_lo/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  GetIt _getIt = GetIt.instance;

  late NavigationServices _navigationServices;
  late DatabaseServices _databaseServices;
  late LocalDataSaver _localDataSaver;
  late GlobalKey<FormState> _walletFormKey;

  int amount = 0;
  int _customAmount = 0;

  @override
  void initState() {

    _navigationServices = _getIt.get<NavigationServices>();
    _databaseServices = _getIt.get<DatabaseServices>();
    _localDataSaver = _getIt.get<LocalDataSaver>();

    _getCurrentUserDetails();

    _walletFormKey = GlobalKey<FormState>();

    super.initState();
  }

  _getCurrentUserDetails() async {
    UserProfile? user = await _databaseServices.getCurrentUser();

    setState(() {
      amount = user!.wallet;
    });
  }

  Map<String, dynamic>? paymentIntent;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: buildUI(),
    );
  }

  Widget buildUI() {
    return SafeArea(
        child: Column(
      children: [
        _headerText(),
        _body(),
      ],
    ));
  }

  Widget _headerText() {
    return Material(
      elevation: 10,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.sizeOf(context).height * 0.015),
          child: Text(
            "Wallet",
            style: boldTextStyle(),
          ),
        ),
      ),
    );
  }

  Widget _body() {
    return Column(
      children: [_yourWallet(), _addMoney(), _addCustomAmount()],
    );
  }

  Widget _yourWallet() {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.sizeOf(context).width * 0.001),
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width * 0.02,
          vertical: MediaQuery.sizeOf(context).height * 0.01),
      decoration: const BoxDecoration(color: Color(0xFFF2F2F2)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding:
                EdgeInsets.only(right: MediaQuery.sizeOf(context).width * 0.02),
            child: Image.asset(
              "images/wallet.png",
              width: 100,
              fit: BoxFit.fill,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your Wallet",
                style: fadeBoldTextStyle(),
              ),
              StreamBuilder(
                stream: _databaseServices.getLiveUser(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final user = snapshot.data as UserProfile;
                    final currentAmount = user.wallet.toString();
                    return Text(
                      "\$" + "$currentAmount",
                      style: boldTextStyle(),
                    );
                  } else if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.connectionState == ConnectionState.none) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text("unable to load Amount");
                  }
                  return Container(); // Handle the case where there's no data initially
                },
              )

            ],
          )
        ],
      ),
    );
  }

  Widget _addMoney() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width * 0.04,
          vertical: MediaQuery.sizeOf(context).height * 0.01),
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add Money",
              style: midBoldTextStyle(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.sizeOf(context).height * 0.01),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        // makePayment('100');
                        _databaseServices.updateWalletBalance(100);
                        setState(() {
                          amount = amount + 100;
                        });
                      },
                      child: _addAmount(100)),
                  GestureDetector(
                      onTap: () {
                        // makePayment('500');
                        _databaseServices.updateWalletBalance(500);
                        setState(() {
                          amount = amount + 500;
                        });
                      },
                      child: _addAmount(500)),
                  GestureDetector(
                      onTap: () {
                        // makePayment('1000');

                        _databaseServices.updateWalletBalance(1000);
                        setState(() {
                          amount = amount + 1000;
                        });
                      },
                      child: _addAmount(1000)),
                  GestureDetector(
                      onTap: () {
                        // makePayment('2000');
                        _databaseServices.updateWalletBalance(2000);
                        setState(() {
                          amount = amount + 2000;
                        });
                      },
                      child: _addAmount(2000)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _addAmount(int amount) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(5),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.01,
            vertical: MediaQuery.sizeOf(context).height * 0.003),
        child: Text(
          "\$${amount}",
          style: midBoldTextStyle(),
        ),
      ),
    );
  }

  Widget _addCustomAmount() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width * 0.1),
      child: CustomButton(
          text: "Add Money",
          isLoading: isLoading,
          buttonColor: Colors.green,
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      "Add money",
                      style: semiboldTextStyle(),
                    ),
                    content: Form(
                      key: _walletFormKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: "Enter Amount",
                              label: Text("Amount"),
                              border: OutlineInputBorder(),
                            ),
                            onSaved: (value) {
                              setState(() {
                                String a = value!;
                                int val = int.parse(a);
                                _customAmount = val;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                              width: 150,
                              child: CustomButton(
                                  text: "Pay",
                                  isLoading: false,
                                  onPressed: () async {
                                    if (_walletFormKey.currentState!
                                        .validate()) {
                                      _walletFormKey.currentState!.save();
                                      // await _databaseServices
                                      //     .updateWalletBalance(_customAmount);

                                      await makePayment(
                                          _customAmount.toString());

                                      _navigationServices.goBack();
                                    }
                                  },
                                  buttonColor: Colors.green))
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  }

  Future<void> makePayment(String amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'USD');
      var gPay = const PaymentSheetGooglePay(
          merchantCountryCode: "US", currencyCode: "USD", testEnv: true);

      await Stripe.instance
          .initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntent!['client_secret'],
            // ... other parameters
            style: ThemeMode.dark,
            merchantDisplayName: 'Adnan',
            googlePay: gPay),
      )
          .then((value) async {
        await displayPaymentSheet(amount);
      });
    } catch (e, s) {
      print(
          "--------------------->>>>>>>>>>>>>>>>>>>>>>>>printing in makePayment");
      print('exception:$e$s');
    }
  }

  displayPaymentSheet(String amount) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        // ... your success logic here
      }).onError((error, stackTrace) {
        print('Error is:--->$error $stackTrace');
        // Show an error message to the user here
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Payment failed"),
              ));
    } catch (e) {
      print('$e');
      // Handle other general exceptions here
    }
  }

  Future<Map<String, dynamic>?> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': (int.parse(amount) * 100).toString(),
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      final url = Uri.parse("https://api.stripe.com/v1/payment_intents");
      final secretKey = dotenv.env['STRIPE_SECRET_KEY'];

      var response = await http.post(url,
          headers: {
            "Authorization": "Bearer $secretKey",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: body);

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        print(json);
        return json;
      } else {
        print("Error creating payment intent: ${response.statusCode}");
        // Show an error message to the user here
        return null;
      }
    } catch (e) {
      print("Error creating payment intent: $e");
      return null;
    }
  }

// Future<void> makePayment(int amount) async {
//   try {
//     // Create a payment intent
//     final paymentIntent = await createPaymentIntent(amount: amount);
//
//     // Initialize the payment sheet
//     await Stripe.instance.initPaymentSheet(
//       paymentSheetParameters: SetupPaymentSheetParameters(
//         customerId: paymentIntent['id'],
//         paymentIntentClientSecret: paymentIntent['client_secret'],
//         merchantDisplayName: 'MyCoolApp',
//       ),
//     );
//
//     // Present the payment sheet
//     await Stripe.instance.presentPaymentSheet();
//   } catch (e) {
//     // Handle errors
//   }
// }
// Future<Map<String, dynamic>> createPaymentIntent({required int amount}) async {
//   final response = await http.post(
//     Uri.parse('https://api.stripe.com/v1/payment_intents'),
//     headers: {
//       'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET_KEY']}',
//       'Content-Type': 'application/x-www-form-urlencoded',
//     },
//     body: 'amount=$amount&currency=usd',
//   );
//
//   return jsonDecode(response.body);
// }
}
