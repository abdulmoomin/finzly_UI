import 'dart:math';
import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:date_field/date_field.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:finzly/components/Loan_Screen.dart';
import 'package:finzly/components/LoanApproved_Screen.dart';
import 'package:finzly/components/Payment_Screen.dart';
import 'package:flutter/material.dart';
import 'package:finzly/data_model/Loan.dart';
import 'package:finzly/utils/constants.dart';

// Flutter DataGrid package import
//import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class LoandetailsPage extends StatefulWidget {
  //LoandetailsPage({Key? key}) : super(key: key);

  @override
  _LoandetailsPageState createState() => _LoandetailsPageState();
}

class _LoandetailsPageState extends State<LoandetailsPage> {
  List results = [];
  @override
  void initState() {
    this.getData();
    //super.iniState();
  }

  getData() async {
    final http.Response response = await http.get(
      'http://localhost:8421/loan-api/loan',
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
            results.length, (index) => print(results[index]["customerName"]));
        //final Loan loan = loanFromJson(responseString);
      });
      //_saveUserData(context, responseString);
    } else {
      print("failed");
    }
  }

  updateLoanStatus(String customerID) async {
    final http.Response response = await http.put(
      'http://localhost:8421/loan-api/loan/rejected/' + customerID,
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
      getData();
      //_saveUserData(context, responseString);
    } else {
      print("failed");
    }
  }

  Future<void> _displayTextInputDialog(
      BuildContext context, String customerID) async {
    //print("Alert" + customerID);
    //bool _isColorChanged = message == "Success" ? true : false;
    //print("_isColorChanged" + _isColorChanged.toString());

    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    DateTime loanSelectedData = new DateTime.now();
    DateTime maturitySelectedData = new DateTime.now();
    TextEditingController loanStDateController = TextEditingController();
    TextEditingController maturityDateController = TextEditingController();

    AlertDialog alert = AlertDialog(
      title: Text("Loan Approval"),
      //content: Text(responseString),
      content: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        //crossAxisAlignment: CrossAxisAlignment.start,

        children: <Widget>[
          Container(
              width: 300,
              height: 50,
              //padding: EdgeInsets.all(10),
              child:
                  /*TextField(
            controller: loanStDateController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'LoanStartDate',
            ),
          ),*/
                  DateField(
                onDateSelected: (DateTime value) {
                  setState(() {
                    loanSelectedData = value;
                  });
                },
                decoration: InputDecoration(border: OutlineInputBorder()),
                label: 'Loan Startdate',
                dateFormat: DateFormat.yMd(),
                selectedDate: loanSelectedData,
              )),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 200,
            height: 40,
            //padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextField(
              //obscureText: true,
              controller: maturityDateController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'MaturityDate',
              ),
            ),
          )
          /*Expanded(
          child: Text(
            "responseString",
            textAlign: TextAlign.center,
            style: TextStyle(
                //color: _isColorChanged ? Colors.green : Colors.red,
                ),
          ),
        )*/
        ],
      ),
      /*  ListView(children: <Widget>[
      Container(
        //padding: EdgeInsets.all(10),
        child: TextField(
          controller: loanStDateController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'LoanStartDate',
          ),
        ),
      ),
      Container(
        //padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: TextField(
          //obscureText: true,
          controller: maturityDateController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'MaturityDate',
          ),
        ),
      )
    ]),*/
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

  /*List<DataRow> _rowList = [
    DataRow(cells: <DataCell>[
      DataCell(Text('AAAAAA')),
      DataCell(Text('1')),
      DataCell(Container(
          child: Row(
        children: <Widget>[
          FlatButton(
            textColor: Colors.blue,
            child: Text(
              'Approved',
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () {
              // Navigator.pushNamed(context, '/');
            },
          )
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ))),
    ]),
  ];*/

  DataRow _getDataRow(result) {
    return DataRow(
      cells: <DataCell>[
        DataCell(Text(result["customerName"])),
        DataCell(Text(result["loanAmount"].toString())),
        DataCell(Text(result["paymentfrequency"])),
        DataCell(Text(
            result["paymentTerm"] == 2 ? 'Even Principal' : 'Interest Only')),
        DataCell(Text(result["loanStatus"])),
        DataCell(result["loanStatus"] == 'Pending'
            ? Container(
                child: Row(
                children: <Widget>[
                  RaisedButton(
                    color: kCaptionColorBottom,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  LoanApprovedPage(result["customerID"])));
                    },
                    child: Text(
                      "Approved",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  RaisedButton(
                    color: kCaptionColorBottom,
                    onPressed: () {
                      updateLoanStatus(result["customerID"]);
                    },
                    child: Text(
                      "Rejected",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ))
            : result["loanStatus"] == 'Approved'
                ? Container(
                    child: FlatButton(
                    textColor: Colors.blue,
                    child: Text(
                      'Payment Details',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      //Navigator.pushNamed(context, '/');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PaymentdetailsPage(result["customerID"])));
                    },
                  ))
                : new Container(
                    child: Text('Rejected'),
                  )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Manage Loans'),
        ),
        body: Container(
            padding: EdgeInsets.fromLTRB(15, 10, 10, 0),
            child: DataTable(
              headingRowColor: MaterialStateProperty.all<Color>(Colors.black54),
              dataRowColor: MaterialStateProperty.all<Color>(Colors.green),
              showBottomBorder: true,
              columns: [
                DataColumn(label: Text('CustomerName')),
                DataColumn(label: Text('LoanAmount')),
                DataColumn(label: Text('Paymentfrequency')),
                DataColumn(label: Text('PaymentTerm')),
                DataColumn(label: Text('LoanStatus')),
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
