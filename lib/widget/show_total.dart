import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


class ShowTotal extends StatefulWidget {
  @override
  _ShowTotalState createState() => _ShowTotalState();
}

class _ShowTotalState extends State<ShowTotal> {

  // Filed

  // Method
  @override
  void initState() { 
    super.initState();
    readData();
  }

  Future<void> readData()async{

    String url = 'https://corona.lmao.ninja/all';

    try {

      Response response = await Dio().get(url);
      var result = json.decode(response.data);
      print('result ==>> $result');
      
    } catch (e) {
      print('e on showTotal ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'This is Total'
    );
  }
}