import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:finzly/data_model/ErrorModel.dart';
import 'package:finzly/components/LoanDetails_Screen.dart';
import 'package:finzly/utils/constants.dart';
import 'package:finzly/main.dart';

class LoanApprovedPage extends StatefulWidget {
  final String customerID;
  LoanApprovedPage(this.customerID); //, {Key? key}) : super(key: key);
  //LoanApprovedPage({@required customerID});

  @override
  State<StatefulWidget> createState() => new _State();
}

callLoanApprovedApi(BuildContext context, DateTime loanDate, DateTime mDate,
    String customerID) async {
  print("#######" +
      loanDate.toString().split(' ')[0] +
      "####" +
      mDate.toString().split(' ')[0] +
      "####" +
      customerID);
  Map data = {
    'loanStartDate': loanDate.toString().split(' ')[0],
    'maturityDate': mDate.toString().split(' ')[0]
  };
  String body = convert.jsonEncode(data);
  print(body);
  final http.Response response = await http.put(
    'http://localhost:8421/loan-api/loan/approval/' + customerID,
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
    print(responseString);
    var tagsJson = convert.jsonDecode(response.body);
    var data = tagsJson["detail"] as List;
    print(data);
    List<ErrorModel> errorObjs =
        data.map((tagJson) => ErrorModel.fromJson(tagJson)).toList();

    _displayTextInputDialog(context, errorObjs.toString(), "Failure");
  }
}

Future<void> _saveUserData(BuildContext context, String responseString) async {
  _displayTextInputDialog(context, "loan approved successfully ", "Success");
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
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new MyHomePage()));
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

class _State extends State<LoanApprovedPage> {
  //DateTime loanSelectedData = new DateTime.now();
  DateTime maturitySelectedData = new DateTime.now();
  DateTime loanSelectedData = new DateTime.now();

  TextEditingController loanStDateController = TextEditingController();
  TextEditingController maturityDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("###" + widget.customerID);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Loan Approval'),
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(300, 10, 10, 0),
                  child: Row(
                    children: [
                      Text(
                        'Loan Start Date :',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        loanSelectedData == null
                            ? 'Not yet'
                            : "${loanSelectedData.toLocal()}".split(' ')[0],
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      RaisedButton(
                          textColor: Colors.black,
                          color: kCaptionColorTest,
                          child: Text('pickdate'),
                          onPressed: () {
                            showDatePicker(
                                    context: context,
                                    cancelText: "",
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2021),
                                    lastDate: DateTime(2100))
                                .then((date) {
                              //loanSelectedData = date!;
                              setState(() {
                                loanSelectedData = date!;
                              });
                            });
                          })
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(300, 10, 10, 0),
                  child: Row(
                    children: [
                      Text("MaturityDate :",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 20)),
                      SizedBox(
                        width: 53,
                      ),
                      Text(
                          maturitySelectedData == null
                              ? 'Not yet'
                              : "${maturitySelectedData.toLocal()}"
                                  .split(' ')[0],
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 20)),
                      SizedBox(
                        width: 30,
                      ),
                      RaisedButton(
                          textColor: Colors.black,
                          color: kCaptionColorTest,
                          child: Text('pickdate'),
                          onPressed: () {
                            showDatePicker(
                                    context: context,
                                    cancelText: "",
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2021),
                                    lastDate: DateTime(2100))
                                .then((date) {
                              //maturitySelectedData = date!;
                              setState(() {
                                maturitySelectedData = date!;
                              });
                            });
                          })
                    ],
                  ),
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.black,
                      color: kCaptionColorTest,
                      child: Text('Loan Approved'),
                      onPressed: () async {
                        print(loanSelectedData);
                        print(maturitySelectedData);
                        print(widget.customerID);
                        callLoanApprovedApi(context, loanSelectedData,
                            maturitySelectedData, widget.customerID);
                        //   passwordController.text, context);
                      },
                    )),
              ],
            )));
  }
}
