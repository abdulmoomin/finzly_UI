import 'dart:math';
import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:date_field/date_field.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:finzly/components/Loan_Screen.dart';
import 'package:finzly/components/LoanApproved_Screen.dart';
import 'package:flutter/material.dart';
import 'package:finzly/data_model/Loan.dart';
import 'package:finzly/utils/constants.dart';

// Flutter DataGrid package import
//import 'package:syncfusion_flutter_datagrid/datagrid.dart';

String tempCustomerID = "";

class PaymentdetailsPage extends StatefulWidget {
  //LoandetailsPage({Key? key}) : super(key: key);
  final String customerID;
  PaymentdetailsPage(this.customerID); //, {Key? key}) : super(key: key);

  @override
  _PaymentdetailsPageState createState() =>
      _PaymentdetailsPageState(customerID);
}

class _PaymentdetailsPageState extends State<PaymentdetailsPage> {
  _PaymentdetailsPageState(customerID);

  List results = [];
  updatePaymentStatus(String paymentID) async {
    final http.Response response = await http.put(
      'http://localhost:8421/loan-api/loan/payment/paid/' + paymentID,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    print(response.body);
    String responseString;
    if (response.statusCode == 200) {
      print(response.body);
      responseString = response.body;
      //print("@@@" + tempCustomerID);
      getData(tempCustomerID);
      //_saveUserData(context, responseString);
    } else {
      print("failed");
    }
  }

  getData(String customerID) async {
    tempCustomerID = widget.customerID;
    final http.Response response = await http.get(
      'http://localhost:8421/loan-api/loan/customer/payment/' + customerID,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    print(response.body);
    String responseString;
    if (response.statusCode == 200) {
      print(response.body);
      responseString = response.body;

      setState(() {
        results = convert.jsonDecode(response.body);
        List.generate(
            results.length, (index) => print(results[index]["paymentID"]));
        //final Loan loan = loanFromJson(responseString);
      });
      //_saveUserData(context, responseString);
    } else {
      print("failed");
    }
  }

  DataRow _getDataRow(result) {
    return DataRow(
      cells: <DataCell>[
        DataCell(Text(result["paymentDate"].toString())),
        DataCell(Text(result["paymentAmount"].toString())),
        DataCell(Text(result["principalAmount"].toString())),
        DataCell(Text(result["projectedinterest"].toString())),
        DataCell(Text(result["paymentStatus"])),
        DataCell(result["paymentStatus"] == 'PROJECTED'
            ? Container(
                child: Row(
                children: <Widget>[
                  RaisedButton(
                    color: kCaptionColorBottom,
                    onPressed: () {
                      updatePaymentStatus(result["paymentID"]);
                    },
                    child: Text(
                      "Paid",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                  /*FlatButton(
                    textColor: Colors.blue,
                    child: Text(
                      'PAID',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      updatePaymentStatus(result["paymentID"]);
                      //Navigator.pushNamed(context, '/');
                      /*Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  LoanApprovedPage(result["customerID"])));*/
                      //_displayTextInputDialog(context, result["customerID"]);
                    },
                  )*/
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ))
            : new Container(
                child: Text('Success'),
              )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (tempCustomerID == "") {
      this.getData(widget.customerID);
    }

    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: kCaptionColorTest,
          title: Text(
            "Payment Details",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'Poppins-Medium.ttf',
            ),
          ),
          leading: InkWell(
            child: Container(
              child: Align(
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
            onTap: () {
              tempCustomerID = "";
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
            padding: EdgeInsets.fromLTRB(50, 10, 10, 0),
            child: DataTable(
              headingRowColor: MaterialStateProperty.all<Color>(Colors.black54),
              dataRowColor: MaterialStateProperty.all<Color>(Colors.green),
              showBottomBorder: true,
              columns: [
                DataColumn(label: Text('PaymentDate')),
                DataColumn(label: Text('PaymentAmount')),
                DataColumn(label: Text('PrincipalAmount')),
                DataColumn(label: Text('Projectedinterest')),
                DataColumn(label: Text('PaymentStatus')),
                DataColumn(
                    label: Text(
                  'Action',
                  textAlign: TextAlign.center,
                )),
              ],
              rows: //_rowList
                  List.generate(
                      results.length, (index) => _getDataRow(results[index])),
            )));
  }
}
