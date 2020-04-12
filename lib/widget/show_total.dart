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

  Widget showCard(String title, String message, Color color) {
    return Container(
      height: 120.0,
      child: Card(
        color: color,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(title),
              Text(message),
            ],
          ),
        ),
      ),
    );
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
      children: <Widget>[
        showCard('Total Case', model.cases.toString(), Colors.yellow),
        showOther()
      ],
    );
  }

  Widget showOther() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Expanded(
            child: showCard(
                'Today Case', model.todayCases.toString(), Colors.blue)),
        Expanded(
            child: showCard('Deaths', model.deaths.toString(), Colors.purple)),
        Expanded(
            child: showCard(
                'Today Deaths', model.todayDeaths.toString(), Colors.brown)),
      ],
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
