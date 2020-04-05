import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ungmonitorcovid/utility/my_style.dart';
import 'package:ungmonitorcovid/utility/normal_dialog.dart';
import 'package:ungmonitorcovid/widget/my_service.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Field
  File file;
  String name, email, password, urlAvatar, uidUser;

  // Method

  Widget nameForm() {
    String title = 'Name :';
    String helper = 'Type Your Name in Blank';
    Color color = Colors.green[700];

    return TextField(
      onChanged: (value) => name = value.trim(),
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: color),
        ),
        helperStyle: TextStyle(color: color),
        helperText: helper,
        icon: Icon(
          Icons.account_box,
          size: 36.0,
          color: color,
        ),
        labelStyle: TextStyle(color: color),
        labelText: title,
      ),
    );
  }

  Widget emailForm() {
    String title = 'Email :';
    String helper = 'Type Your Email in Blank';
    Color color = Colors.orange[700];

    return TextField(
      onChanged: (value) => email = value.trim(),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: color),
        ),
        helperStyle: TextStyle(color: color),
        helperText: helper,
        icon: Icon(
          Icons.email,
          size: 36.0,
          color: color,
        ),
        labelStyle: TextStyle(color: color),
        labelText: title,
      ),
    );
  }

  Widget passowrdForm() {
    String title = 'Password :';
    String helper = 'Type Your Password in Blank';
    Color color = Colors.purple[700];

    return TextField(
      onChanged: (value) => password = value.trim(),
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: color),
        ),
        helperStyle: TextStyle(color: color),
        helperText: helper,
        icon: Icon(
          Icons.lock,
          size: 36.0,
          color: color,
        ),
        labelStyle: TextStyle(color: color),
        labelText: title,
      ),
    );
  }

  Widget cameraButton() {
    return IconButton(
      icon: Icon(
        Icons.add_a_photo,
        size: 36.0,
      ),
      onPressed: () => chooseAvatar(ImageSource.camera),
    );
  }

  Future<void> chooseAvatar(ImageSource imageSource) async {
    try {
      var object = await ImagePicker.pickImage(
        source: imageSource,
        maxWidth: 800.0,
        maxHeight: 800.0,
      );

      setState(() {
        file = object;
      });
    } catch (e) {}
  }

  Widget galleryButton() {
    return IconButton(
      icon: Icon(
        Icons.add_photo_alternate,
        size: 36.0,
      ),
      onPressed: () => chooseAvatar(ImageSource.gallery),
    );
  }

  Widget showButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        cameraButton(),
        galleryButton(),
      ],
    );
  }

  Widget showAvatar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      child: file == null ? Image.asset('images/avatar.png') : Image.file(file),
    );
  }

  Widget registerButton() {
    return IconButton(
      tooltip: 'Upload To Server',
      icon: Icon(Icons.cloud_upload),
      onPressed: () {
        if (file == null) {
          normalDialog(
              context, 'Non Choose Image', 'Please Click Camera or Gallery');
        } else if (name == null ||
            name.isEmpty ||
            email == null ||
            email.isEmpty ||
            password == null ||
            password.isEmpty) {
          normalDialog(context, 'Have Space', 'Please Fill Every Blank');
        } else {
          print('name = $name, email = $email, password = $password');
          uploadFileToFirestore();
        }
      },
    );
  }

  Future<void> uploadFileToFirestore() async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;

    Random random = Random();
    int i = random.nextInt(100000);
    String nameAvatar = 'avatar$i.jpg';

    StorageReference storageReference =
        firebaseStorage.ref().child('Avatar/$nameAvatar');
    StorageUploadTask storageUploadTask = storageReference.putFile(file);
    urlAvatar = await (await storageUploadTask.onComplete).ref.getDownloadURL();
    print('urlAvatar = $urlAvatar');
    authenFirebase();
  }

  Future<void> authenFirebase() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((response) {
      uidUser = response.user.uid;
      print('Register Success uid = $uidUser');
      insertValutFirestore();
    }).catchError((response) {
      String title = response.code;
      String message = response.message;
      normalDialog(context, title, message);
    });
  }

  Future<void> insertValutFirestore() async {
    Map<String, dynamic> map = Map();
    map['Name'] = name;
    map['Url'] = urlAvatar;

    Firestore firestore = Firestore.instance;
    CollectionReference collectionReference = firestore.collection('User');

    await collectionReference.document(uidUser).setData(map).then((response) {
      MaterialPageRoute route = MaterialPageRoute(
        builder: (value) => MyService(),
      );
      Navigator.of(context).pushAndRemoveUntil(route, (value)=>false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(30.0),
        children: <Widget>[
          showAvatar(),
          showButton(),
          nameForm(),
          emailForm(),
          passowrdForm(),
        ],
      ),
      appBar: AppBar(
        actions: <Widget>[registerButton()],
        title: Text('Register'),
        backgroundColor: MyStyle().darkColor,
      ),
    );
  }
}
