import 'package:flutter/material.dart';
import 'package:flutter_app_pay_razorpay/ModelOrderId.dart';
import 'package:flutter_app_pay_razorpay/servicewrapper.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

void main() {
  runApp( MaterialApp(home:  MyApp()));

}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Razorpay _razorpay;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Text("Razorpay Payment gateway"),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: "amount",
                  icon: Icon(Icons.monetization_on)
                ),

              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextButton(onPressed: (){

                int amount = int.parse(controller.text) * 100;
                _getorderId("123456", amount.toString());
              },
                  child: Text("Start Payment", style: TextStyle(color: Colors.white),),
              style: TextButton.styleFrom(backgroundColor: Colors.blue),),
            )

          ],
        ),
      ),
    );
  }

  _getorderId( String txnid, String amount) async {
    print(" call start here");
    servicewrapper wrapper = new servicewrapper();
    Map<String, dynamic> response = await wrapper.call_order_api(txnid, amount);
    final model = ModelOrderId.fromJson(response);
    print(" response here");
    if (model != null) {
      if (model.status == 1) {
        print(" order id is  - " + model.Information.toString());
        _startPayment( model.Information.toString(), amount);
      } else {
        print(" status zero");
      }
    } else {
      print(" model null for category api");
    }

  }

  _startPayment(String orderid, String amount) async{

    var options = {
      'key': 'rzp_test_Da0rUiZZO51VON',
      'amount': amount,
      'order_id' : orderid,
      'name': 'Dripcoding.com',
      'description': 'blueappsoftware',
      'prefill': {
        'contact': '9144040888',
        'email': 'kamal.bunkar07@gmail.com'
      }
    };

    try{
      _razorpay.open(options);
    }catch (e){
      print(" razorpay error "+ e.toString());
    }

  }


  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    print(" RazorSuccess : "+  response.paymentId! + " -- "+ response.orderId!);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print(" RazorpayError : "+ response.code.toString() + " -- "+ response.message!);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    print(" RazorWallet : "+  response.walletName! );

  }
}


