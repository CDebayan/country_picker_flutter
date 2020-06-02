import 'package:countrypickerflutter/country_model.dart';
import 'package:countrypickerflutter/country_picker.dart';
import 'package:countrypickerflutter/country_picker_screen.dart';
import 'package:countrypickerflutter/functionality.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget with Functionality{
  final CountryPicker _countryPicker = CountryPicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          TextField(onChanged: (value){
            _countryPicker.searchCountryByCode(value).then((value){
              if(isValidObject(value)){
                if (isValidString(value.name)) {
                  print(value.name);
                }
              }
            });
          },),

          RaisedButton(onPressed: () async {
            CountryModel countryModel = await _countryPicker.showScreen(context);
            print(countryModel);
          }),
        ],
      ),
    );
  }
}
