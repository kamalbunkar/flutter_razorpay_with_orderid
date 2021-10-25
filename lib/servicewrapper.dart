import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class servicewrapper {
// https://androidtutorial.blueappsoftware.com/webapi/razorpay-php-app/orderapi.php
  static var baseurl = "https://androidtutorial.blueappsoftware.com/";
  static var mainfolder = ""; // "single/";
  static var subfolder = "";
  static var apifolder = "webapi/";
  static var mediafolder = "media/";
  static var securitycode = "123";

  call_order_api( String txnid, String amount) async {
    dynamic jsonresponse = "[]";
    var url = baseurl + mainfolder + subfolder + apifolder + "razorpay-php-app/orderapi.php";
    final body = { 'securecode': securitycode, 'txnid': txnid, 'amount': amount};

   // without header
     final response = await http.post(Uri.parse(url), body: body) ;

    print(" get response done " + response.body.toString());
    try {
      jsonresponse = json.decode(response.body.toString());
    } catch (error) {
      print(" get-categrrory error " + error.toString());
    }
    return jsonresponse;
  }

}
