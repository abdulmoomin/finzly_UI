import "package:flutter/material.dart";
import 'package:http/http.dart';
import 'components/Loan_Screen.dart';
import 'components/LoanDetails_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finzly/utils/constants.dart';

void main() => runApp(MyApp());

hexcolor(String colorcode) {
  String colornew = '0xff' + colorcode;
  int colorint = int.parse(colornew);
  return colorint;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(primarySwatch: Colors.deepPurple),
      theme: ThemeData(primaryColor: kCaptionColorTest),

      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCaptionColorTest,
      drawer: SideDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Finzly'),
        backgroundColor: kCaptionColorTest, //Colors.deepPurple[600],
      ),
      body: Center(
        //child: Text('Side Menu Tutorial'),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/finzlylogo.png'),
          ],
        ),
      ),
    );
  }
}

var value;

class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail: Text('finzly@finzly.com'),
            accountName: Text(''),
            currentAccountPicture: CircleAvatar(
              radius: 30.0,
              backgroundImage: AssetImage("assets/finzlylogo.png"),
            ),
            decoration: BoxDecoration(
              color: Color(hexcolor('02d0cb')), //Colors.deepPurple[600],
            ),
          ),
          /*DrawerHeader(
            child: Center(
              child: Text(
                'Login',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
            decoration: BoxDecoration(
              color: Color(hexcolor('61417f')), //Colors.deepPurple[600],
            ),
          ),*/
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Create Loan'),
            onTap: () => {
              Navigator.pop(context),
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new LoanPage()))
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Manage Loans'),
            onTap: () => {
              Navigator.of(context).pop(),
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new LoandetailsPage()))
            },
          ),
          /*ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Feedback'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {Navigator.of(context).pop()},
          ),*/
        ],
      ),
    );
  }
}
