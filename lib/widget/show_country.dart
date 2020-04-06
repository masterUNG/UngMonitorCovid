import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ungmonitorcovid/models/country_model.dart';
import 'package:ungmonitorcovid/utility/my_style.dart';

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
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: index % 2 == 0
                    ? <Color>[Colors.white, Colors.green.shade900]
                    : <Color>[Colors.white, Colors.green.shade300],
              ),
            ),
            child: Row(
              children: <Widget>[showFlag(index), showText(index)],
            ),
          );
        });
  }

  Widget showText(int index) => Container(
        padding: EdgeInsets.all(10.0),
        width: MediaQuery.of(context).size.width * 0.6,
        child: Column(
          children: <Widget>[
            showNameCountry(index),
            showCases(index),
            showTodayCases(index),
          ],
        ),
      );

  Widget showCases(int index) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            'Cases = ${countryModels[index].cases.toString()}',
            style: TextStyle(
              fontSize: 18.0,
              color: index % 2 == 0 ? Colors.white54 : MyStyle().primaryColor,
            ),
          ),
        ],
      );

  Widget showTodayCases(int index) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            'Today Cases = ${countryModels[index].todayCases.toString()}',
            style: TextStyle(
              fontSize: 18.0,
              color: index % 2 == 0 ? Colors.white : MyStyle().darkColor,
            ),
          ),
        ],
      );

  Widget showNameCountry(int index) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            countryModels[index].country,
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              color: index % 2 == 0 ? Colors.white : MyStyle().darkColor,
            ),
          ),
        ],
      );

  Widget showFlag(int index) {
    String urlFlag = countryModels[index].countryInfo.flag.toString();

    return Container(
      padding: EdgeInsets.all(10.0),
      width: MediaQuery.of(context).size.width * 0.4,
      child: Image.network(urlFlag),
    );
  }
}
