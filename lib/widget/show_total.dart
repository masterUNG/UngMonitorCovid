import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ungmonitorcovid/models/total_model.dart';
import 'package:ungmonitorcovid/utility/my_style.dart';

class ShowTotal extends StatefulWidget {
  @override
  _ShowTotalState createState() => _ShowTotalState();
}

class _ShowTotalState extends State<ShowTotal> {
  // Filed
  TotalModel model;

  // Method
  @override
  void initState() {
    super.initState();
    readData();
  }

  Future<void> readData() async {
    String url = 'https://corona.lmao.ninja/all';

    try {
      Response response = await Dio().get(url);
      setState(() {
        model = TotalModel.fromJson(response.data);
      });
      print('Cases ==> ${model.cases}');
    } catch (e) {
      print('e on showTotal ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: model == null ? CircularProgressIndicator() : showContent(),
    );
  }

  Column showContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[showCase()],
    );
  }

  Widget showCase() {
    return Container(
      child: MyStyle().showCard(
        'Cases',
        model.cases.toString(),
      ),
    );
  }
}
