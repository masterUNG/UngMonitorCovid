import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ungmonitorcovid/utility/my_style.dart';
import 'package:ungmonitorcovid/widget/authen.dart';
import 'package:ungmonitorcovid/widget/show_country.dart';
import 'package:ungmonitorcovid/widget/show_total.dart';

class MyService extends StatefulWidget {
  @override
  _MyServiceState createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
  // Field
  String nameLogin, urlLogin;
  Widget currentWidget = ShowCountry();

  // Method

  @override
  void initState() {
    super.initState();
    readUserDataFromFirestore();
  }

  Future<String> findUID() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await auth.currentUser();
    return firebaseUser.uid;
  }

  Future<void> readUserDataFromFirestore() async {
    String uid = await findUID();
    print('uid = $uid');

    Firestore firestore = Firestore.instance;
    CollectionReference collectionReference = firestore.collection('User');
    await collectionReference.document(uid).snapshots().listen((response) {
      var snapshot = response.data;
      print('snapshot = $snapshot');
      setState(() {
        nameLogin = snapshot['Name'];
        urlLogin = snapshot['Url'];
      });
    });
  }

  Widget showAvarar() {
    return urlLogin == null
        ? SizedBox()
        : CircleAvatar(
            backgroundImage: NetworkImage(urlLogin),
          );
  }

  Widget headDrawer() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('images/covid.jpg'), fit: BoxFit.cover),
      ),
      currentAccountPicture: showAvarar(),
      accountName: nameLogin == null ? Text('Welcome to App') : Text(nameLogin),
      accountEmail: Text(
        'Login',
      ),
    );
  }

  Widget menuShow(IconData iconData, String title, Widget showWidget) {
    return ListTile(
      leading: Icon(iconData),
      title: Text(title),
      onTap: () {
        setState(() {
          currentWidget = showWidget;
        });
        Navigator.of(context).pop();
      },
    );
  }

  Widget menuSignOut() {
    return ListTile(
      onTap: () {
        processSignOut();
        Navigator.of(context).pop();
      },
      title: Text('Sign Out'),
      leading: Icon(Icons.exit_to_app),
    );
  }

  Future<void> processSignOut() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut().then((value) {
      MaterialPageRoute materialPageRoute = MaterialPageRoute(
        builder: (value) => Authen(),
      );
      Navigator.of(context)
          .pushAndRemoveUntil(materialPageRoute, (value) => false);
    });
  }

  Widget showSideBar() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          headDrawer(),
          menuShow(Icons.home, 'Show List Country', ShowCountry()),
          menuShow(Icons.android, 'Total', ShowTotal()),
          menuSignOut(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentWidget,
      drawer: showSideBar(),
      appBar: AppBar(
        backgroundColor: MyStyle().darkColor,
      ),
    );
  }
}
