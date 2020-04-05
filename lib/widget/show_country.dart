import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ungmonitorcovid/models/country_model.dart';

class ShowCountry extends StatefulWidget {
  @override
  _ShowCountryState createState() => _ShowCountryState();
}

class _ShowCountryState extends State<ShowCountry> {
  // Field
  List<CountryModel> countryModels = List();

  // Method
  @override
  void initState() {
    super.initState();
    readAllAPI();
  }

  Future<void> readAllAPI() async {
    String url = 'https://corona.lmao.ninja/countries?sort=case';

    try {
      Response response = await Dio().get(url);
      print('response = $response');

      for (var map in response.data) {
        CountryModel countryModel = CountryModel.fromJson(map);
        setState(() {
          countryModels.add(countryModel);
        });
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: countryModels.length,
        itemBuilder: (BuildContext buildContext, int index) {
          return Row(
            children: <Widget>[
              showFlag(index),
              showText(index)
            ],
          );
        });
  }

  Widget showText(int index) => Column(
    children: <Widget>[
      Text(countryModels[index].country),Text(countryModels[index].cases.toString())
    ],
  );

  Widget showFlag(int index) {

    String urlFlag = countryModels[index].countryInfo.flag.toString();

    return Container(padding: EdgeInsets.all(10.0),
              width: 150.0,
              child: Image.network(urlFlag),
            );
  }
}
