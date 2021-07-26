import 'dart:convert';

Loan loanFromJson(String str) => Loan.fromJson(json.decode(str));

String loanToJson(Loan data) => json.encode(data.toJson());

class Loan {
  Loan({
    required this.customerID,
    required this.customerName,
    required this.loanAmount,
    required this.paymentfrequency,
    required this.paymentTerm,
    required this.interestRate,
    required this.loanStatus,
  });

  String customerID;
  String customerName;
  int loanAmount;
  String paymentfrequency;
  int paymentTerm;
  int interestRate;
  String loanStatus;

  factory Loan.fromJson(Map<String, dynamic> json) => Loan(
        customerID: json['customerID'],
        customerName: json['customerName'],
        loanAmount: json['loanAmount'],
        paymentfrequency: json['paymentfrequency'],
        paymentTerm: json['paymentTerm'],
        interestRate: json['interestRate'],
        loanStatus: json['loanStatus'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerID'] = this.customerID;
    data['customerName'] = this.customerName;
    data['loanAmount'] = this.loanAmount;
    data['paymentfrequency'] = this.paymentfrequency;
    data['paymentTerm'] = this.paymentTerm;
    data['interestRate'] = this.interestRate;
    data['loanStatus'] = this.loanStatus;
    return data;
  }
}
