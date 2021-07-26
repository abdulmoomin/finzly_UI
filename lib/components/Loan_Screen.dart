import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finzly/data_model/ErrorModel.dart';
import 'package:finzly/utils/constants.dart';

class LoanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

bool isValid(BuildContext context, String amount, String intRate) {
  final number = num.tryParse(amount);
  final numberRate = num.tryParse(intRate);
  if (number == null) {
    _displayTextInputDialog(context, "Please valid loan amount", "Failure");
    return false;
  } else if (numberRate == null) {
    _displayTextInputDialog(context, "Please valid interestRate", "Failure");
    return false;
  }
  return true;
}

callLoanCrateApi(BuildContext context, String name, String loanAmt,
    String payFre, String payTerm, String intRate) async {
  if (isValid(context, loanAmt, intRate)) {
    print("#######" + name + "####" + loanAmt + "####" + payFre);
    Map data = {
      'customerName': name,
      'loanAmount': double.parse(loanAmt),
      'paymentfrequency': payFre,
      'paymentTerm': int.parse(payTerm),
      'interestRate': double.parse(intRate)
    };
    String body = convert.jsonEncode(data);
    print(body);
    final http.Response response = await http.post(
      'http://localhost:8421/loan-api/loan',
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    print(response.body);
    String responseString;
    if (response.statusCode == 200) {
      print(response.body);
      responseString = response.body;
      _saveUserData(context, responseString);
    } else {
      print("failed");
      responseString = response.body;
      //throw Exception('Failed to signup.');
      print(responseString);
      //var tagObjsJson = convert.jsonDecode(response.body)[''] as List;

      var tagsJson = convert.jsonDecode(response.body)[0];
      var data = tagsJson["detail"] as List;

      print(data);

      List<ErrorModel> errorObjs =
          data.map((tagJson) => ErrorModel.fromJson(tagJson)).toList();

      _displayTextInputDialog(context, errorObjs.toString(), "Failure");
    }
  }
}

Future<void> _saveUserData(BuildContext context, String responseString) async {
  _displayTextInputDialog(context, "Your loan successfully created", "Success");
}

Future<void> _displayTextInputDialog(
    BuildContext context, String responseString, String message) async {
  print("Alert" + responseString);
  bool _isColorChanged = message == "Success" ? true : false;
  print("_isColorChanged" + _isColorChanged.toString());
// create ok button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      if (message == "Success") {
        Navigator.of(context).pop();
        // Navigator.push(context,
        //     new MaterialPageRoute(builder: (context) => new LoginPage()));
      } else {
        Navigator.of(context).pop();
      }
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text(message),
    //content: Text(responseString),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Text(
            responseString,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _isColorChanged ? Colors.green : Colors.red,
            ),
          ),
        )
      ],
    ),
    actions: [
      okButton, //your actions (I.E. a button)
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class _State extends State<LoanPage> {
  List<String> _paymentFrequency = [
    'Select PaymentFrequency',
    'Monthly',
    'Quarterly',
    'HalfYearly',
    'Yearly'
  ];
  String _selectedPaymentFrequency = "Select PaymentFrequency";

  TextEditingController nameController = TextEditingController();
  TextEditingController loanAmtController = TextEditingController();
  //TextEditingController paymentFreController = TextEditingController();
  TextEditingController paymentTermController = TextEditingController();
  TextEditingController interestRateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Create Loan'),
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Customer Name',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: loanAmtController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'loan Amount',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  /*child: TextField(
                    //obscureText: true,
                    controller: country_nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Country Code',
                    ),
                  ),*/

                  //child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    value: _selectedPaymentFrequency,
                    items: _paymentFrequency.map((location) {
                      return DropdownMenuItem(
                        child: new Text(location),
                        value: location,
                      );
                    }).toList(),
                    hint: Text(
                        'Please choose a Payment Frequency'), // Not necessary for Option 1

                    onChanged: (newValue) {
                      setState(() {
                        _selectedPaymentFrequency = newValue as String;
                      });
                    },
                  ),
                ),
                /*Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: paymentFreController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Payment Frequency',
                    ),
                  ),
                ),*/
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: paymentTermController,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Payment Term',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: interestRateController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Interest Rate',
                    ),
                  ),
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.black,
                      color: kCaptionColorTest,
                      child: Text('Save'),
                      onPressed: () async {
                        print(nameController.text);
                        print(loanAmtController.text);
                        await callLoanCrateApi(
                            context,
                            nameController.text,
                            loanAmtController.text,
                            _selectedPaymentFrequency,
                            paymentTermController.text,
                            interestRateController.text);
                      },
                    )),
              ],
            )));
  }
}
